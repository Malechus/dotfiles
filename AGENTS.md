## System Execution Flow & Configuration Quirks

This section details highly specific setup requirements and operational flow orders for core tools, ensuring maximum signal density and adherence to technical reality.

### ⚙️ Environment Variable Edge Cases

*   **X Session Variables:** Any environment variables required by the Window Manager (i3) or its subprocesses (e.g., `$PATH` additions for local scripts) must be set in `~/.xprofile`.
    *   **Reason:** Shell startup files like `.bashrc` and `.zshrc` are not sourced when a Display Manager starts an X session; only directives handled by `/etc/X11/Xsession` or similar utilities guarantee execution of content from `~/.xprofile`.
    *   **Actionable Example:** Prepends `~/.local/bin` to `$PATH`:
        ```sh
        export PATH="$HOME/.local/bin:$PATH"
        ```

### 🧠 Neovim Plugin Setup Order (Critical for LSP Functionality)

The installation of advanced functionality requires a strict, multi-stage process that cannot be done via simple plugin managers alone.

1.  **Plugin Source:** Use `vim-plug` to manage the core repository structure (`:PlugInstall`).
2.  **LSP Server Provisioning (Requires Internet):** Upon first launch post-install, rely on `mason.nvim` for server discovery and installation. *Do not* manually install LSP servers outside of this flow.
3.  **Parser Compilation:** For Language Server Protocol clients like `nvim-treesitter`, the underlying system must have a C compiler installed (e.g., `sudo apt install gcc`). Treesitter will auto-attempt compilation but requires the toolchain to exist.
4.  **Language Parser Inclusion (Highest Signal):** The specific language parser (`c_sharp` in this case) **must** be manually installed inside Neovim using the `:TSInstall <parser>` command after all other setup steps are complete.

### 💾 i3 Window Manager Configuration Flow

The configuration loading order is strictly procedural and uses a numbered include system to guarantee definitions take effect correctly:

*   **Keybindings Definition:** Defined first in `01-keybindings-i3.conf` (least likely to be overwritten).
*   **Modes/State Management:** Next, define modes like resize mode (`02-modes-i3.conf`). These often establish global state needed for subsequent rules.
*   **Core Settings & Variables:** Global settings (gaps, fonts) are set in `05-settings-i3.conf`.
*   **Workspace Assignments:** Window managers assign apps to workspaces via `04-workspaces-i3.conf`, which must follow core configuration parameters being active.
*   **Autostart Execution (Final Step):** The `ZZ-startup-i3.conf` runs last and is responsible for *executing* system setup (e.g., wallpaper scripts, initial app launches) after the entire config graph has been loaded.

### ✨ ZSH Prompt Structure Details

The default shell prompt (`PS1`) uses a complex multi-component coloring system that relies on specific formatting directives:

1.  **User/Host:** Always displayed in yellow/gold (via `\e[33m` or similar color codes).
2.  **Path:** The directory structure is printed in teal, limited to four subdirectory levels for concise display.
3.  **Git Branching:** If inside a Git repository, the branch name overrides part of the path formatting and adopts mauve/purple coloring. This component only activates *within* the `.git` directory tree context.
4.  **Prompt Separator:** A critical quirk is that a **blank line** is programmatically inserted between every prompt after the initial shell session launch, improving visual separation from the preceding command output history.

### 🧩 Tool Chain Sequencing

| Tool | Dependency/Prerequisite | Critical Order Fact |
|:---|:---|:---|
| `zsh` Prompt | `vcs_info`, `fastfetch` | The prompt template must define both components; failure to source either results in a non-functional placeholder. |
| `i3` Window Manager | External Scripts (`scripts/`); Wallpaper configs (`i3/`) | System image setup (wallpapers, background resolution) *must* be handled by scripts executed during the final startup phase (`ZZ-startup-*`). |
| `picom` Compositor | Correct Backend Selection | Always use `xrender` with `vsync`. Changing backgrounds or geometry parameters without updating these settings leads to visual tearing and poor performance. |