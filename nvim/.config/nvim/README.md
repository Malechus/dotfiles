# Neovim Configuration

This config is optimized for C# development. It uses [vim-plug](https://github.com/junegunn/vim-plug) for plugin management and follows a modular structure — each concern lives in its own file under `lua/config/` or `lua/plugins/`.

---

## Fresh System Setup

### 1. Install vim-plug

```sh
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

### 2. Stow the nvim package

From the dotfiles repo root:

```sh
stow nvim
```

### 3. Install vim-plug plugins

```sh
nvim +PlugInstall +qall
```

### 4. Let mason auto-install language servers

Open nvim after PlugInstall. Mason will automatically download and install:
- `omnisharp` — C# language server
- `netcoredbg` — C# debugger

This requires an internet connection and .NET SDK. Progress is shown in the `:Mason` window.

### 5. Install a C compiler (if not present)

Treesitter compiles parsers locally and needs gcc or clang:

```sh
sudo apt install gcc   # Debian/Ubuntu
```

### 6. Install the C# Treesitter parser

Inside nvim:

```
:TSInstall c_sharp
```

---

## Config Structure

```
nvim/.config/nvim/
├── init.lua               # Plugin declarations (vim-plug) + require() calls
└── lua/
    ├── config/
    │   ├── options.lua    # vim options, leader key
    │   ├── colors.lua     # catppuccin theme setup
    │   └── mapping.lua    # all keybindings
    └── plugins/
        ├── autopair.lua   # nvim-autopairs
        ├── line-numbers.lua
        ├── nvim-tree.lua  # file explorer
        ├── lsp.lua        # mason + lspconfig + omnisharp
        ├── cmp.lua        # completion engine
        ├── telescope.lua  # fuzzy finder
        ├── treesitter.lua # syntax highlighting
        └── dap.lua        # debugger
```

`init.lua` loads `config.options` first (sets the leader key), then `config.colors`, then `config.mapping`. Plugin configs are loaded last.

---

## Keybindings

The leader key is `<Space>`.

### File Explorer

| Key | Action |
|---|---|
| `Ctrl+O` | Toggle nvim-tree file explorer |

### Telescope (fuzzy finder)

| Key | Action |
|---|---|
| `<leader>ff` | Find files by name |
| `<leader>fg` | Live grep across the project |
| `<leader>fb` | List and switch open buffers |
| `<leader>fr` | Recently opened files |

Inside a Telescope window: `<Enter>` opens, `<Esc>` closes, `<Ctrl+/>`  shows available actions.

### LSP (active when a language server is attached)

| Key | Action |
|---|---|
| `gd` | Go to definition (works on decompiled sources) |
| `gD` | Go to declaration |
| `gi` | Go to implementation |
| `gr` | Find all references (opens in Telescope) |
| `K` | Hover documentation |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code actions |
| `<leader>f` | Format buffer |
| `[d` | Jump to previous diagnostic |
| `]d` | Jump to next diagnostic |

### Completion

Completion triggers automatically as you type. When the popup is open:

| Key | Action |
|---|---|
| `Tab` | Select next item / expand snippet |
| `Shift+Tab` | Select previous item |
| `Enter` | Confirm selection |
| `Ctrl+Space` | Manually trigger completion |
| `Ctrl+E` | Abort / close popup |

### Debugger (DAP)

| Key | Action |
|---|---|
| `<F5>` | Start or continue debug session |
| `<F10>` | Step over |
| `<F11>` | Step into |
| `<F12>` | Step out |
| `<leader>db` | Toggle breakpoint on current line |
| `<leader>du` | Toggle DAP UI panel |

The DAP UI opens automatically when a debug session starts and closes when it ends.

---

## C# Workflow

### Opening a project

Open nvim from the solution or project root so OmniSharp can find the `.sln` or `.csproj` file:

```sh
cd ~/source/repos/MyProject
nvim .
```

OmniSharp loads in the background. The status line will show `[LSP]` once it is ready (this may take a few seconds on first open for large solutions).

### Navigation

- `gd` on any method call, property, or type jumps to its definition. If the symbol is in a NuGet dependency, OmniSharp decompiles the source on-the-fly and opens it in a read-only buffer.
- `gr` lists every place a symbol is used, displayed in a Telescope picker. Navigate with arrow keys or `j/k`, press `Enter` to jump.
- `gi` jumps to the implementation of an interface member.
- `<leader>ff` / `<leader>fg` let you navigate by filename or text pattern across the whole project.

### Diagnostics

Errors and warnings from OmniSharp appear inline as virtual text and in the sign column. Use `[d` / `]d` to step through them without leaving the keyboard.

### Debugging

1. Build the project in Debug configuration: `dotnet build`
2. Press `<F5>` — you will be prompted for the path to the output `.dll` (e.g. `bin/Debug/net8.0/MyApp.dll`).
3. Set breakpoints before or during a session with `<leader>db`.
4. Use `<F10>` / `<F11>` / `<F12>` to step through code.
5. Press `<F5>` again to continue to the next breakpoint.
6. The DAP UI (left panel + bottom panel) shows local scopes, the call stack, active breakpoints, and the debug console.

To attach to a running process instead of launching: the debug config menu (shown when you press `<F5>`) includes an "Attach" option that lets you pick a running .NET process by PID.

---

## Plugin Summary

| Plugin | Role |
|---|---|
| catppuccin/nvim | Color theme (Macchiato, transparent) |
| nvim-web-devicons | File type icons |
| nvim-tree.lua | File explorer sidebar |
| line-numbers.nvim | Hybrid relative + absolute line numbers |
| nvim-autopairs | Auto-close brackets and quotes |
| nvim-lspconfig | LSP client |
| mason.nvim | Install and update LSP servers and DAP adapters |
| mason-lspconfig.nvim | Auto-configure mason-installed LSP servers |
| omnisharp-extended-lsp.nvim | Decompiled-source go-to-definition for C# |
| nvim-cmp | Completion engine |
| cmp-nvim-lsp | LSP completions |
| cmp-buffer | Word completions from open buffers |
| cmp-path | File path completions |
| LuaSnip | Snippet engine |
| cmp_luasnip | Snippet completions |
| plenary.nvim | Lua utilities (Telescope dependency) |
| telescope.nvim | Fuzzy file / grep / buffer picker |
| nvim-treesitter | AST-based syntax highlighting |
| nvim-dap | Debug Adapter Protocol client |
| nvim-dap-ui | Debugger UI panels |
| nvim-nio | Async I/O (dap-ui dependency) |
| mason-nvim-dap.nvim | Auto-install DAP adapters via mason |
