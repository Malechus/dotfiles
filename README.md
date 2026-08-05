# dotfiles

Personal configuration files for a Linux desktop (i3) and macOS (yabai), managed with [GNU Stow](https://www.gnu.org/software/stow/).

---

# Main Branch

This branch is the most up to date, and is designed specifically for use on a personal machine, for the same content minus anything I would not want downloaded to a company owned machine, mostly wallpapers etc., use the [work-safe branch.](https://github.com/Malechus/dotfiles/tree/work-safe)

---

## Installation

Clone the repo and use `stow` to symlink any package into your home directory:

```sh
git clone https://github.com/malechus/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Install a single package
stow alacritty

# Install a single package to a different directory
sudo stow icons -t /
# This installs the conents of ./icons/ into the root directory. Sudo is required to modify /usr/share/pixmaps - use sudo if necessary for the directory you are targeting.

# Install everything
stow alacritty fastfetch i3 nvim picom rofi x11 zsh copilot spotify-player scripts 
sudo stow icons -t /
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

**WallPapers**  
Wallpapers are located within the i3 directory (`i3/.config/i3/walls/`). Helper scripts live in `i3/.local/bin/` and are linked into `~/.local/bin/` by the i3 stow package:

| Script | Purpose |
|---|---|
| `4.sh` | Configure xrandr for a 4-monitor layout |
| `bottom.sh` | Configure xrandr for a 3-monitor layout (hostname-gated to `polyphemus`) |
| `personal.sh` | Run `4.sh` and set 4-monitor wallpapers |
| `work.sh` | Run `bottom.sh` and set 3-monitor wallpapers |
| `wallswitcher.sh` | Cycle through named wallpaper presets using `feh`; bound to `Super+Shift+W` |

Some wallpapers and scripts are not included in the main branch, but can be found on the `nsfw` branch. Nothing in it is graphic, but I don't want them getting pulled to my work computer.

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
| Toggle wallpaper preset | `Super+Shift+W` |
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

### x11 — X Session Environment

Provides `~/.xprofile`, which is sourced by display managers (SDDM, GDM, LightDM) before starting the X session. This is the correct place for environment variables that must be available to i3 and all processes it spawns — notably `PATH` — because `.bashrc` and `.zshrc` are not sourced in that context.

| Variable | Value |
|---|---|
| `PATH` | Prepends `~/.local/bin` so user scripts are available to i3 `exec` bindings |

---

### Neovim — Text Editor

Uses [vim-plug](https://github.com/junegunn/vim-plug) to manage plugins. Configured for C# development with LSP, completion, fuzzy navigation, and debugging.

**Plugins**

| Plugin | Purpose |
|---|---|
| [nvim-autopairs](https://github.com/windwp/nvim-autopairs) | Auto-close brackets, quotes, and other pairs |
| [catppuccin/nvim](https://github.com/catppuccin/nvim) | Catppuccin Macchiato color scheme |
| [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons) | File type icons (dependency for nvim-tree) |
| [nvim-tree.lua](https://github.com/nvim-tree/nvim-tree.lua) | File explorer sidebar |
| [line-numbers.nvim](https://github.com/shrynx/line-numbers.nvim) | Combined relative and absolute line numbers |
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | LSP client configuration |
| [mason.nvim](https://github.com/williamboman/mason.nvim) | Install and manage LSP servers and DAP adapters |
| [mason-lspconfig.nvim](https://github.com/williamboman/mason-lspconfig.nvim) | Bridge between mason and nvim-lspconfig |
| [omnisharp-extended-lsp.nvim](https://github.com/Hoffs/omnisharp-extended-lsp.nvim) | Go-to-definition support for decompiled C# sources |
| [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) | Completion engine |
| [cmp-nvim-lsp](https://github.com/hrsh7th/cmp-nvim-lsp) | LSP completion source for nvim-cmp |
| [cmp-buffer](https://github.com/hrsh7th/cmp-buffer) | Buffer word completion source |
| [cmp-path](https://github.com/hrsh7th/cmp-path) | File path completion source |
| [LuaSnip](https://github.com/L3MON4D3/LuaSnip) | Snippet engine (required by nvim-cmp) |
| [cmp_luasnip](https://github.com/saadparwaiz1/cmp_luasnip) | LuaSnip completion source for nvim-cmp |
| [plenary.nvim](https://github.com/nvim-lua/plenary.nvim) | Lua utility library (dependency for Telescope) |
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | Fuzzy finder for files, grep, and buffers |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | AST-based syntax highlighting with C# parser |
| [nvim-dap](https://github.com/mfussenegger/nvim-dap) | Debug Adapter Protocol client |
| [nvim-dap-ui](https://github.com/rcarriga/nvim-dap-ui) | UI overlay for DAP (scopes, stacks, watches, breakpoints) |
| [nvim-nio](https://github.com/nvim-neotest/nvim-nio) | Async I/O library (dependency for nvim-dap-ui) |
| [mason-nvim-dap.nvim](https://github.com/jay-babu/mason-nvim-dap.nvim) | Bridge between mason and nvim-dap |

**Fresh system setup**

1. Install vim-plug:
   ```sh
   curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
   ```
2. Install plugins:
   ```sh
   nvim +PlugInstall +qall
   ```
3. On first nvim launch after PlugInstall, mason will auto-install `omnisharp` and `netcoredbg`. This requires an internet connection and .NET SDK.
4. Install a C compiler if not present (required by Treesitter to compile parsers):
   ```sh
   sudo apt install gcc   # Debian/Ubuntu
   ```
5. Install the C# Treesitter parser inside nvim:
   ```
   :TSInstall c_sharp
   ```

For full keybinding reference and C# workflow guidance, see `nvim/.config/nvim/README.md`.

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

### Icons 

A folder for icons which is a dependency of the wallswitcher script in the i3 package.
This must be mapped to `/` with stow, as `sudo stow icons -t /`
This is a limitation of the notify-send utility, which only searches specific locations for icon files.

---

## Acknowledgements

This setup is built on the work of many open source authors and projects.

| Project | Author(s) | License |
|---|---|---|
| [feh](https://feh.finalrewind.org/) | Tom Gilbert & contributors | MIT |
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
| [vim-plug](https://github.com/junegunn/vim-plug) | Junegunn Choi | MIT |
| [nvim-autopairs](https://github.com/windwp/nvim-autopairs) | windwp | MIT |
| [catppuccin/nvim](https://github.com/catppuccin/nvim) | Catppuccin Org | MIT |
| [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons) | nvim-tree contributors | MIT |
| [nvim-tree.lua](https://github.com/nvim-tree/nvim-tree.lua) | Yazdani Kiyan & contributors | GPL-3.0 |
| [line-numbers.nvim](https://github.com/shrynx/line-numbers.nvim) | shrynx | MIT |
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | Neovim contributors | Apache-2.0 |
| [mason.nvim](https://github.com/williamboman/mason.nvim) | William Boman & contributors | Apache-2.0 |
| [mason-lspconfig.nvim](https://github.com/williamboman/mason-lspconfig.nvim) | William Boman & contributors | Apache-2.0 |
| [omnisharp-extended-lsp.nvim](https://github.com/Hoffs/omnisharp-extended-lsp.nvim) | Hoffs | MIT |
| [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) | hrsh7th | MIT |
| [cmp-nvim-lsp](https://github.com/hrsh7th/cmp-nvim-lsp) | hrsh7th | MIT |
| [cmp-buffer](https://github.com/hrsh7th/cmp-buffer) | hrsh7th | MIT |
| [cmp-path](https://github.com/hrsh7th/cmp-path) | hrsh7th | MIT |
| [LuaSnip](https://github.com/L3MON4D3/LuaSnip) | L3MON4D3 | Apache-2.0 |
| [cmp_luasnip](https://github.com/saadparwaiz1/cmp_luasnip) | saadparwaiz1 | Apache-2.0 |
| [plenary.nvim](https://github.com/nvim-lua/plenary.nvim) | TJ DeVries & contributors | MIT |
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | TJ DeVries & contributors | MIT |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | nvim-treesitter contributors | Apache-2.0 |
| [nvim-dap](https://github.com/mfussenegger/nvim-dap) | Mathias Fussenegger | GPL-3.0 |
| [nvim-dap-ui](https://github.com/rcarriga/nvim-dap-ui) | rcarriga | MIT |
| [nvim-nio](https://github.com/nvim-neotest/nvim-nio) | nvim-neotest contributors | MIT |
| [mason-nvim-dap.nvim](https://github.com/jay-babu/mason-nvim-dap.nvim) | Jay Babu & contributors | Apache-2.0 |
| [notify-send](https://gitlab.gnome.org/GNOME/libnotify) | Andre Filipe de Assuncao e Brito et. al. | LGPL-2.1-or-later |
| [polybar](https://github.com/polybar/polybar) | Patrick Ziegler, Michael Carlberg | MIT |

---

## Repository Structure

```
dotfiles/
├── alacritty/    # Terminal emulator config
├── fastfetch/    # System info display config
├── i3/           # i3 window manager config + bar scripts + wallpapers + ~/.local/bin scripts
├── nvim/         # Neovim config (C# development)
├── picom/        # Compositor config
├── rofi/         # App launcher config
├── x11/          # X11 session environment (.xprofile)
├── yabai/        # macOS tiling WM config
└── zsh/          # ZSH shell config + plugins (plugins gitignored)
```
