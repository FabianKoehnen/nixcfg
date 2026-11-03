import { REFRESH_INTERVAL_MS } from './settings.mjs'

const ENDPOINT = 'https://chatgpt.com/backend-api/wham/usage'

function readWindow(value, now) {
  if (!value || typeof value !== 'object' || typeof value.used_percent !== 'number' || !Number.isFinite(value.used_percent) || value.used_percent < 0 || value.used_percent > 100 || typeof value.reset_at !== 'number' || !Number.isFinite(value.reset_at) || value.reset_at <= 0) return null
  const date = new Date(value.reset_at * 1000)
  if (!Number.isFinite(date.getTime())) return null
  const duration = value.limit_window_seconds
  const remainingPercent = 100 - value.used_percent
  const valid = typeof duration === 'number' && Number.isFinite(duration) && duration > 0 && date.getTime() > now
  const offset = valid ? remainingPercent - Math.min(100, (date.getTime() - now) / (duration * 1000) * 100) : null
  const severity = offset === null ? 'unknown' : offset <= -25 || remainingPercent <= 10 ? 'critical' : offset <= -5 || remainingPercent <= 20 ? 'warning' : 'normal'
  return { remainingPercent, resetsAt: date.toISOString(), ...(valid ? { windowSeconds: duration, offset: Math.round(offset * 10) / 10 || 0 } : {}), severity }
}

export function normalize(data, now = Date.now()) {
  const primary = readWindow(data?.rate_limit?.primary_window, now)
  const secondary = readWindow(data?.rate_limit?.secondary_window, now)
  return { status: primary && secondary ? 'complete' : primary || secondary ? 'partial' : 'unknown', fetchedAt: new Date(now).toISOString(), primary, secondary }
}

function accountId(credential) {
  const metadata = credential.metadata
  const explicit = metadata?.accountId ?? metadata?.account_id
  if (typeof explicit === 'string' && explicit) return explicit
  try {
    const claims = JSON.parse(Buffer.from(credential.access.split('.')[1], 'base64url').toString('utf8'))
    const id = claims['https://api.openai.com/auth']?.chatgpt_account_id
    return typeof id === 'string' && id ? id : undefined
  } catch { return undefined }
}

export function createReader({ connection, fetch: request = globalThis.fetch, now = Date.now }) {
  let cache
  return async (signal) => {
    try {
      const active = await connection.active('openai')
      if (!active) return normalize(null, now())
      const identity = JSON.stringify(active)
      if (cache && cache.identity === identity && now() < cache.until) return normalize(cache.data, now())
      cache = undefined
      const credential = await connection.resolve(active)
      if (credential?.type !== 'oauth' || typeof credential.access !== 'string' || !credential.access) return normalize(null, now())
      const headers = { Authorization: `Bearer ${credential.access}`, Accept: 'application/json' }
      const id = accountId(credential)
      if (id) headers['ChatGPT-Account-Id'] = id
      const response = await request(ENDPOINT, { method: 'GET', headers, redirect: 'error', signal })
      if (!response.ok) return normalize(null, now())
      const time = now()
      const data = await response.json()
      const result = normalize(data, time)
      const resets = [result.primary, result.secondary].filter(Boolean).map(value => Date.parse(value.resetsAt))
      const until = Math.min(time + REFRESH_INTERVAL_MS, ...resets)
      if (result.status !== 'unknown' && until > time) cache = { identity, until, data }
      return result
    } catch {
      cache = undefined
      return normalize(null, now())
    }
  }
}

export async function setup(ctx, rpc) {
  const read = createReader({ connection: ctx.integration.connection })
  if (rpc) await ctx.rpc.register(rpc, { read: async (_input, context) => read(context.signal) })
  await ctx.tool.transform(editor => {
    editor.add({
      name: 'usage_budget',
      description: 'Get normalized ChatGPT subscription usage windows; unknown means no reliable data.',
      input: { type: 'object', properties: {}, additionalProperties: false },
      options: { codemode: true },
      execute: async (_input, context) => ({ content: JSON.stringify(await read(context.signal)) }),
    })
  })
}
