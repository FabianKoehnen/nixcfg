import { Plugin } from '@opencode/plugin'
import { setup } from './usage.mjs'
import { UsageBudget } from './rpc'

export default Plugin.define({ id: 'usage-budget', setup: (ctx) => setup(ctx, UsageBudget) })
