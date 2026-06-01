# nvim

My personal [Neovim](https://neovim.io) configuration, built on
[AstroNvim](https://astronvim.com) v6 and managed with
[lazy.nvim](https://github.com/folke/lazy.nvim). Plugin versions are pinned in
[`lazy-lock.json`](./lazy-lock.json) for reproducible installs.

## Quick install (new machine)

```sh
curl -fsSL https://raw.githubusercontent.com/seanxwzhang/nvim/main/install.sh | bash
```

The script backs up any existing Neovim dirs to a timestamped `*.bak`, clones
this repo to `~/.config/nvim`, and leaves the first `nvim` launch to bootstrap
lazy.nvim and install every plugin. Prefer to read before you pipe to a shell?
See [`install.sh`](./install.sh).

### Manual install

```sh
# back up anything already there
mv ~/.config/nvim{,.bak} 2>/dev/null || true
mv ~/.local/share/nvim{,.bak} 2>/dev/null || true

git clone https://github.com/seanxwzhang/nvim ~/.config/nvim
nvim   # lazy.nvim bootstraps and installs from lazy-lock.json
```

## Requirements

- **Neovim ≥ 0.10** (0.11+ recommended).
- **git**, and a **Nerd Font** in your terminal for icons.
- [`ripgrep`](https://github.com/BurntSushi/ripgrep) and a C compiler (for
  Telescope and nvim-treesitter), plus **Node.js** for several LSPs/tools.
- For the agent tooling: the [`codex`](https://github.com/openai/codex) and/or
  [`claude`](https://www.anthropic.com/claude-code) CLIs on `PATH`.

Run `:checkhealth` after the first launch to find anything missing.

## What's inside

Standard AstroNvim layout — see [`lua/plugins/`](./lua/plugins). A few custom
bits worth calling out:

- **[agentpanel.nvim](https://github.com/seanxwzhang/agentpanel.nvim)** — my
  Codex-like agent panel, extracted into its own plugin. `<Leader>m` toggles a
  modal with a rail of `codex`/`claude` conversations, git worktrees, and live
  activity badges.
- **claudecode.nvim** — Claude Code integration (`<Leader>a…`).
- **codex-sidecar** — `<Leader>ax` toggles a right-hand `codex` terminal; in
  visual mode it sends the selection to that sidecar.
- **terminal-toggle** — `Ctrl+\`` toggles a bottom horizontal terminal.

## Updating

```sh
cd ~/.config/nvim && git pull
nvim "+Lazy! sync" +qa   # apply the updated lazy-lock.json
```
