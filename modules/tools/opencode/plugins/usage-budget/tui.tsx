import { Plugin } from '@opencode/plugin/tui'
import { createSignal, onCleanup } from 'solid-js'
import { UsageBudget } from './rpc'
import { formatWindow, startRefresh } from './sidebar.mjs'

export default Plugin.define({
  id: 'usage-budget-tui',
  setup(context) {
    return context.ui.slot({
      prepend: 'sidebar.content',
      render: () => {
        const [usage, setUsage] = createSignal<any>({ status: 'unknown', primary: null, secondary: null })
        const stop = startRefresh({ read: () => context.client.rpc(UsageBudget).read({}), update: setUsage })
        onCleanup(stop)
        const color = (severity: string) => severity === 'critical' ? context.theme.text.feedback.error.base : severity === 'warning' ? context.theme.text.feedback.warning.base : severity === 'normal' ? context.theme.text.feedback.success.base : context.theme.text.muted
        const Window = (props: { name: string, value: any }) => <box flexDirection="column">
          <text fg={context.theme.text.base}>{props.name}</text>
          <text fg={color(formatWindow(props.value).severity)}>{formatWindow(props.value).bar} {formatWindow(props.value).marker}</text>
          <text fg={color(formatWindow(props.value).severity)}>{formatWindow(props.value).percent}</text>
          <text fg={context.theme.text.muted}>{formatWindow(props.value).reset}</text>
        </box>
        return <box flexDirection="column" marginTop={1}>
          <text fg={context.theme.text.base}>Abo-Budget</text>
          <Window name="Primary" value={usage().primary} />
          <Window name="Secondary" value={usage().secondary} />
        </box>
      },
    })
  },
})
