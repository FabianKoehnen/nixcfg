import { Rpc } from '@opencode/plugin/rpc'

export const UsageBudget = Rpc.define({
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
