#!/usr/bin/env bash
# ==============================================================================
# patch-ibus-avro.sh
# Fixes Avro Phonetic on Linux Wayland:
# 1. Left Shift bug (swallowing Left Shift keycode 42 and Right Shift 54)
# 2. GTK3 / GTK4 process collision when opening preferences
# 3. Verbose debug print spam filling journal logs
# Reference: https://mfaruk.com/blog/fixing-avro-phonetic-ubuntu-wayland-left-shift-bug
# ==============================================================================

set -euo pipefail

TARGET_FILE="/usr/share/ibus-avro/main-gjs.js"

if [[ ! -f "$TARGET_FILE" ]]; then
    echo "[-] ibus-avro is not installed at $TARGET_FILE. Skipping patch."
    exit 0
fi

echo "[*] Applying Wayland Left Shift & GJS stability patches to $TARGET_FILE..."

sudo python3 - << 'EOF'
import re
import sys

target = '/usr/share/ibus-avro/main-gjs.js'
with open(target, 'r', encoding='utf-8') as f:
    content = f.read()

# 1. Pass through Left Shift (42) and Right Shift (54) instead of capturing and swallowing
content = re.sub(
    r'// capture the shift key\s*\n\s*if \(keycode == 42\) \{\s*\n\s*return true;\s*\n\s*\}',
    '// Pass through Left Shift (42) and Right Shift (54)\n        if (keycode == 42 || keycode == 54) {\n            return false;\n        }',
    content
)
content = re.sub(
    r'if\s*\(\s*keycode\s*==\s*42\s*\)\s*\{\s*return\s+true\s*;\s*\}',
    'if (keycode == 42 || keycode == 54) {\n            return false;\n        }',
    content
)

# 2. Avoid importing pref.js directly in engine to prevent GTK3/GTK4 conflicts
content = content.replace("const prefwindow = imports.pref;", "const GLib = imports.gi.GLib;")
content = re.sub(
    r'function runPreferences\(\)\{\s*\n\s*prefwindow\.runpref\(\);\s*\n\s*\}',
    '''function runPreferences(){\n        let pkgdir = eevars.get_pkgdatadir();\n        try {\n            GLib.spawn_command_line_async('/usr/bin/env gjs --include-path=' + pkgdir + ' ' + pkgdir + '/pref.js --standalone');\n        } catch (e) {}\n    }''',
    content
)

# 3. Disable debug print spam
lines = content.split('\n')
fixed = []
for line in lines:
    s = line.strip()
    if (s.startswith('print(') or s.startswith('print (')) and 'Exiting' not in line and 'Created Engine' not in line:
        line = line.replace(s, '// ' + s)
    fixed.append(line)

with open(target, 'w', encoding='utf-8') as f:
    f.write('\n'.join(fixed))

print("[+] Patched main-gjs.js successfully.")
EOF

# Restart ibus and gjs to apply changes immediately
echo "[*] Restarting IBus daemon..."
killall -9 gjs ibus-daemon ibus-ui-gtk3 2>/dev/null || true
sleep 0.5
ibus-daemon -drx --panel=/usr/lib/ibus/ibus-ui-gtk3 --enable-wayland-im 2>/dev/null || true
sleep 0.5
ibus engine ibus-avro 2>/dev/null || true

echo "[+] Done! Avro Phonetic Wayland fixes applied."
