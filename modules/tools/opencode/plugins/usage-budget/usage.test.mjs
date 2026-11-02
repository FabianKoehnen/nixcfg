import test from 'node:test'
import assert from 'node:assert/strict'
import { normalize, createReader, setup } from './usage.mjs'

const window = (used, reset = 2_000) => ({ used_percent: used, reset_at: reset })
const payload = { rate_limit: { primary_window: window(25), secondary_window: window(70, 3_000) } }
const credential = { type: 'oauth', access: 'synthetic-token', metadata: { accountId: 'synthetic-account' } }

test('normalizes both windows without leaking extra data', () => {
  assert.deepEqual(normalize(payload, 1_000_000), {
    status: 'complete', fetchedAt: '1970-01-01T00:16:40.000Z',
    primary: { remainingPercent: 75, resetsAt: '1970-01-01T00:33:20.000Z' },
    secondary: { remainingPercent: 30, resetsAt: '1970-01-01T00:50:00.000Z' },
  })
})

test('invalid and missing windows are unknown, not complete', () => {
  for (const value of [undefined, null, window(101), window(-1), window('10'), window(2, -1)]) {
    const result = normalize({ rate_limit: { primary_window: window(0), secondary_window: value } }, 1_000_000)
    assert.equal(result.status, 'partial')
    assert.equal(result.secondary, null)
  }
  assert.equal(normalize({}, 1_000_000).status, 'unknown')
})

test('uses fixed endpoint, forbids redirects and caches until reset', async () => {
  let now = 1_000_000, calls = 0
  const reader = createReader({ connection: { active: async () => ({}), resolve: async () => credential }, now: () => now,
    fetch: async (url, options) => { calls++; assert.equal(url, 'https://chatgpt.com/backend-api/wham/usage'); assert.equal(options.redirect, 'error'); assert.equal(options.headers.Authorization, 'Bearer synthetic-token'); return { ok: true, json: async () => payload } } })
  assert.equal((await reader()).status, 'complete')
  now += 29_000; await reader(); assert.equal(calls, 1)
  now += 1_000; await reader(); assert.equal(calls, 2)
})

test('reset invalidates the cache early', async () => {
  let now = 1_000_000, calls = 0
  const reader = createReader({ connection: { active: async () => ({}), resolve: async () => credential }, now: () => now,
    fetch: async () => { calls++; return { ok: true, json: async () => ({ rate_limit: { primary_window: window(10, 1010), secondary_window: window(20, 3000) } }) } } })
  await reader(); now += 10_000; await reader(); assert.equal(calls, 2)
})

test('errors are sanitized and unsupported credentials never contact network', async () => {
  let calls = 0
  const reader = createReader({ connection: { active: async () => ({}), resolve: async () => ({ type: 'key', key: 'synthetic-secret' }) }, fetch: async () => { calls++; throw Error('synthetic-secret') } })
  const result = await reader()
  assert.equal(result.status, 'unknown'); assert.equal(calls, 0); assert.ok(!JSON.stringify(result).includes('synthetic-secret'))
  const failing = createReader({ connection: { active: async () => { throw Error('synthetic-secret') } } })
  assert.ok(!JSON.stringify(await failing()).includes('synthetic-secret'))
})

test('registers a Code Mode tool returning only normalized content', async () => {
  let definition
  await setup({ integration: { connection: { active: async () => undefined } }, tool: { transform: async fn => fn({ add: value => { definition = value } }) } })
  assert.equal(definition.options.codemode, true)
  const output = await definition.execute({}, { signal: new AbortController().signal })
  assert.equal(JSON.parse(output.content).status, 'unknown')
})

test('network failure never returns exception details', async () => {
  const reader = createReader({ connection: { active: async () => ({}), resolve: async () => credential }, fetch: async () => { throw Error('synthetic-secret') } })
  assert.equal(JSON.stringify(await reader()).includes('synthetic-secret'), false)
})

test('account changes invalidate cache before the timeout', async () => {
  let account = 1, calls = 0
  const reader = createReader({ connection: { active: async () => ({ id: account }), resolve: async () => credential }, now: () => 1_000_000, fetch: async () => { calls++; return { ok: true, json: async () => payload } } })
  await reader(); account = 2; await reader(); assert.equal(calls, 2)
})

test('cache expires at the shared 30 second interval', async () => {
  let now = 1_000_000, calls = 0
  const reader = createReader({ connection: { active: async () => ({}), resolve: async () => credential }, now: () => now, fetch: async () => { calls++; return { ok: true, json: async () => payload } } })
  await reader(); now += 29_999; await reader(); assert.equal(calls, 1)
  now++; await reader(); assert.equal(calls, 2)
})

test('sidebar refreshes immediately and on interval and clears on errors and disposal', async () => {
  const { startRefresh, formatWindow } = await import('./sidebar.mjs')
  let tick, cleared = false, calls = 0
  const values = []
  const stop = startRefresh({ read: async () => { if (++calls === 2) throw Error('secret'); return normalize(payload, 1_000_000) }, update: value => values.push(value), schedule: (fn, ms) => { tick = fn; assert.equal(ms, 30_000); return 123 }, cancel: id => { assert.equal(id, 123); cleared = true } })
  await new Promise(resolve => setImmediate(resolve))
  assert.equal(formatWindow(values[0].primary, 1_000_000).percent, '75% remaining')
  await tick(); assert.equal(values[1].status, 'unknown')
  stop(); assert.equal(cleared, true)
})

test('sidebar displays semantic thresholds, bars, relative resets and missing data', async () => {
  const { formatWindow } = await import('./sidebar.mjs')
  const show = percent => formatWindow({ remainingPercent: percent, resetsAt: '1970-01-01T00:33:20.000Z' }, 1_000_000)
  assert.deepEqual(show(75), { percent: '75% remaining', bar: '████████░░', reset: 'resets in 17m', severity: 'normal', marker: '' })
  assert.equal(show(40).severity, 'warning'); assert.equal(show(40).marker, '!')
  assert.equal(show(20).severity, 'critical'); assert.equal(show(20).marker, '!!')
  assert.equal(formatWindow(null, 1_000_000).percent, 'Unavailable')
  assert.equal(formatWindow({ remainingPercent: 50 }, 1_000_000).reset, 'reset unavailable')
})
