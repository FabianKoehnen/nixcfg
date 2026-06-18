---
name: nixos-lookup
description: Look up NixOS packages, configuration options, and channels using command-line tools like nix search, nixpkgs-review, and online documentation.
disable-model-invocation: true
---

# NixOS Package & Option Lookup

When the user asks about NixOS packages, configuration options, or how to set something up, use this skill.

## Quick Lookups (CLI)

### Search Packages

```bash
nix search nixpkgs <query>
```

Or if using Nix with flakes:

```bash
nix search github:NixOS/nixpkgs/nixos-unstable <query>
```

For faster searches without downloading:

```bash
nix search --quiet nixpkgs <query>
```

### Inspect a Specific Package

```bash
nix show-derivation $(nix eval --raw 'nixpkgs.<package>')
nix info '<nixpkgs#<package>>'
nix describe --all '<nixpkgs#<package>>'
```

### Search Configuration Options

```bash
nix search nixos-options <query>
```

Or search the options manpage:

```bash
nix run nix-index-database.companies/nix-info -- -m <query>
```

### Find Which Package Provides a File/Command

```bash
nix-locate <pattern>
```
(Requires `nix-locate` installed via `nixpkgs#nix-locate`)

## Online Resources (when CLI isn't sufficient)

- [NixOS Package Search](https://search.nixos.org/packages) — search across all architectures and versions
- [NixOS Options Search](https://search.nixos.org/options) — search all configuration options
- [Nixpkgs Manual](https://nixos.org/manual/nixpkgs) — package documentation

Use online search when:
- The user needs to see available architectures/build statuses
- The CLI cache is stale or unavailable
- They need to read detailed option descriptions with examples
- Filtering by NixOS release version (e.g., `24.05`, `unstable`)

## Workflow

1. **Start with CLI** — try `nix search` or `nix-locate` first for speed.
2. **Fall back to online search** (`search.nixos.org`) when the user needs filtering, architecture details, or version-specific info.
3. **Provide actionable config snippets** — include the exact NixOS config option (e.g., `services.nginx.enable = true;`) when relevant.
4. **Mention alternatives** — if multiple packages solve the same problem, list a few with brief comparisons.
