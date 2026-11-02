import test from 'node:test'
import assert from 'node:assert/strict'
import { readFile } from 'node:fs/promises'
import vm from 'node:vm'
import { formatWindow } from './sidebar.mjs'

const source = await readFile(new URL('./gui-experimental.cjs', import.meta.url), 'utf8')
const context = { module: { exports: {} }, require: name => name === '@opencode/plugin/gui' ? { Plugin: { define: value => value } } : name === '@opencode/plugin/rpc' ? { Rpc: { define: value => value } } : {} }
const budgetView = vm.runInNewContext(`${source}\nbudgetView`, context)

const now = 1_000_000
const window = (remainingPercent, reset = '1970-01-01T00:33:20.000Z') => ({ remainingPercent, resetsAt: reset })

test('shows both windows and the lowest remaining budget', () => {
  const view = budgetView({ status: 'complete', primary: window(75), secondary: window(30) }, now)
  assert.equal(view.label, 'Budget 30%')
  assert.equal(view.primary, '████████░░  75% remaining · resets in 17m')
  assert.equal(view.secondary, '███░░░░░░░ ! 30% remaining · resets in 17m')
})

test('partial and unknown budgets never imply a complete balance', () => {
  assert.equal(budgetView({ primary: window(75), secondary: null }, now).label, 'Budget unavailable')
  assert.equal(budgetView({}, now).secondary, '░░░░░░░░░░  Unavailable · reset unavailable')
  assert.equal(budgetView({ primary: window(101), secondary: window(0) }, now).label, 'Budget unavailable')
  assert.equal(budgetView({ status: 'partial', primary: window(50), secondary: window(60) }, now).label, 'Budget unavailable')
  assert.equal(budgetView({ primary: window(0, 'bad'), secondary: window(100) }, now).primary, '░░░░░░░░░░ !! 0% remaining · reset unavailable')
})

test('GUI window formatting stays consistent with the TUI', () => {
  for (const value of [null, window(0, 'bad'), window(10), window(99, '1970-01-01T00:16:40.000Z'), window(75, '1970-01-03T00:00:00.000Z')]) {
    const expected = formatWindow(value, now)
    assert.equal(budgetView({ primary: value }, now).primary, `${expected.bar} ${expected.marker} ${expected.percent} · ${expected.reset}`)
  }
})

test('accessible progress bars distinguish severity thresholds and unavailable values', () => {
  const document = { createElement: () => ({ children: [], style: {}, attributes: {}, setAttribute(name, value) { this.attributes[name] = String(value) }, append(...children) { this.children.push(...children) } }) }
  const render = vm.runInNewContext(`${source}\nwindowElement`, { ...context, document })
  const bar = value => render('Primary', value).children[1]
  const critical = bar(window(20)), warning = bar(window(40)), normal = bar(window(41)), unknown = bar(null)
  assert.notEqual(critical.children[0].style.backgroundColor, warning.children[0].style.backgroundColor)
  assert.notEqual(warning.children[0].style.backgroundColor, normal.children[0].style.backgroundColor)
  assert.equal(critical.attributes['aria-valuenow'], '20')
  assert.equal(unknown.attributes['aria-valuetext'], 'Unavailable')
  assert.equal(unknown.attributes['aria-valuenow'], undefined)
  assert.equal(unknown.hidden, true)
  assert.equal(unknown.children[0].style.width, '0%')
})
