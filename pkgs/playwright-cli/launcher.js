// Use the bundled Chromium only when the caller has not selected a browser.
const fs = require('fs');
const os = require('os');
const path = require('path');
const args = process.argv.slice(2);
const configPresent = process.env.PLAYWRIGHT_MCP_CONFIG || args.some(arg => arg === '--config' || arg.startsWith('--config=')) ||
  fs.existsSync(path.join(process.cwd(), '.playwright', 'cli.config.json')) ||
  fs.existsSync(path.join(os.homedir(), '.playwright', 'cli.config.json'));
const browserPresent = args.some(arg => arg === '--browser' || arg.startsWith('--browser='));
const opensBrowser = args.some((arg, i) => arg === 'open' &&
  (i === 0 || !['-s', '--session', '--config'].includes(args[i - 1])));
if (opensBrowser && !browserPresent && !configPresent && !process.env.PLAYWRIGHT_MCP_BROWSER)
  process.argv.push('--browser=chromium');
require('./playwright-cli.js');
