import test from 'node:test'
import assert from 'node:assert/strict'
import { readFile } from 'node:fs/promises'
import vm from 'node:vm'
import { REFRESH_INTERVAL_MS } from './settings.mjs'

test('direct CJS GUI registers its contributions, calls RPC, and disposes its timer', async () => {
  const source = await readFile(new URL('./gui-experimental.cjs', import.meta.url), 'utf8')
  const tokens = { Panel: {}, Plugin: { define: value => value }, Slot: {}, TitlebarItem: {} }
  let timerCancelled = false, opened, calls = 0
  const modules = {
    '@opencode/plugin/gui': tokens,
    '@opencode/plugin/rpc': { Rpc: { define: value => value } },
    'solid-js': { createSignal: initial => { let value = initial; return [() => value, next => { value = next }] }, createEffect: fn => fn() },
  }
  const exports = {}
  const sandbox = { module: { exports }, exports, require: name => { assert.ok(modules[name], `unexpected import ${name}`); return modules[name] },
    setInterval: (_fn, ms) => { assert.equal(ms, REFRESH_INTERVAL_MS); return 12 }, clearInterval: id => { assert.equal(id, 12); timerCancelled = true },
    document: { createElement: tag => ({ tag, children: [], style: {}, attributes: {}, setAttribute(name, value) { this.attributes[name] = String(value) }, removeAttribute(name) { delete this.attributes[name] }, append(...children) { this.children.push(...children) }, replaceChildren(...children) { this.children = children } }) } }
  vm.runInNewContext(source, sandbox)
  const items = new Map()
  const session = { id: 'synthetic-session' }
  const stop = sandbox.module.exports.default.setup({
    client: { rpc: contract => { assert.equal(contract.id, 'usage-budget'); return { read: async () => { calls++; return { status: 'complete', primary: { remainingPercent: 80 }, secondary: { remainingPercent: 25 } } } } } },
    id: 'usage-budget', sessions: { current: () => session },
    add: (token, item) => items.set(token, item), layout: { open: (key, target, options) => { opened = { key, target, options } } },
  })
  const unavailable = items.get(tokens.Slot).render()
  assert.equal(unavailable.children[1].children[0].textContent, 'P Unavailable')
  assert.equal(unavailable.children[1].children[1].hidden, true)
  assert.equal(unavailable.children[1].children[1].style.display, 'none')
  assert.match(unavailable.attributes['aria-label'], /Primary: Unavailable/)
  await new Promise(resolve => setImmediate(resolve))
  assert.equal(calls, 1)
  assert.equal(items.has(tokens.TitlebarItem), false)
  const status = items.get(tokens.Slot).render()
  assert.match(status.attributes['aria-label'], /Primary: 80% remaining.*Secondary: ! 25% remaining/)
  assert.equal(status.children[1].children[0].textContent, 'P 80%')
  assert.equal(status.children[2].children[0].textContent, 'S ! 25%')
  assert.equal(status.children[1].children[1].children[0].style.width, '80%')
  assert.equal(status.children[1].children[2].textContent, 'reset unavailable')
  assert.match(status.title, /reset unavailable/)
  assert.notEqual(status.children[1].children[0].style.color, status.children[2].children[0].style.color)
  status.onclick()
  assert.equal(opened.key, 'usage-budget:budget')
  assert.equal(opened.target, session)
  assert.equal(opened.options.tab, 'select')
  const panel = items.get(tokens.Panel)
  assert.equal(panel.id, 'budget')
  assert.equal(panel.region, 'side')
  const [tab] = panel.list({ open: [] })
  assert.equal(tab.id, 'budget')
  assert.equal(tab.title, 'Abo-Budget')
  assert.equal(tab.pinned, true)
  assert.equal(tab.fallback, true)
  const content = panel.render({ session, screen: {} })
  assert.equal(content.children[0].textContent, 'Abo-Budget')
  const primary = content.children[1], secondary = content.children[2]
  assert.equal(primary.children[0].children[0].textContent, 'Primary')
  assert.equal(primary.children[0].children[1].textContent, '80% remaining')
  assert.equal(primary.children[1].attributes.role, 'progressbar')
  assert.equal(primary.children[1].attributes['aria-label'], 'Primary remaining budget')
  assert.equal(primary.children[1].attributes['aria-valuenow'], '80')
  assert.equal(primary.children[1].children[0].style.width, '80%')
  assert.equal(secondary.children[1].attributes['aria-valuenow'], '25')
  assert.notEqual(primary.children[1].children[0].style.backgroundColor, secondary.children[1].children[0].style.backgroundColor)
  assert.match(secondary.children[0].children[1].textContent, /! 25% remaining/)
  stop(); assert.equal(timerCancelled, true)
})

test('CJS RPC adapter matches the server contract', async () => {
  const rpcSource = await readFile(new URL('./rpc.ts', import.meta.url), 'utf8')
  const guiSource = await readFile(new URL('./gui-experimental.cjs', import.meta.url), 'utf8')
  const contracts = []
  const rpc = { Rpc: { define: value => { contracts.push(JSON.stringify(value)); return value } } }
  vm.runInNewContext(rpcSource.replace(/import .*\n/, '').replace('export const UsageBudget', 'const UsageBudget'), rpc)
  vm.runInNewContext(guiSource, { module: { exports: {} }, require: name => name === '@opencode/plugin/rpc' ? rpc : name === '@opencode/plugin/gui' ? { Plugin: { define: value => value } } : {} })
  assert.equal(contracts.length, 2)
  assert.deepEqual(JSON.parse(contracts[1]), JSON.parse(contracts[0]))
})
