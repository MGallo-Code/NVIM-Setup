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

| Key            | Action                     |
| -------------- | -------------------------- |
| `Ctrl+/`       | Toggle bottom terminal     |
| `Ctrl+Shift+/` | Toggle right-side terminal |

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

## Extras Enabled

- harpoon2
- black (python formatting)
- prettier (js/ts formatting)
- go, json, markdown, python language support
- dot (dotfile editing)
