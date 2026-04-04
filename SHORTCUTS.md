# Shortcuts

## Karabiner — Global (all apps)

| Input | Output | Notes |
|---|---|---|
| `caps lock` (hold) | Modifier layer | Activates caps lock shortcuts below |
| `caps lock` (tap) | `ctrl space` | tmux prefix key |
| `caps lock` + `h` | `←` | |
| `caps lock` + `j` | `↓` | |
| `caps lock` + `k` | `↑` | |
| `caps lock` + `l` | `→` | |
| `caps lock` + `w` | `option →` | Word forward |
| `caps lock` + `b` | `option ←` | Word backward |
| `caps lock` + `e` | `cmd →` | End of line |
| `caps lock` + `a` | `ctrl ←` | Beginning of line |
| `caps lock` + `s` | `ctrl shift ←` then `backspace` | Delete to beginning of line |
| `caps lock` + `c` | `ctrl →` then `ctrl shift ←` then `backspace` | Delete current word |
| `caps lock` + `d` | `option backspace` | Delete word backward |
| `caps lock` + `u` | `page up` | |
| `caps lock` + `y` | `cmd c` | Copy |
| `caps lock` + `p` | `cmd v` | Paste |
| `caps lock` + `enter` | `caps lock` | Toggle real caps lock |
| `left cmd` + `esc` | `cmd ~` | Cycle windows (forward) |
| `right cmd` + `esc` | `~` | Type tilde |
| `right cmd` + `8` | Brightness down | |
| `right cmd` + `9` | Brightness up | |
| `right cmd` + `-` | Volume down | |
| `right cmd` + `=` | Volume up | |
| `right cmd` + `0` | Mute | |
| `right cmd` + `[` | Previous track | |
| `right cmd` + `]` | Next track | |
| `right cmd` + `p` | Play / pause | |

## Karabiner — Internal keyboard only

| Input | Output |
|---|---|
| `` ` `` (tilde key) | `esc` |
| `\` | `backspace` |
| `cmd \` | `cmd backspace` |
| `option \` | `option backspace` |
| `ctrl \` | `ctrl backspace` |
| `backspace` | `\` |
| `cmd backspace` | `cmd \` |
| `option backspace` | `option \` |
| `ctrl backspace` | `ctrl \` |
| `left cmd` + `backspace` | `` ` `` (tilde) |
| `right ctrl` | `left option` |

## Karabiner — Ghostty only

| Input | tmux action |
|---|---|
| `cmd t` | New window |
| `cmd w` | Kill current window |
| `cmd d` | Split pane vertically |
| `cmd [` | Select pane left |
| `cmd ]` | Select pane right |
| `cmd 1–9` | Switch to window 1–9 |

## tmux

The prefix key is `caps lock` (sends `ctrl space`).

### Windows

| Shortcut | Action |
|---|---|
| `prefix c` | New window |
| `prefix &` | Kill window (no confirm) |
| `prefix ,` | Rename window |
| `prefix w` | List windows |
| `prefix 1–9` | Switch to window 1–9 |
| `prefix n` | Next window |
| `prefix p` | Previous window |
| `prefix l` | Last (most recent) window |

### Panes

| Shortcut | Action |
|---|---|
| `prefix %` | Split horizontally |
| `prefix "` | Split vertically |
| `prefix ←` | Select pane left |
| `prefix →` | Select pane right |
| `prefix o` | Cycle panes |
| `prefix x` | Kill pane (with confirm) |
| `prefix z` | Toggle pane zoom |
| `prefix {` | Swap pane left |
| `prefix }` | Swap pane right |

### Other

| Shortcut | Action |
|---|---|
| `prefix [` | Enter copy mode (vi keys) |
| `prefix ]` | Paste from buffer |
| `prefix d` | Detach session |
| `prefix s` | List sessions |
| `prefix $` | Rename session |
| `prefix :` | Command prompt |
| `prefix ?` | List all key bindings |
