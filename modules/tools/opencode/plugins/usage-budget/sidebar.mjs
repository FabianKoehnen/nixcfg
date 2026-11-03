import { REFRESH_INTERVAL_MS } from './settings.mjs'

export function formatWindow(window, now = Date.now()) {
  const percent = window?.remainingPercent
  if (typeof percent !== 'number' || !Number.isFinite(percent) || percent < 0 || percent > 100) return { percent: 'Unavailable', bar: '░░░░░░░░░░', reset: 'reset unavailable', severity: 'unknown', marker: '' }
  const date = typeof window.resetsAt === 'string' ? Date.parse(window.resetsAt) : NaN
  const minutes = Math.max(0, Math.ceil((date - now) / 60_000))
  const reset = !Number.isFinite(date) ? 'reset unavailable' : minutes === 0 ? 'reset due' : minutes < 60 ? `resets in ${minutes}m` : minutes < 1440 ? `resets in ${Math.floor(minutes / 60)}h ${minutes % 60}m` : `resets in ${Math.floor(minutes / 1440)}d ${Math.floor(minutes % 1440 / 60)}h`
  const filled = Math.round(percent / 10)
  const severity = date > now && ['normal', 'warning', 'critical'].includes(window.severity) ? window.severity : 'unknown'
  const rounded = severity !== 'unknown' && Number.isFinite(window.offset) ? window.offset : null
  return { percent: `${percent}% remaining${rounded === null ? '' : ` (${rounded > 0 ? '+' : ''}${rounded} pp)`}`, bar: '█'.repeat(filled) + '░'.repeat(10 - filled), reset, severity, marker: severity === 'critical' ? '!!' : severity === 'warning' ? '!' : '' }
}

export function startRefresh({ read, update, schedule = setInterval, cancel = clearInterval }) {
  let stopped = false, pending = false
  const refresh = async () => {
    if (pending || stopped) return
    pending = true
    try {
      const value = await read()
      if (!stopped) update(value)
    } catch {
      if (!stopped) update({ status: 'unknown', primary: null, secondary: null })
    } finally { pending = false }
  }
  void refresh()
  const timer = schedule(refresh, REFRESH_INTERVAL_MS)
  return () => { stopped = true; cancel(timer) }
}
