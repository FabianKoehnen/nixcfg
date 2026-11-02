// OpenCode Desktop's GUI API is experimental (v2.2.0+). This entry is
// deliberately self-contained: the GUI loader cannot load additional chunks.
const { Panel, Plugin, Slot } = require('@opencode/plugin/gui')
const { Rpc } = require('@opencode/plugin/rpc')
const { createEffect, createSignal } = require('solid-js')

// CJS adapter for rpc.ts. gui-entry.test.mjs checks the entire contract for drift.
const UsageBudget = Rpc.define({
  id: 'usage-budget',
  methods: { read: { input: { type: 'object', properties: {}, additionalProperties: false }, output: {
    type: 'object',
    properties: {
      status: { type: 'string', enum: ['complete', 'partial', 'unknown'] },
      fetchedAt: { type: 'string' },
      primary: { anyOf: [{ type: 'null' }, { type: 'object', properties: { remainingPercent: { type: 'number' }, resetsAt: { type: 'string' } }, required: ['remainingPercent', 'resetsAt'], additionalProperties: false }] },
      secondary: { anyOf: [{ type: 'null' }, { type: 'object', properties: { remainingPercent: { type: 'number' }, resetsAt: { type: 'string' } }, required: ['remainingPercent', 'resetsAt'], additionalProperties: false }] },
    },
    required: ['status', 'fetchedAt', 'primary', 'secondary'],
    additionalProperties: false,
  } } },
  events: {},
})

function formatWindow(window, now) {
  const percent = window?.remainingPercent
  if (typeof percent !== 'number' || !Number.isFinite(percent) || percent < 0 || percent > 100) return { percent: 'Unavailable', bar: '░░░░░░░░░░', marker: '', reset: 'reset unavailable', valid: false }
  const date = typeof window.resetsAt === 'string' ? Date.parse(window.resetsAt) : NaN
  const minutes = Math.max(0, Math.ceil((date - now) / 60_000))
  const reset = !Number.isFinite(date) ? 'reset unavailable' : minutes === 0 ? 'reset due' : minutes < 60 ? `resets in ${minutes}m` : minutes < 1440 ? `resets in ${Math.floor(minutes / 60)}h ${minutes % 60}m` : `resets in ${Math.floor(minutes / 1440)}d ${Math.floor(minutes % 1440 / 60)}h`
  const filled = Math.round(percent / 10)
  const severity = percent <= 20 ? 'critical' : percent <= 40 ? 'warning' : 'normal'
  return {
    percent: `${percent}% remaining`,
    bar: '█'.repeat(filled) + '░'.repeat(10 - filled),
    marker: severity === 'critical' ? '!!' : severity === 'warning' ? '!' : '',
    reset,
    valid: true,
  }
}

function budgetView(usage, now = Date.now()) {
  const primary = formatWindow(usage?.primary, now)
  const secondary = formatWindow(usage?.secondary, now)
  const complete = usage?.status === 'complete' && primary.valid && secondary.valid
  return {
    label: complete ? `Budget ${Math.min(usage.primary.remainingPercent, usage.secondary.remainingPercent)}%` : 'Budget unavailable',
    primary: `${primary.bar} ${primary.marker} ${primary.percent} · ${primary.reset}`,
    secondary: `${secondary.bar} ${secondary.marker} ${secondary.percent} · ${secondary.reset}`,
  }
}

function windowColor(value, formatted) {
  const severity = !formatted.valid ? 'unknown' : value.remainingPercent <= 20 ? 'critical' : value.remainingPercent <= 40 ? 'warning' : 'normal'
  return {
    critical: 'var(--icon-critical-base, #dc2626)',
    warning: 'var(--icon-warning-base, #b45309)',
    normal: 'var(--icon-success-base, #15803d)',
    unknown: 'var(--text-weak, #737373)',
  }[severity]
}

function windowElement(name, value) {
  const formatted = formatWindow(value, Date.now())
  const color = windowColor(value, formatted)
  const root = document.createElement('div')
  root.style.marginTop = '1rem'
  const header = document.createElement('div')
  header.style.cssText = 'display: flex; justify-content: space-between; gap: 0.75em; flex-wrap: wrap'
  const label = document.createElement('div')
  label.textContent = name
  label.style.fontWeight = '600'
  const details = document.createElement('div')
  details.style.color = color
  details.textContent = `${formatted.marker ? `${formatted.marker} ` : ''}${formatted.percent}`
  header.append(label, details)
  const track = document.createElement('div')
  track.setAttribute('role', 'progressbar')
  track.setAttribute('aria-label', `${name} remaining budget`)
  track.setAttribute('aria-valuemin', '0')
  track.setAttribute('aria-valuemax', '100')
  track.setAttribute('aria-valuetext', formatted.percent)
  if (formatted.valid) track.setAttribute('aria-valuenow', String(value.remainingPercent))
  track.style.cssText = 'height: 8px; border-radius: 999px; overflow: hidden; margin-top: 6px; background: var(--surface-base-hover, #80808055)'
  track.hidden = !formatted.valid
  const fill = document.createElement('div')
  fill.style.height = '100%'
  fill.style.width = formatted.valid ? `${value.remainingPercent}%` : '0%'
  fill.style.backgroundColor = color
  track.append(fill)
  const reset = document.createElement('div')
  reset.style.marginTop = '4px'
  reset.style.color = 'var(--text-weak, #737373)'
  reset.textContent = formatted.reset
  root.append(header, track, reset)
  return root
}

module.exports.default = Plugin.define({
  setup(ctx) {
    const [usage, setUsage] = createSignal({ status: 'unknown', primary: null, secondary: null })
    let stopped = false, pending = false
    const refresh = async () => {
      if (pending || stopped) return
      pending = true
      try {
        const value = await ctx.client.rpc(UsageBudget).read({})
        if (!stopped) setUsage(value)
      } catch {
        if (!stopped) setUsage({ status: 'unknown', primary: null, secondary: null })
      } finally { pending = false }
    }
    void refresh()
    // Keep in sync with settings.mjs (also checked by gui-entry.test.mjs).
    const timer = setInterval(refresh, 30_000)
    const openBudgetPanel = () => {
      const session = ctx.sessions.current()
      if (session) ctx.layout.open(`${ctx.id}:budget`, session, { tab: 'select' })
    }
    ctx.add(Slot, {
      at: 'window.bottom',
      render: () => {
        const button = document.createElement('button')
        button.type = 'button'
        button.style.cssText = 'display: flex; justify-content: center; align-items: center; flex-wrap: wrap; gap: 0.5em; width: 100%; max-width: 100%; font: inherit; color: inherit; background: transparent; border: 0; cursor: pointer'
        button.onclick = openBudgetPanel
        createEffect(() => {
          const value = usage()
          const primary = formatWindow(value?.primary, Date.now())
          const secondary = formatWindow(value?.secondary, Date.now())
          const description = (name, item) => `${name}: ${item.marker ? `${item.marker} ` : ''}${item.percent}, ${item.reset}`
          const summary = `${description('Primary', primary)}; ${description('Secondary', secondary)}`
          button.title = `${summary} — open session budget panel`
          button.setAttribute('aria-label', button.title)
          const label = document.createElement('span')
          label.textContent = 'Budget'
          const item = (short, window, formatted) => {
            const group = document.createElement('span')
            group.style.cssText = 'display: inline-flex; align-items: center; flex-wrap: wrap; gap: 0.35em; max-width: 100%'
            const text = document.createElement('span')
            text.style.color = windowColor(window, formatted)
            text.style.whiteSpace = 'nowrap'
            text.textContent = `${short} ${formatted.marker ? `${formatted.marker} ` : ''}${formatted.valid ? `${window.remainingPercent}%` : 'Unavailable'}`
            const track = document.createElement('span')
            track.style.cssText = 'display: inline-block; width: 3em; height: 5px; border-radius: 999px; overflow: hidden; background: var(--surface-base-hover, #80808055)'
            track.hidden = !formatted.valid
            if (!formatted.valid) track.style.display = 'none'
            track.setAttribute('aria-hidden', 'true')
            const fill = document.createElement('span')
            fill.style.cssText = 'display: block; height: 100%'
            fill.style.width = formatted.valid ? `${window.remainingPercent}%` : '0%'
            fill.style.backgroundColor = windowColor(window, formatted)
            track.append(fill)
            const reset = document.createElement('span')
            reset.style.color = 'var(--text-weak, #737373)'
            reset.style.whiteSpace = 'nowrap'
            reset.textContent = formatted.reset
            group.append(text, track, reset)
            return group
          }
          button.replaceChildren(label, item('P', value?.primary, primary), item('S', value?.secondary, secondary))
        })
        return button
      },
    })
    const budgetTab = { id: 'budget', title: 'Abo-Budget', pinned: true, fallback: true }
    ctx.add(Panel, {
      id: 'budget',
      region: 'side',
      list: () => [budgetTab],
      render: () => {
        const root = document.createElement('section')
        const heading = document.createElement('h2')
        heading.textContent = 'Abo-Budget'
        root.append(heading)
        createEffect(() => {
          const value = usage()
          root.replaceChildren(heading, windowElement('Primary', value?.primary), windowElement('Secondary', value?.secondary))
        })
        return root
      },
    })
    return () => { stopped = true; clearInterval(timer) }
  },
})
