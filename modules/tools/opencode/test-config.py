#!/usr/bin/env python3
"""Offline, synthetic checks; never inspect the user's local configuration."""
import copy
import json
import re
import subprocess
import sys
from pathlib import Path

root = Path(__file__).resolve().parent
# Evaluate only the relevant settings with inert arguments: laziness
# avoids package paths, builds, IFD, and network access. This is not HM integration.
expression = r'''
let
  programFor = enabled: (import ./default.nix {
    user = "synthetic";
    pkgs.callPackage = _: _: "synthetic-playwright-cli";
    unstable.opencode = "synthetic-opencode";
    config.services.opencode.ollama.enable = enabled;
    lib = { mkEnableOption = _: {}; mkIf = condition: x: if condition then x else {}; };
  }).config.home-manager.users.synthetic.programs.opencode;
  settings = (programFor false).settings;
in {
  base = builtins.removeAttrs settings [ "mcp" "provider" ];
  providerDisabled = settings.provider;
  providerEnabled = (programFor true).settings.provider;
  package = (programFor false).package;
  extraPackages = (programFor false).extraPackages;
  homePackages = (import ./default.nix {
    user = "synthetic"; pkgs.callPackage = _: _: "synthetic-playwright-cli";
    unstable.opencode = "synthetic-opencode"; config = {};
    lib = { mkEnableOption = _: {}; };
  }).config.home-manager.users.synthetic.home.packages;
  agentFiles = builtins.mapAttrs (_: toString) (import ./default.nix {
    user = "synthetic"; pkgs.callPackage = _: _: "synthetic-playwright-cli";
    unstable.opencode = "synthetic-opencode"; config = {};
    lib = { mkEnableOption = _: {}; };
  }).config.home-manager.users.synthetic.programs.opencode.agents;
}
'''
evaluated = json.loads(subprocess.check_output(
    ["nix-instantiate", "--eval", "--strict", "--json", "--expr", expression,
     "--option", "allow-import-from-derivation", "false"], cwd=root))
config = evaluated["base"]
permissions = config["permission"]
assert evaluated["package"] == "synthetic-opencode"
assert evaluated["extraPackages"] == ["synthetic-playwright-cli"]
assert evaluated["homePackages"] == ["synthetic-playwright-cli"]
assert config["plugins"] == ["/home/synthetic/.local/share/opencode/usage-budget"]
assert not (root / "opencode.json").exists()
module = (root / "default.nix").read_text()
cli = {"$schema": "https://opencode.ai/v2/cli.json", "theme": {"name": "opencode"},
       "diffs": {"wrap": "word"}, "session": {"sidebar": "auto", "scrollbar": True, "thinking": "hide"},
       "animations": True}
assert not (root / "cli.json").exists()
assert "./cli.json" not in module

# Force wrapper paths with inert components and IFD disabled.
wrapper_expr = r'''
let
  result = (import ./default.nix {
    user = "synthetic"; unstable.opencode = "opencode";
    unstable.opencode-desktop = "opencode-desktop"; config = {};
    lib = { mkEnableOption = _: {}; };
    pkgs = {
      callPackage = _: _: "synthetic-playwright-cli";
      playwright-driver.components.chromium = "/browser/chromium";
      playwright-driver.components.firefox = "/browser/firefox";
      playwright-mcp = "/mcp";
      writeShellScriptBin = name: text: { inherit name text; };
    };
  }).config.environment.systemPackages;
in builtins.genList (i: builtins.elemAt result i) 2
'''
wrappers = json.loads(subprocess.check_output(
    ["nix-instantiate", "--eval", "--strict", "--json", "--expr", wrapper_expr,
     "--option", "allow-import-from-derivation", "false"], cwd=root))
for wrapper, browser, executable in zip(wrappers, ("chromium", "firefox"),
        ("/browser/chromium/chrome-linux64/chrome", "/browser/firefox/firefox/firefox")):
    assert f'--browser "{browser}" --executable-path "{executable}"' in wrapper["text"]
    assert 'PLAYWRIGHT_BROWSERS_PATH' in wrapper["text"]

# Compare the actual HM manifest with all intended files, excluding tests/docs.
manifest = re.search(r'files = \[(.*?)\];', module, re.S).group(1)
targets = re.findall(r'"([^"]+)"', manifest)
expected = {"AGENTS.md"}
assert "programs.opencode" in module
assert '"cli.json"' not in manifest and '"opencode.json"' not in manifest
expected |= {str(p.relative_to(root)) for p in (root / "skills").rglob("*") if p.is_file()}
assert len(targets) == len(set(targets)) and set(targets) == expected
assert all((root / p).is_file() for p in targets)
agent_sources = evaluated["agentFiles"]
assert set(agent_sources.values()) == {str(p) for p in (root / "agents").glob("*.md")}
assert all(path == str(root / "agents" / f"{name}.md") for name, path in agent_sources.items())
assert '".local/share/opencode/usage-budget".source = ./plugins/usage-budget;' in module
assert 'usageBudgetPlugin' not in module and 'esbuild' not in module
assert '"opencode/plugins/usage-budget"' not in module
assert 'name = "opencode/${file}";' in module
assert 'value.source = ./. + "/${file}";' in module
assert 'options.services.opencode.ollama.enable = lib.mkEnableOption' in module
assert 'services.ollama.enable = lib.mkIf config.services.opencode.ollama.enable true;' in module
assert 'provider = lib.mkIf config.services.opencode.ollama.enable' in module
assert 'loadModels' not in module
assert 'tensorx' not in module.lower() and 'llmbase' not in module.lower()
assert 'agent = {' not in module
assert module.count("permission = {") == 1
assert module.count("disabled_providers =") == 1
assert "lib.mkMerge" not in module
assert not (root / 'common').exists()
assert '../../../modules/tools/opencode/common' not in (root.parents[2] / 'hosts/work/blumenPeter/default.nix').read_text()

assert set(config) == {"agents", "experimental", "disabled_providers", "permission", "plugins"}
assert config["experimental"] == {"todo": True}
assert config["disabled_providers"] == ["lmstudio", "opencode-go"]
assert evaluated["providerDisabled"] == {}
assert evaluated["providerEnabled"] == {"ollama": {
    "npm": "@ai-sdk/openai-compatible", "name": "Ollama (local)",
    "options": {"baseURL": "http://localhost:11434/v1"},
    "models": {"hf.co/InternScience/Agents-A1-4B-Q4_K_M-GGUF:Q4_K_M": {"name": "Agents A1 4B Q4_K_M"}},
}}
assert set(permissions) == {"bash", "gitlab-mcp_*", "gitlab-mcp_get_*", "gitlab-mcp_list_*", "gitlab-mcp_search*"}
assert permissions["gitlab-mcp_*"] == "ask"
assert permissions["gitlab-mcp_get_*"] == "allow"
assert permissions["gitlab-mcp_list_*"] == "allow"
assert permissions["gitlab-mcp_search*"] == "allow"
assert permissions["bash"]["*"] == "ask"
assert permissions["bash"]["find * -delete"] == "deny"
assert permissions["bash"]["find *"] == "allow"
assert all(not (root / "agents" / f"{name}.md").exists() for name in ("n8n", "headed-browser"))
assert not ({"mcp", "provider", "providers"} & config.keys())
# Reject credential-like keys and common literal token forms throughout managed JSON.
def check_secrets(value):
    if isinstance(value, dict):
        for key, child in value.items():
            assert not re.search(r'(api.?key|secret|password|token|authorization|credential)', key, re.I), key
            check_secrets(child)
    elif isinstance(value, list):
        for child in value:
            check_secrets(child)
    elif isinstance(value, str):
        assert not re.search(r'\b(?:sk-[A-Za-z0-9_-]{16,}|Bearer\s+[A-Za-z0-9._-]{16,}|ghp_[A-Za-z0-9]{20,})', value)
check_secrets(config)

assert set(config["agents"]) == {"worker-small", "worker-medium", "worker-complex", "delegation-advisor", "maintainability", "build", "plan", "brave"}
for name in ("worker-small", "worker-medium", "worker-complex", "delegation-advisor", "maintainability"):
    assert set(config["agents"][name]) == {"model"}
    assert config["agents"][name]["model"].startswith("openai/")
    frontmatter = (root / "agents" / f"{name}.md").read_text().split("---", 2)[1]
    assert not any(line.startswith("model:") for line in frontmatter.splitlines())
assert config["agents"]["build"]["color"] == "#3b82f6"
assert config["agents"]["plan"]["color"] == "#22c55e"
assert config["agents"]["brave"]["mode"] == "primary"
assert config["agents"]["brave"]["description"]
assert config["agents"]["brave"]["permissions"] == [{"action": "*", "resource": "*", "effect": "allow"}]
assert config["agents"]["delegation-advisor"]["model"] == config["agents"]["worker-medium"]["model"]
assert config["agents"]["maintainability"]["model"] == config["agents"]["worker-medium"]["model"]
# Inspect V2 frontmatter, ordered rules, and body without YAML dependencies.
def agent_file(name):
    _, front, body = (root / "agents" / f"{name}.md").read_text().split("---", 2)
    result = {"system": body.strip()}
    rules = []
    for line in front.splitlines():
        match = re.fullmatch(r'(description|mode|hidden): (.*)', line)
        if match:
            result[match[1]] = match[2]
        match = re.fullmatch(r'  (?:(- )(action)|  (resource|effect)): (.*)', line)
        if match:
            if match[1]:
                rules.append({})
            rules[-1][match[2] or match[3]] = match[4].strip('"')
    if rules:
        result["permissions"] = rules
    return result
advisor = agent_file("delegation-advisor")
maintainability = agent_file("maintainability")
assert maintainability["mode"] == "subagent" and "hidden" not in maintainability
assert maintainability["description"] and maintainability["system"]
assert maintainability["permissions"] == [{"action": "subagent", "resource": "*", "effect": "deny"}]
assert advisor["mode"] == "subagent" and advisor["description"] and advisor["system"]
assert advisor["permissions"] == [{"action": "*", "resource": "*", "effect": "deny"}, {"action": "skill", "resource": "delegating-by-complexity", "effect": "allow"}]
for name in ("worker-small", "worker-medium", "worker-complex"):
    assert agent_file(name)["mode"] == "subagent" and agent_file(name)["description"] and agent_file(name)["system"]
    assert agent_file(name)["permissions"] == [{"action": "subagent", "resource": "*", "effect": "deny"}] or name == "worker-complex" and agent_file(name)["permissions"] == [{"action": "subagent", "resource": "*", "effect": "deny"}, {"action": "edit", "resource": "*", "effect": "deny"}]

# Model the documented manual split on synthetic opaque values, not actual JSONC
# or OpenCode's undocumented same-directory merge precedence.
opaque_mcp = {"servers": {"synthetic": {"nested": ["opaque-mcp", {"x": 7}]}}}
opaque_provider = {"synthetic": {"settings": {"opaque": [False, "opaque-provider"]}}}
local = copy.deepcopy(config) | {"mcp": opaque_mcp, "provider": opaque_provider, "other": {"keep": True}}
before = copy.deepcopy(local)
for key in config:
    assert local[key] == config[key]
    del local[key]
assert local == {k: before[k] for k in ("mcp", "provider", "other")}
assert local["mcp"] == opaque_mcp and local["provider"] == opaque_provider

for path in (root / "AGENTS.md", root / "skills/delegating-by-complexity/SKILL.md", root / "skills/delegating-by-complexity/connections.md"):
    text = path.read_text()
    assert "modules/tools/opencode/default.nix" in text
    assert "read-only" in text and "opencode.jsonc" in text
print("managed OpenCode configuration invariants: OK")

# Optional integration check reads generated derivation input, without building or IFD.
if "--eval" in sys.argv[1:]:
    flake = root.parents[2]
    command = ["nix", "eval", "--offline", "--option", "allow-import-from-derivation", "false",
               "--json", ".#nixosConfigurations.blumenpeter-fabian-koehnen.config.home-manager.users.fabian.xdg.configFile",
               "--apply", 'x: builtins.mapAttrs (_: v: v.source.drvAttrs.value) { inherit (x) "opencode/opencode.json" "opencode/cli.json"; }']
    generated = json.loads(subprocess.check_output(command, cwd=flake))
    for name in ("opencode.json", "cli.json"):
        actual = json.loads(generated["opencode/" + name])
        expected = ({"$schema": "https://opencode.ai/config.json"} | config) if name == "opencode.json" else cli
        for key, value in expected.items():
            if name == "opencode.json" and key == "disabled_providers":
                assert set(value) <= set(actual[key])
            elif name == "opencode.json" and key == "permission":
                assert all(actual[key][k] == v for k, v in value.items())
            elif name == "opencode.json" and key == "plugins":
                assert actual[key] == ["/home/fabian/.local/share/opencode/usage-budget"]
            else:
                assert actual[key] == value, (name, key)
    rendered = json.loads(generated["opencode/opencode.json"])
    assert "playwright" in rendered["mcp"]
    assert "ollama" not in rendered.get("provider", {})
    print("offline Home Manager generated JSON matches managed settings: OK")
