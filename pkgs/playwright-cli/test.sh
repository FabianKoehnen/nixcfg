#!/bin/sh
set -eu
cli=${1:?pass the built playwright-cli executable}
testdir=$(mktemp -d /tmp/opencode/pw.XXXXXX)
export HOME="$testdir/home" XDG_CACHE_HOME="$testdir/cache" XDG_CONFIG_HOME="$testdir/config" XDG_RUNTIME_DIR="$testdir/runtime" TMPDIR="$testdir" NO_UPDATE_NOTIFIER=1
mkdir -p "$HOME" "$XDG_CACHE_HOME" "$XDG_CONFIG_HOME" "$XDG_RUNTIME_DIR" "$testdir/work"
chmod 700 "$XDG_RUNTIME_DIR"
cd "$testdir/work"
cleanup() { "$cli" -s=open close >/dev/null 2>&1 || :; "$cli" -s=explicit close >/dev/null 2>&1 || :; "$cli" -s=config close >/dev/null 2>&1 || :; "$cli" -s=firefox close >/dev/null 2>&1 || :; }
trap cleanup EXIT
"$cli" --version | grep -Fx 0.1.22
"$cli" open --help | grep -F -- '--browser'
"$cli" -s=open open 'data:text/html,<title>Prototype</title><h1>Smoke test</h1>'
"$cli" -s=open snapshot | grep -F 'heading "Smoke test"'
"$cli" -s open eval '() => "open"' | grep -F 'open'
"$cli" -s=open tab-list | grep -F 'Prototype'
"$cli" -s=open close | grep -F "Browser 'open' closed"
"$cli" -s=explicit open --browser=chromium 'data:text/html,<h1>Explicit browser</h1>'
"$cli" -s=explicit snapshot | grep -F 'heading "Explicit browser"'
"$cli" -s=explicit close | grep -F "Browser 'explicit' closed"
"$cli" -s=explicit open --browser chromium 'data:text/html,<h1>Separate browser option</h1>'
"$cli" -s=explicit snapshot | grep -F 'heading "Separate browser option"'
"$cli" -s=explicit close | grep -F "Browser 'explicit' closed"
printf '%s\n' '{"browser":{"browserName":"chromium"}}' > config.json
"$cli" -s=config --config config.json open 'data:text/html,<h1>Configured</h1>'
"$cli" -s=config snapshot | grep -F 'heading "Configured"'
"$cli" -s=config close | grep -F "Browser 'config' closed"
mkdir -p .playwright
cp config.json .playwright/cli.config.json
"$cli" -s=config open 'data:text/html,<h1>Workspace config</h1>'
"$cli" -s=config snapshot | grep -F 'heading "Workspace config"'
"$cli" -s=config close | grep -F "Browser 'config' closed"
rm .playwright/cli.config.json
"$cli" -s=firefox open --browser=firefox 'data:text/html,<h1>Firefox smoke test</h1>'
"$cli" -s=firefox snapshot | grep -F 'heading "Firefox smoke test"'
"$cli" -s=firefox close | grep -F "Browser 'firefox' closed"
"$cli" list
echo "PASS (test data: $testdir)"
