---
name: host-tools
description: Use when a task needs a command-line tool that may be installed on the host system rather than provided by the active Nix shell or development environment.
---

# Host-Installed Tools

Some useful tools are installed outside the active Nix shell. Do not assume a
command is unavailable merely because it is absent from the project environment.

## Discovery

1. First try the tool normally, using `command -v <tool>` or `<tool> --version`.
2. If it is not on `PATH`, inspect likely host locations before proposing an
   installation: `/run/current-system/sw/bin`, `/nix/var/nix/profiles/default/bin`,
   `~/.nix-profile/bin`, `~/.local/bin`, `/usr/local/bin`, and `/usr/bin`.
3. Invoke a discovered tool by absolute path when it is not exported into the
   current shell's `PATH`.
4. Prefer the installed tool over adding a dependency, changing `flake.nix`, or
   modifying the project shell when the task only needs a one-off command.

## Safe Use

- Check the tool's version or `--help` before relying on its flags or behavior.
- Keep the active project environment intact; do not source profile scripts or
  modify global `PATH` persistently just to run a command.
- If a tool may modify data, inspect its arguments and run a read-only or dry-run
  command first when available.
- Report the absolute executable path used when it affects reproducibility.

## Nix-Specific Notes

- A command missing from `nix develop` can still be installed in the NixOS
  system profile or a user profile.
- `nix run nixpkgs#<package> -- <args>` is appropriate when no usable host
  executable exists and an ephemeral tool is sufficient.
- Only recommend adding a tool to `flake.nix`, `shell.nix`, or project
  dependencies when it is a recurring, reproducible project requirement.
