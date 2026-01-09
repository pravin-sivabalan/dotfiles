# Karabiner DSL Compiler Design

A text-based, natural language-like programming language for maintaining Karabiner configurations.

## Design Decisions

- **Notation**: Text-based (`cmd+d -> opt+delete`)
- **Layer semantics**: Hold-based (active while trigger key is held)
- **Swap behavior**: Automatically handles modifier variants
- **Scope**: No imports, no user-defined variables beyond layers

---

## Keywords

### Mapping Keywords

| Keyword | Description | Example |
|---------|-------------|---------|
| `map` | One-way key mapping | `map j to down` |
| `swap` | Bidirectional mapping (auto-handles modifiers) | `swap backslash with delete` |

### Layer Keywords

| Keyword | Description | Example |
|---------|-------------|---------|
| `layer` | Define a hold-based layer | `layer vim { ... }` |
| `activate with` | Key that activates the layer | `activate with caps_lock` |
| `when alone send` | Key sent if layer key released without combo | `when alone send f19` |

### Condition Keywords

| Keyword | Description | Example |
|---------|-------------|---------|
| `on internal keyboard` | Only on built-in keyboard | `on internal keyboard { ... }` |
| `on external keyboard` | Only on external keyboards | `on external keyboard { ... }` |
| `in app` | Only in specific application | `in app "com.apple.Terminal" { ... }` |
| `not in app` | Exclude specific application | `not in app "com.google.Chrome" { ... }` |

### Modifier Keywords

| Keyword | Aliases | Description |
|---------|---------|-------------|
| `command` | `cmd` | Command key |
| `option` | `opt`, `alt` | Option key |
| `control` | `ctrl` | Control key |
| `shift` | - | Shift key |
| `fn` | - | Function key |
| `any` | - | Any modifier allowed |

### Behavior Keywords

| Keyword | Description | Example |
|---------|-------------|---------|
| `with repeat` | Key repeats when held | `map j to down with repeat` |

### Organization Keywords

| Keyword | Description | Example |
|---------|-------------|---------|
| `group` | Named group of rules | `group "Navigation" { ... }` |
| `#` | Single-line comment | `# This is a comment` |

---

## Grammar

```ebnf
program        = statement* ;

statement      = layer_def
               | condition_block
               | group_def
               | mapping
               | comment ;

layer_def      = "layer" IDENTIFIER "{" layer_body "}" ;
layer_body     = activate_stmt? alone_stmt? mapping* ;
activate_stmt  = "activate" "with" key ;
alone_stmt     = "when" "alone" "send" key ;

condition_block = condition "{" statement* "}" ;
condition      = device_condition | app_condition ;
device_condition = "on" ("internal" | "external") "keyboard" ;
app_condition  = ("in" | "not" "in") "app" STRING ;

group_def      = "group" STRING "{" statement* "}" ;

mapping        = map_stmt | swap_stmt ;
map_stmt       = "map" key_expr "to" key_expr behavior? ;
swap_stmt      = "swap" key "with" key ;

key_expr       = modifier_chain? key ;
modifier_chain = modifier ("+" modifier)* "+" ;
modifier       = "cmd" | "command" | "opt" | "option" | "alt"
               | "ctrl" | "control" | "shift" | "fn" ;

behavior       = "with" "repeat"
               | "with" "any" ;

key            = IDENTIFIER | STRING ;
comment        = "#" TEXT_TO_EOL ;

IDENTIFIER     = [a-zA-Z_][a-zA-Z0-9_]* ;
STRING         = '"' [^"]* '"' ;
```

---

## Key Names

### Letters & Numbers
`a` - `z`, `0` - `9`

### Modifiers (as keys)
| Key | Variants |
|-----|----------|
| `left_command` | `left_cmd` |
| `right_command` | `right_cmd` |
| `left_option` | `left_opt`, `left_alt` |
| `right_option` | `right_opt`, `right_alt` |
| `left_control` | `left_ctrl` |
| `right_control` | `right_ctrl` |
| `left_shift` | - |
| `right_shift` | - |
| `caps_lock` | - |
| `fn` | - |

### Navigation
| Key | Aliases |
|-----|---------|
| `up_arrow` | `up` |
| `down_arrow` | `down` |
| `left_arrow` | `left` |
| `right_arrow` | `right` |
| `page_up` | `pgup` |
| `page_down` | `pgdn` |
| `home` | - |
| `end` | - |

### Editing
| Key | Aliases |
|-----|---------|
| `delete_or_backspace` | `delete`, `backspace` |
| `delete_forward` | `forward_delete` |
| `return_or_enter` | `return`, `enter` |
| `escape` | `esc` |
| `tab` | - |
| `spacebar` | `space` |

### Punctuation
| Key | Aliases |
|-----|---------|
| `grave_accent_and_tilde` | `grave`, `tilde`, `backtick` |
| `hyphen` | `minus` |
| `equal_sign` | `equals` |
| `open_bracket` | `left_bracket`, `[` |
| `close_bracket` | `right_bracket`, `]` |
| `backslash` | `\` |
| `semicolon` | `;` |
| `quote` | `'` |
| `comma` | `,` |
| `period` | `.` |
| `slash` | `/` |

### Function Keys
`f1` - `f20`

### Media Keys
| Key | Aliases |
|-----|---------|
| `volume_increment` | `volume_up`, `vol_up` |
| `volume_decrement` | `volume_down`, `vol_down` |
| `mute` | - |
| `display_brightness_increment` | `brightness_up`, `bright_up` |
| `display_brightness_decrement` | `brightness_down`, `bright_down` |
| `play_or_pause` | `play_pause` |
| `fastforward` | `next_track` |
| `rewind` | `prev_track` |

---

## Semantic Rules

### 1. Swap Modifier Expansion

When you write:
```
swap backslash with delete
```

The compiler generates mappings for:
- `backslash` ↔ `delete`
- `cmd+backslash` ↔ `cmd+delete`
- `opt+backslash` ↔ `opt+delete`
- `ctrl+backslash` ↔ `ctrl+delete`
- `shift+backslash` ↔ `shift+delete`
- `cmd+shift+backslash` ↔ `cmd+shift+delete`
- (all common modifier combinations)

### 2. Layer Semantics

Layers are hold-activated:
- Pressing the trigger key sets a variable to 1
- Releasing the trigger key sets the variable to 0
- Rules inside the layer only fire when the variable is 1
- `when alone send X` fires if trigger released without pressing other keys

### 3. Condition Scoping

Conditions apply to all rules within their block:
```
on internal keyboard {
    swap backslash with delete    # Only on internal keyboard
    map grave to escape           # Also only on internal keyboard
}
```

### 4. Group Semantics

Groups are purely organizational (affect the `description` field in JSON output):
```
group "Navigation" {
    map j to down
}
```

---

## Example: Full Configuration

```karabiner
# Caps Lock Vim Layer
layer vim {
    activate with caps_lock
    when alone send f19

    # Navigation
    map j to down with repeat
    map k to up with repeat
    map h to left with repeat
    map l to right with repeat
    map u to page_up
    map d to page_down

    # Word movement
    map w to opt+right
    map b to opt+left

    # Line movement
    map a to cmd+left
    map e to cmd+right

    # Editing
    map y to cmd+c
    map p to cmd+v

    # Delete operations
    map x to delete
    map s to ctrl+k

    # Exit
    map return to caps_lock
}

# Internal keyboard only
on internal keyboard {
    swap backslash with delete
    map grave to escape
}

# Global remaps
map right_control to left_option
map cmd+escape to cmd+grave
map right_cmd+escape to grave
map left_cmd+delete to grave

# Media layer
layer media {
    activate with right_command

    map 9 to brightness_up
    map 8 to brightness_down
    map equals to volume_up
    map minus to volume_down
    map 0 to mute
    map left_bracket to prev_track
    map right_bracket to next_track
    map p to play_pause
}
```

---

## Compiler Output

The compiler transforms the DSL into Karabiner's JSON format:

```json
{
  "title": "Generated Configuration",
  "rules": [
    {
      "description": "vim layer",
      "manipulators": [
        {
          "type": "basic",
          "from": { "key_code": "j", "modifiers": { "optional": ["any"] } },
          "to": [{ "key_code": "down_arrow", "repeat": true }],
          "conditions": [{ "type": "variable_if", "name": "vim_layer", "value": 1 }]
        }
        // ... more manipulators
      ]
    }
  ]
}
```

---

## Compiler Architecture

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   Lexer     │────▶│   Parser    │────▶│  Semantic   │────▶│   Code      │
│             │     │             │     │  Analyzer   │     │   Generator │
└─────────────┘     └─────────────┘     └─────────────┘     └─────────────┘
     │                    │                   │                    │
     ▼                    ▼                   ▼                    ▼
  Tokens               AST              Validated AST         JSON Output
```

### Phases

1. **Lexer**: Tokenizes input into keywords, identifiers, operators
2. **Parser**: Builds Abstract Syntax Tree from tokens
3. **Semantic Analyzer**:
   - Validates key names
   - Expands swap statements
   - Resolves aliases
   - Checks for conflicts
4. **Code Generator**: Produces Karabiner JSON

---

## Error Messages

The compiler should produce helpful error messages:

```
error[E001]: Unknown key 'backslahs'
  --> config.kb:12:5
   |
12 |     map backslahs to delete
   |         ^^^^^^^^^ did you mean 'backslash'?

error[E002]: Conflicting mappings for 'j'
  --> config.kb:8:5
   |
 8 |     map j to down
   |         ^ first defined here
   |
  --> config.kb:15:5
   |
15 |     map j to up
   |         ^ conflicting definition
```

---

## File Extension

`.kb` - Karabiner DSL files

---

## Next Steps

1. Implement lexer (tokenization)
2. Implement parser (AST generation)
3. Implement semantic analyzer (validation & expansion)
4. Implement code generator (JSON output)
5. Add CLI interface
6. Integrate with existing sync script
