# agents.md — NixOS flake config (`/etc/nixos`)

**Always determine which host you're on and edit only that host's files.** Do not touch other hosts unless explicitly asked. The macOS/macbook config is **unmaintained**. **Never install software imperatively — always declare it through NixOS modules or by creating a new module.**

## Which Host Am I On?

```bash
hostname && uname -s
```

| hostname → target | notes |
|---|---|
| `fabians-nix-desktop` | desktop — COSMIC, Ollama/ROCM, gaming, CAD, lanzaboote (secure boot) |
| `fabians-nix-laptop` | laptop — COSMIC, Zen kernel, steam |
| `blumenpeter-fabian-koehnen` | work server — nixpkgs-unstable, COSMIC, Hermes AI agent (CUDA), Docker |
| macOS (`Darwin`) | **unmaintained** — do not edit unless explicitly asked |

**Scope rule:** only edit `hosts/<target>/`, shared `modules/`, or `defaults/`. Never modify another host's files without explicit permission.

## Quick Reference

- **User on all machines:** `fabian`
- **Impermanence:** root is ephemeral on all NixOS hosts; persistent files declared via `environment.persistence."/persist/impermanence"`
- **Shared args from flake.nix:** `user`, `unstable`, `wallpaper`, `hyprland-extra-config`, `inputs`

### Architecture

- Hosts import `defaults/graphical/` base then layer feature modules from `modules/`.
- Home-manager: `useGlobalPkgs + useUserPackages = true`. Shared modules (sops-nix, catppuccin) injected in flake.nix.
- Wallpaper passed as special arg `wallpaper` into host configs.
- **Secrets:** `secrets/` is a local SOPS repo. **Never read or modify it.** Use sops-nix module interface only.

## Module Writing Patterns

Every file under `modules/` is a **partial `configuration.nix`** — a NixOS config fragment that gets merged when imported by a host. Write them exactly like `configuration.nix`, just return the attribute set:

```nix
{ pkgs, user, wallpaper, lib, ... }: {
  services.someService.enable = true;
  programs.someApp.config = { … };
  home-manager.users.${user}.programs.app.enable = true;
}
```

NixOS merges all imported fragments. Options at the top level (services, boot, programs, etc.) and `home-manager.users.${user}.*` coexist in the same file.

### Special args available from `flake.nix`

List only what you need. Common args:
- `pkgs` — always available
- `user` — `"fabian"`
- `wallpaper` — `{ light, dark }` path object (desktop & laptop)
- `lib` — NixOS lib helper
- `inputs` — all flake inputs
- `unstable` — nixpkgs-unstable packages
- `config`, `hyprland-extra-config` — context-aware args

### Nesting submodules

Use `imports` to include sibling files from the same directory:

```nix
{ pkgs, ... }: {
  imports = [ ./submodule1.nix ];
  # top-level options ...
}
```

### Key rules

- **One module per feature.** Each file does one thing (e.g. `steam`, `kitty`, `tuxedo`).
- **`lib.mkDefault true`** for opt-in features that the host can override.
- **`lib.mkForce`** only to override a lower-priority setting.
- **Accept only the args you need.** Don't destructure extras.
- **Never duplicate code across hosts.** Shared stuff belongs in `modules/`.

### Build & Apply (ask the user, never run yourself)

```
Linux   → sudo nixos-rebuild switch --flake .  # NixOS auto-detects hostname — do NOT add a target
macOS   → nix-darwin switch --flake .#darwinConfigurations.macbook
```

Suggest `nix fmt` before applying.
