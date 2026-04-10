#!/bin/bash
# Smart focus: move focus in <direction> within the current monitor.
# If the focused window doesn't change (nothing in that direction),
# fall through to focus the adjacent monitor in that direction.

export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

DIRECTION=$1

BEFORE=$(aerospace list-windows --focused 2>/dev/null)
aerospace focus --boundaries monitor --boundaries-action stop "$DIRECTION" 2>/dev/null
AFTER=$(aerospace list-windows --focused 2>/dev/null)

if [ "$BEFORE" = "$AFTER" ]; then
    aerospace focus-monitor "$DIRECTION" 2>/dev/null
fi
