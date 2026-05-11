# Neovim Config

My LazyVim-based setup..leader is `Space`.

## Navigation

| Key                              | Action                                 |
| -------------------------------- | -------------------------------------- |
| `<leader>e`                      | Toggle file explorer                   |
| `<leader>ff` / `<leader><space>` | Find files (includes hidden/dotfiles!) |
| `<leader>sg`                     | Live grep (includes hidden files!)     |
| `<leader>fb`                     | Find open buffers                      |
| `H` (in explorer)                | Toggle dotfile visibility              |
| `?` (in explorer)                | Show all explorer keybindings          |

## Terminal

| Key       | Action                     |
| --------- | -------------------------- |
| `Ctrl+/`  | Toggle bottom terminal     |
| `Ctrl+]`  | Toggle right-side terminal |

## Git

| Key           | Action                                                   |
| ------------- | -------------------------------------------------------- |
| `<leader>gg`  | Open lazygit (full git TUI)                              |
| `<leader>gs`  | Git status picker (search/filter, `Esc` for normal mode) |
| `<leader>gb`  | Git blame line                                           |
| `<leader>ghs` | Stage hunk (gitsigns)                                    |
| `<leader>ghr` | Reset hunk (gitsigns)                                    |
| `<leader>ghp` | Preview hunk (gitsigns)                                  |

### Lazygit quick ref

| Key                 | Action                 |
| ------------------- | ---------------------- |
| `Tab` / `Shift+Tab` | Switch panels          |
| `Space`             | Stage/unstage file     |
| `a`                 | Stage/unstage all      |
| `c`                 | Commit                 |
| `P`                 | Push                   |
| `p`                 | Pull                   |
| `q`                 | Quit                   |
| `?`                 | Show panel keybindings |

## Tools

| Key         | Action                                       |
| ----------- | -------------------------------------------- |
| `<leader>u` | Toggle undotree (undo history visualization) |

## Harpoon

| Key         | Action              |
| ----------- | ------------------- |
| `<leader>H` | Add file to harpoon |
| `<leader>h` | Harpoon menu        |

## Ask Claude

One-shot prompts to Claude from inside nvim. Answer appears in a floating window at the bottom.

| Key            | Mode  | Action                                                |
| -------------- | ----- | ----------------------------------------------------- |
| `<leader>aa`   | n + x | Ask Claude (new conversation)                         |
| `<leader>ac`   | n + x | Ask Claude (continue last session in cwd)             |
| `<leader>ai`   | n + x | Ask Claude (full env: all MCP servers, all tools)     |
| `<leader>an`   | n     | Clear Claude scratch                                  |
| `<leader>aw`   | n     | Toggle Claude window                                  |
| `q` (in float) | n     | Close Claude window                                   |

Visual mode includes the selection as a fenced code block with a line-range badge. All modes prepend the current file path so Claude can `Read`/`Grep` related files. Lite modes (`aa`/`ac`) strip MCP servers and restrict to read-only tools for speed.

## Extras Enabled

- harpoon2
- black (python formatting)
- prettier (js/ts formatting)
- go, json, markdown, python language support
- dot (dotfile editing)
