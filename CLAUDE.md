# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A personal macOS maintenance script. The entire project is a single shell script, `update.sh`, plus a `README.md`. There is no build system, test suite, or dependencies to install.

Structurally `update.sh` is organized into commented section headers: prerequisites (Homebrew guard + `sudo -v` credential caching with a background keepalive), system cleanup (`purge`, `ifconfig awdl0 down`), Homebrew (update/upgrade `--greedy`/autoremove/cleanup/tap repair), DNS cache flush, an optional disabled catalog (known_hosts, `softwareupdate`, ComputerName, QuickLook), the `defaults write` preferences, and a final `killall Finder/Dock/SystemUIServer` to apply them. Most commented-out lines are paused tweaks, not paused core logic.

## Delivery model

`update.sh` is consumed by being piped directly from the `main` branch of GitHub into a shell (see `README.md`):

```
sh -c 'sh -c "$(curl -sL https://raw.githubusercontent.com/realroboto/Update-My-Mac/main/update.sh)"'
```

Implications when editing:

- Changes only take effect once committed and pushed to `main` — there is no release step, the raw file *is* the release.
- The script runs non-interactively on a fresh shell with no arguments and no environment guarantees. Don't rely on the working directory, prompts, or interactive input.
- It assumes the invoking user has `sudo` rights and Homebrew installed.
- It is invoked **without** a `sudo` prefix (per `README.md`): `brew` runs directly as the user, and only commands that need root call `sudo` internally. The credential is cached once via `sudo -v` and kept alive by a background loop for the script's duration. Do not reintroduce `sudo -u $USER brew`.

## Conventions

- **Disable, don't delete.** The git history shows the established workflow is to comment out commands (with `#`) when retiring or pausing them, rather than removing the lines. Preserve this — commented blocks are an intentional catalog of optional/risky tweaks (QuickLook cache purges, ComputerName changes, animation disabling, `softwareupdate`, known_hosts clearing).
- **Best-effort, not fail-fast.** The script does not use `set -e` and no longer chains steps with `&&`. Each step runs unconditionally and pipes failure into `warn` (`cmd || warn "..."`), so a failed step logs and the run continues — preserving the original intent where the `defaults write`/`killall` tail always ran. New steps should follow the same `cmd || warn "..."` (or `|| true`) pattern, not `&&` chaining.
- POSIX `sh` only — the shebang is `#!/bin/sh` and the delivery model pipes the file into `sh`. No bashisms (no arrays, `[[ ]]`, etc.). The `sudo -v` + background keepalive loop and `trap ... EXIT` are intentional and POSIX-safe.
- `log()` / `warn()` helpers provide colored progress output; use them for any new user-visible step rather than bare `echo`.
- Comments are a mix of English and Portuguese; the refactored script is mostly Portuguese. Match the surrounding language when editing a block.

## Safety note

This script makes system-wide changes (cache purges, network interface changes via `ifconfig awdl0 down`, `brew cleanup -s --prune=all`, `defaults write`, killing Finder/Dock/SystemUIServer). When adding commands, verify they are reversible or clearly scoped, and prefer adding them commented-out until validated. Note: clearing `~/.ssh/known_hosts` is a deliberate security downgrade and is now **disabled by default** (commented in the optional catalog) — do not re-enable it without explicit user intent.
