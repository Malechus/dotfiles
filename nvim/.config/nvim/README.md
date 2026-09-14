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
- `netcoredbg` — C# debugger
- `cucumber-language-server` — Cucumber/Gherkin language server for `.feature` files

The C# language server itself (Roslyn) is installed separately — run `:MasonInstall roslyn` once. It comes from the `Crashdummyy/mason-registry` custom registry (configured in `lua/plugins/lsp.lua`), which tracks the same Roslyn version shipped with VS Code's C# extension.

This requires an internet connection and .NET SDK. Progress is shown in the `:Mason` window.

### 5. Install build dependencies (if not present)

Treesitter compiles parsers locally and requires a C compiler (`gcc` or `clang`) and the `tree-sitter` CLI:

```sh
# Arch Linux
sudo pacman -S gcc tree-sitter-cli

# Debian/Ubuntu
sudo apt install gcc tree-sitter-cli
```

### 6. Install the C# Treesitter parser

Inside nvim:

```
:TSInstall c_sharp
```
Replace `c_sharp` with your language of choice(s)

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
        ├── lualine.lua      # statusline, including Git branch
        ├── nvim-tree.lua  # file explorer
        ├── lsp.lua        # mason + lspconfig + roslyn (C#)
        ├── cmp.lua        # completion engine
        ├── telescope.lua  # fuzzy finder
        ├── treesitter.lua # syntax highlighting
        └── dap.lua        # debugger
```

`init.lua` loads `config.options` first (sets the leader key), then `config.colors`, then `config.mapping`. Plugin configs are loaded last.

---

## Cucumber Workflow

Open Neovim from a repository containing your Cucumber project. Mason installs and starts `cucumber-language-server` for `.feature` files automatically. It supplies diagnostics, step-definition navigation, hover documentation, and completion through the existing LSP keybindings and `nvim-cmp` integration.

If Mason has not yet installed it, run `:Mason` and wait for `cucumber-language-server` to finish installing, then reopen the `.feature` file.

---

## Keybindings

The leader key is `<Space>`.

### Command Line

After typing `:!` and part of a shell command or path, press `Tab` to complete it. The first press expands the shared prefix and displays matching candidates; press `Tab` again to cycle through them.

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

Open nvim from the solution or project root so Roslyn can find the `.sln` or `.csproj` file:

```sh
cd ~/source/repos/MyProject
nvim .
```

Roslyn loads in the background. The status line will show `[LSP]` once it is ready (this may take a few seconds on first open for large solutions).

> [!NOTE]
> The C# LSP used to be OmniSharp, but it was replaced with Roslyn (via `roslyn.nvim`) because OmniSharp is discontinued and has a long-standing bug where it occasionally sends a bare JSON `null` message that Neovim's LSP client can't parse, logged as `INVALID_SERVER_MESSAGE: vim.NIL`. Roslyn is the same language server used by VS Code's C# extension and doesn't have this issue.

### Navigation

- `gd` on any method call, property, or type jumps to its definition. If the symbol is in a NuGet dependency, Roslyn decompiles the source on-the-fly and opens it in a read-only buffer (built into `roslyn.nvim`, no extra plugin needed).
- `gr` lists every place a symbol is used, displayed in a Telescope picker. Navigate with arrow keys or `j/k`, press `Enter` to jump.
- `gi` jumps to the implementation of an interface member.
- `<leader>ff` / `<leader>fg` let you navigate by filename or text pattern across the whole project.

### Diagnostics

Errors and warnings from Roslyn appear inline as virtual text and in the sign column. Use `[d` / `]d` to step through them without leaving the keyboard.

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
| lualine.nvim | Statusline with the current Git branch, diff stats, and diagnostics |
| nvim-autopairs | Auto-close brackets and quotes |
| nvim-lspconfig | LSP client |
| mason.nvim | Install and update LSP servers and DAP adapters |
| mason-lspconfig.nvim | Auto-configure mason-installed LSP servers |
| cucumber-language-server | Cucumber/Gherkin language server |
| roslyn.nvim | C# language server (Roslyn) client, replaces OmniSharp |
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
