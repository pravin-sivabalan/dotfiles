# Karabiner-Elements Configuration Reference

This document contains resources and code snippets for maintaining and validating Karabiner-Elements complex modifications.

## Official Resources

### Documentation
- **Official Documentation**: https://karabiner-elements.pqrs.org/docs/
- **JSON Reference**: https://karabiner-elements.pqrs.org/docs/json/
- **Complex Modifications**: https://karabiner-elements.pqrs.org/docs/json/complex-modifications-manipulator-definition/

### Key Code References
- **Key Code List**: https://github.com/pqrs-org/Karabiner-Elements/blob/main/src/apps/SettingsWindow/Resources/simple_modifications.json
- **Consumer Key Codes** (media keys): https://github.com/pqrs-org/Karabiner-Elements/blob/main/src/share/types/consumer_key_code.hpp

### Examples & Community
- **Complex Modifications Gallery**: https://ke-complex-modifications.pqrs.org/
- **GitHub Examples**: https://github.com/pqrs-org/KE-complex_modifications

## Validation Commands

### 1. JSON Syntax Validation
```bash
# Validate JSON syntax
jq empty private_dot_config/private_karabiner/private_assets/private_complex_modifications/global.json && echo "✓ Valid JSON"

# Pretty print and check
jq . private_dot_config/private_karabiner/private_assets/private_complex_modifications/global.json
```

### 2. Structure Validation
```bash
# Check configuration structure
jq -r '
  "Title: " + .title,
  "Rules: " + (.rules | length | tostring),
  (.rules[] |
    "  Rule: " + .description,
    "  Manipulators: " + (.manipulators | length | tostring)
  )
' private_dot_config/private_karabiner/private_assets/private_complex_modifications/global.json
```

### 3. Key Code Extraction
```bash
# List all key codes used
jq -r '
  [.rules[].manipulators[].from.key_code] +
  [.rules[].manipulators[].to[]?.key_code? // empty] |
  unique |
  sort[]
' private_dot_config/private_karabiner/private_assets/private_complex_modifications/global.json
```

### 4. Karabiner CLI Validation (macOS only)
```bash
# Lint complex modifications
/Library/Application\ Support/org.pqrs/Karabiner-Elements/bin/karabiner_cli \
  --lint-complex-modifications ~/.config/karabiner/assets/complex_modifications/global.json
```

## Common Key Codes

### Media Keys
```json
"volume_increment"      // Volume up
"volume_decrement"      // Volume down
"mute"                  // Mute/unmute

"rewind"                // Previous track
"fastforward"           // Next track
"play_or_pause"         // Play/pause toggle
```

### Display Keys
```json
"display_brightness_increment"  // Brightness up
"display_brightness_decrement"  // Brightness down
```

### Navigation Keys
```json
"up_arrow"
"down_arrow"
"left_arrow"
"right_arrow"
"page_up"
"page_down"
"home"
"end"
```

### Special Keys
```json
"escape"
"return_or_enter"
"delete_or_backspace"
"delete_forward"
"tab"
"spacebar"
"caps_lock"
```

## Configuration Patterns

### Basic Manipulator Structure
```json
{
  "conditions": [
    {
      "name": "caps_lock pressed",
      "type": "variable_if",
      "value": 1
    }
  ],
  "from": {
    "key_code": "j",
    "modifiers": {
      "optional": ["any"]
    }
  },
  "to": [
    {
      "key_code": "down_arrow"
    }
  ],
  "type": "basic"
}
```

### Modifier Requirements
```json
// No modifiers required (but allows any)
"modifiers": {
  "optional": ["any"]
}

// Specific modifier required (e.g., Command)
"modifiers": {
  "mandatory": ["command"],
  "optional": ["any"]
}

// Multiple modifiers required
"modifiers": {
  "mandatory": ["command", "shift"]
}
```

### Variable-based Layer System
```json
// Set variable when key is pressed
"from": {
  "key_code": "caps_lock"
},
"to": [
  {
    "set_variable": {
      "name": "caps_lock pressed",
      "value": 1
    }
  }
],
"to_after_key_up": [
  {
    "set_variable": {
      "name": "caps_lock pressed",
      "value": 0
    }
  }
],
"to_if_alone": [
  {
    "key_code": "escape"
  }
]
```

## Testing & Troubleshooting

### 1. Karabiner-EventViewer
Use the built-in EventViewer to see real-time key events:
```bash
open /Applications/Karabiner-EventViewer.app
```

### 2. Check Logs
View Karabiner logs for errors:
- Open Karabiner-Elements
- Go to "Log" tab
- Look for errors related to your configuration

### 3. Common Issues

**Issue**: Configuration not loading
- Check JSON syntax with `jq`
- Look for errors in Karabiner Log tab
- Ensure file is in correct directory: `~/.config/karabiner/assets/complex_modifications/`

**Issue**: Key mapping not working
- Use EventViewer to confirm key codes
- Check if another rule is conflicting
- Verify modifier requirements

**Issue**: Variable conditions not triggering
- Ensure variable is set in the `to` field
- Check `to_after_key_up` clears the variable
- Verify condition checks correct variable name

## File Locations (macOS)

```
~/.config/karabiner/
├── karabiner.json                           # Main config
└── assets/
    └── complex_modifications/
        ├── global.json                      # Your custom rules
        └── vimlike.json                     # Other custom rules
```

## Quick Reference: Current Configuration

### Navigation Layer (Caps Lock)
- `Caps + H/J/K/L` → Arrow keys
- `Caps + D/U` → Page Down/Up
- `Caps alone` → Escape

### Media Controls
- `Caps + =` → Volume Up
- `Caps + -` → Volume Down
- `Caps + 0` → Mute

### Brightness Controls
- `Caps + Cmd + =` → Brightness Up
- `Caps + Cmd + -` → Brightness Down

### Playback Controls
- `Caps + ,` → Previous Track
- `Caps + .` → Next Track
- `Caps + /` → Play/Pause

### System
- `Caps + Enter` → Toggle Caps Lock
- `Caps + A` → Toggle Caps Lock
