# dotfiles

Personal configuration files for a Linux desktop (i3) and macOS (yabai), managed with [GNU Stow](https://www.gnu.org/software/stow/).

---

## Installation

Clone the repo and use `stow` to symlink any package into your home directory:

```sh
git clone https://github.com/malechus/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Install a single package
stow alacritty

# Install everything
stow alacritty fastfetch i3 nvim picom rofi zsh
```

Each top-level directory is a stow package. Its internal structure mirrors `$HOME`, so `alacritty/.config/alacritty/alacritty.toml` gets linked to `~/.config/alacritty/alacritty.toml`.

To remove symlinks: `stow -D <package>`  
To re-link after a change: `stow -R <package>`

### ZSH plugins

The plugins in `zsh/.config/zsh/plugins/` are gitignored (they are external repos, not submodules). Clone them manually after stowing:

```sh
PLUGIN_DIR=~/.config/zsh/plugins

git clone https://github.com/zsh-users/zsh-autosuggestions        $PLUGIN_DIR/zsh-autosuggestions
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting $PLUGIN_DIR/F-Sy-H
git clone https://github.com/zsh-users/zsh-history-substring-search $PLUGIN_DIR/zsh-history-substring-search
```

---

## Theme

All tools use the **[Catppuccin Macchiato](https://github.com/catppuccin/catppuccin)** color palette for a consistent look across the entire desktop.

| Role | Color |
|---|---|
| Background | `#24273a` |
| Foreground | `#cad3f5` |
| Blue accent | `#8aadf4` |
| Yellow/gold (prompt, clock) | `#F6C604` |
| Pink (bar workspace labels) | `#f0c6c6` |
| Teal (prompt path) | `#069494` |
| Mauve/purple (prompt git branch) | `#c6a0f6` |
| Green (bar statusline) | `#a6da95` |
| Bar background | `#494d64` |

**Fonts**
- **UI / i3 bar:** Hurmit Nerd Font Regular 14pt
- **Terminal:** CaskaydiaCove Nerd Font Mono Regular

---

## Packages

### i3 — Window Manager

Tiling window manager for X11. The modifier key is `Super` (Windows key).

**Key bindings**

| Action | Key |
|---|---|
| Open terminal | `Super+Enter` |
| Launch dmenu | `Super+D` |
| Kill window | `Super+Shift+Q` |
| Enter resize mode | `Super+R` |
| Toggle floating | `Super+Shift+Space` |
| Reload config | `Super+Shift+C` |
| Restart i3 | `Super+Shift+R` |
| Exit i3 | `Super+Shift+E` |

Focus and window movement use `j/k/l/;` (vim-style) or arrow keys. Workspaces 1–4 have Nerd Font icons; workspaces 5–10 are plain numbers.

**Workspace assignments**

| App | Workspace |
|---|---|
| Microsoft Edge | 3 |
| Discord | 3 |
| scrcpy | 3 |

**Display assignments**

| Workspace | Output |
|---|---|
| 1 | DP-2 (primary) |
| 2 | DP-4 |
| 3 | DP-0 |

**Bar**  
A dark (`#494d64`) bar sits at the top of every monitor. The primary display shows `i3status` system info (statusline in green `#a6da95`) and the system tray; secondary displays show only the workspace list. Workspace labels use pink (`#f0c6c6`) for active/focused and blue-white (`#cad3f5`) for inactive.

**Visual**  
5px inner and outer gaps, no window borders, smart gaps (gaps collapse when only one window is open).

The config is split into numbered files loaded via `include`:

| File | Purpose |
|---|---|
| `config` | Variables, workspace names, include directive |
| `01-keybindings-i3.conf` | All key/mouse bindings |
| `02-modes-i3.conf` | Resize mode |
| `03-bar-i3.conf` | Bar definitions |
| `04-workspaces-i3.conf` | Per-app workspace assignments |
| `05-settings-i3.conf` | Font, gaps, volume keys |
| `ZZ-startup-i3.conf` | Autostart execs (dex, xss-lock, display setup + wallpapers via scripts, autotiling) |

---

### Picom — Compositor

Provides transparency, shadows, fading transitions, and rounded corners on X11.

**Highlights**
- **Rounded corners:** 10px radius on all windows
- **Shadows:** 7px radius, offset `-7, -7`
- **Fading:** 0.03 step in/out
- **Alacritty opacity:** 85% focused, 65% unfocused
- **Other windows:** 95% when unfocused, 50% frame opacity
- **Backend:** xrender with vsync

Config is split via `@include`:

| File | Controls |
|---|---|
| `picom.conf` | Backend, global flags, includes |
| `shadows.conf` | Drop shadow settings |
| `fading.conf` | Fade animation speed |
| `opacity.conf` | Frame opacity |
| `rules.conf` | Per-app opacity rules |
| `windows.conf` | Corner radius |

---

### Alacritty — Terminal

GPU-accelerated terminal. Config is split via `general.import`:

| File | Controls |
|---|---|
| `00-catpuccin-macchiato.toml` | Full Catppuccin Macchiato color scheme |
| `01-window.toml` | 80% opacity, dark theme variant, title "Console" |
| `02-keybindings.toml` | Custom key bindings |
| `03-font.toml` | CaskaydiaCove Nerd Font Mono |

---

### ZSH — Shell

XDG-compliant ZSH config. `ZDOTDIR` is set to `~/.config/zsh`; `.zshrc` sources all `*.zsh` files in that directory in order.

**Load order**

| File | Purpose |
|---|---|
| `00-environment.zsh` | XDG vars, `HISTFILE`, `DEV_HOME`, env exports |
| `01-option.zsh` | `setopt` flags, vi mode (`bindkey -v`) |
| `02-alias.zsh` | Aliases (`vim→nvim`, `ll`, `la`, `please`, etc.) |
| `03-plugin.zsh` | Plugin sources and history-substring-search bindings |
| `04-prompt.zsh` | `PS1`, `RPROMPT`, git branch via `vcs_info`, blank line between prompts |
| `ZZ-startup.zsh` | Launches fastfetch if available |
| `.zprofile` | Appends `~/.local/bin` to `PATH` (sourced at end of `.zshrc`) |

**Prompt**

```
malechus@hostname
~/source/repos/dotfiles [main] %
```

- Line 1: `user@host` in yellow/gold
- Line 2: current path (4 levels deep) in teal; git branch in mauve/purple (only shown inside a git repo); followed by `%`
- Right side: current time in 24h format (yellow/gold)
- A blank line is inserted before each prompt after the first

**Plugins**

| Plugin | Purpose |
|---|---|
| zsh-autosuggestions | Ghost-text suggestions from history |
| F-Sy-H (Fast Syntax Highlighting) | Real-time syntax coloring |
| zsh-history-substring-search | Up/down arrows search history by prefix |

---

### Neovim — Text Editor

Uses Neovim's built-in package manager (`vim.pack`, available in Neovim 0.11+) to manage plugins for Java development.

**Plugins**

| Plugin | Purpose |
|---|---|
| [nvim-java](https://github.com/nvim-java/nvim-java) | Full Java IDE experience (test runner, DAP, refactoring) |
| [spring-boot.nvim](https://github.com/JavaHello/spring-boot.nvim) | Spring Boot project support |
| [nvim-dap](https://github.com/mfussenegger/nvim-dap) | Debug Adapter Protocol client |
| [nui.nvim](https://github.com/MunifTanjim/nui.nvim) | UI component library (dependency) |

The `jdtls` LSP server is enabled via `vim.lsp.enable('jdtls')` for Java language intelligence.

---

### Rofi — Application Launcher

Configured at `~/.config/rofi/config.rasi`. 

Feature rich replacement for dmenu, themed with Catppuccin-machiatto.

---

### Fastfetch — System Info

Displays system info on shell startup (only if `fastfetch` is installed). Uses a small distro logo with colored Nerd Font icons per module. Shows: user, hostname, uptime, OS/distro, kernel, DE, terminal, shell, CPU, disk, memory, local IP (with interface name), and a color palette swatch (circle symbols). Output is framed with custom bullet-box borders.

---

### Yabai — macOS Tiling Window Manager

BSP (binary space partitioning) tiling layout for macOS. Mouse modifier is `Alt`.

**Settings**

| Setting | Value |
|---|---|
| Layout | BSP |
| Focus follows mouse | Autofocus |
| Split ratio | 50/50 |
| Normal window opacity | 90% |
| Mouse move | Alt+drag |
| Mouse resize | Alt+right-drag |

System Preferences, settings dialogs, and GoLand preference panes are floated automatically.

---

## Acknowledgements

This setup is built on the work of many open source authors and projects.

| Project | Author(s) | License |
|---|---|---|
| [GNU Stow](https://www.gnu.org/software/stow/) | GNU Project | GPL-3.0 |
| [i3](https://i3wm.org/) | Michael Stapelberg & contributors | BSD |
| [Picom](https://github.com/yshui/picom) | yshui (fork of compton by chjj) | MIT / Apache-2.0 |
| [Alacritty](https://github.com/alacritty/alacritty) | Joe Wilm & Alacritty contributors | Apache-2.0 |
| [Rofi](https://github.com/davatorium/rofi) | Dave Davenport (davatorium) | MIT |
| [Fastfetch](https://github.com/fastfetch-cli/fastfetch) | fastfetch-cli contributors | MIT |
| [Yabai](https://github.com/koekeishiya/yabai) | koekeishiya | MIT |
| [Catppuccin Macchiato](https://github.com/catppuccin/catppuccin) | Catppuccin Org | MIT |
| [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) | Eric Freese & zsh-users | MIT |
| [F-Sy-H](https://github.com/zdharma-continuum/fast-syntax-highlighting) | zdharma-continuum (originally z-shell) | BSD |
| [zsh-history-substring-search](https://github.com/zsh-users/zsh-history-substring-search) | zsh-users | BSD |
| [Nerd Fonts](https://www.nerdfonts.com/) (Hurmit, CaskaydiaCove) | Ryan L McIntyre (ryanoasis) | MIT |
| [Spotify-Player](https://github.com/aome510/spotify-player) | aome510 | MIT |
| [Neovim](https://neovim.io/) | Neovim contributors | Apache-2.0 |
| [nvim-java](https://github.com/nvim-java/nvim-java) | nvim-java contributors | Apache-2.0 |
| [spring-boot.nvim](https://github.com/JavaHello/spring-boot.nvim) | JavaHello | MIT |
| [nvim-dap](https://github.com/mfussenegger/nvim-dap) | Mfussenegger | GPL-3.0 |
| [nui.nvim](https://github.com/MunifTanjim/nui.nvim) | MunifTanjim | MIT |

---

## Repository Structure

```
dotfiles/
├── alacritty/    # Terminal emulator config
├── fastfetch/    # System info display config
├── i3/           # i3 window manager config + bar scripts + wallpapers
├── nvim/         # Neovim config (Java development)
├── picom/        # Compositor config
├── rofi/         # App launcher config
├── yabai/        # macOS tiling WM config
└── zsh/          # ZSH shell config + plugins (plugins gitignored)
```
