import type { Plugin } from "@opencode-ai/plugin"
import { readFile } from "node:fs/promises"
import { homedir } from "node:os"

const PROVIDER = "tensorx"
const BASE_URL = "https://api.tensorx.ai/v1"
const KEY_FILE = "~/.secrets/tensorx-api-key"
const TIMEOUT_MS = 8000
const NPM = "@ai-sdk/openai-compatible"
// Last resort, for models with no metadata from the API or models.dev.
const FALLBACK = { context: 131072, output: 32768 }

// Last resort only: when /model/info is unavailable there is no `mode` field
// to tell chat models from embeddings/audio ones.
const NON_CHAT = /(embedding|whisper|chatterbox|rerank|-tts|tts-)/i

const msg = (e: any) => e?.message ?? String(e)

// The key never lives in the config file or the Nix store: key file first,
// then environment. Only the source is ever logged, never the value.
async function readApiKey(): Promise<string | undefined> {
  try {
    const path = KEY_FILE[0] === "~" ? homedir() + KEY_FILE.slice(1) : KEY_FILE
    const key = (await readFile(path, "utf8")).trim()
    if (key) return key
  } catch {}
  return process.env.TENSORX_API_KEY || undefined
}

async function getJSON(base: string, path: string, key?: string): Promise<any[]> {
  const res = await fetch(base + path, {
    headers: { Accept: "application/json", ...(key ? { Authorization: `Bearer ${key}` } : {}) },
    signal: AbortSignal.timeout(TIMEOUT_MS),
  })
  if (!res.ok) throw new Error(`${path} -> HTTP ${res.status}`)
  const body: any = await res.json()
  const list = Array.isArray(body) ? body : body?.data
  if (!Array.isArray(list)) throw new Error(`${path} -> unexpected response shape`)
  return list
}

// One model record. Field priority: live API metadata > models.dev/config
// entry > conservative fallback.
function model(id: string, providerID: string, url: string, base: any, info: any) {
  const i = info ?? {}
  const caps = base?.capabilities ?? {}
  const bool = (v: any, d: boolean) => (typeof v === "boolean" ? v : d)
  const first = (vals: any[], d: number) => vals.find((v) => typeof v === "number" && v > 0) ?? d
  const usd = (perToken: any, known: any) => (typeof perToken === "number" ? Math.round(perToken * 1e10) / 1e4 : known ?? 0)
  const image = bool(i.supports_vision, caps.input?.image ?? false)
  const pdf = bool(i.supports_pdf_input, caps.input?.pdf ?? false)

  return {
    id,
    providerID,
    // api.id is what gets sent as "model" - always the model id, never the provider id.
    api: base?.api ?? { id, url, npm: NPM },
    name: base?.name ?? id.slice(id.indexOf("/") + 1),
    family: base?.family ?? (id.includes("/") ? id.split("/")[0] : undefined),
    status: "active" as const,
    capabilities: {
      temperature: bool(i.supported_openai_params?.includes("temperature"), caps.temperature ?? true),
      reasoning: bool(i.supports_reasoning, caps.reasoning ?? true),
      attachment: image || pdf,
      toolcall: bool(i.supports_function_calling, caps.toolcall ?? true),
      input: { text: true, audio: bool(i.supports_audio_input, caps.input?.audio ?? false), image, video: false, pdf },
      output: { text: true, audio: bool(i.supports_audio_output, caps.output?.audio ?? false), image: false, video: false, pdf: false },
      interleaved: false,
    },
    cost: {
      input: usd(i.input_cost_per_token, base?.cost?.input),
      output: usd(i.output_cost_per_token, base?.cost?.output),
      cache: {
        read: usd(i.cache_read_input_token_cost, base?.cost?.cache?.read),
        write: usd(i.cache_creation_input_token_cost, base?.cost?.cache?.write),
      },
    },
    limit: {
      context: first([i.max_tokens, i.max_input_tokens, base?.limit?.context], FALLBACK.context),
      output: first([i.max_output_tokens, base?.limit?.output], FALLBACK.output),
    },
    options: base?.options ?? {},
    headers: base?.headers ?? {},
    release_date: base?.release_date ?? "",
    variants: base?.variants,
  }
}

export const TensorXLiveModels: Plugin = async ({ client }) => {
  const log = async (level: "info" | "warn", message: string) => {
    try {
      await client.app.log({ body: { service: "tensorx-models", level, message } })
    } catch {}
  }

  return {
    // Runs before providers are built: inject the key into provider options so
    // no secret sits in config, or disable the provider if none exists.
    config: async (cfg: any) => {
      const key = await readApiKey()
      if (!key) {
        await log("warn", `no API key (${KEY_FILE} or $TENSORX_API_KEY); disabling provider`)
        const disabled = Array.isArray(cfg.disabled_providers) ? cfg.disabled_providers : (cfg.disabled_providers = [])
        if (!disabled.includes(PROVIDER)) disabled.push(PROVIDER)
        return
      }
      const provider = ((cfg.provider ??= {})[PROVIDER] ??= {})
      provider.options = { ...provider.options, apiKey: key }
    },

    provider: {
      id: PROVIDER,
      models: async (provider: any) => {
        // known = models.dev catalog merged with any config model overrides.
        const known: Record<string, any> = provider?.models ?? {}
        const url = String(provider?.options?.baseURL ?? Object.values(known)[0]?.api?.url ?? BASE_URL).replace(/\/+$/, "")
        const configured = provider?.options?.apiKey
        const key =
          typeof configured === "string" && configured && !configured.startsWith("{") ? configured : await readApiKey()

        // /models decides availability, /model/info supplies metadata. They
        // degrade independently: losing metadata still leaves a live list.
        const [ids, info] = await Promise.allSettled([getJSON(url, "/models", key), getJSON(url, "/model/info", key)])
        if (ids.status === "rejected") {
          await log("warn", `live lookup failed, keeping models.dev catalog: ${msg(ids.reason)}`)
          return known
        }

        const meta: Record<string, any> = {}
        if (info.status === "fulfilled") {
          // One entry per deployment; first wins.
          for (const e of info.value) if (typeof e?.model_name === "string") meta[e.model_name] ??= e.model_info ?? {}
        } else {
          await log("warn", `metadata lookup failed, using catalog values: ${msg(info.reason)}`)
        }

        const next: Record<string, any> = {}
        for (const entry of ids.value) {
          const id = entry?.id
          if (typeof id !== "string" || !id) continue
          const m = meta[id]
          // Prefer the API's mode field; fall back to a name guard only when
          // metadata is missing entirely.
          if (m?.mode ? m.mode !== "chat" : NON_CHAT.test(id)) continue
          next[id] = model(id, provider?.id ?? PROVIDER, url, known[id], m)
        }

        const dropped = Object.keys(known).filter((k) => !(k in next))
        const fresh = Object.keys(next).filter((k) => !known[k]).length
        await log(
          "info",
          `live catalog: ${Object.keys(next).length} models (${fresh} not in models.dev` +
            `${dropped.length ? `, ${dropped.length} stale dropped: ${dropped.join(", ")}` : ""})`,
        )
        return next
      },
    },
  }
}
