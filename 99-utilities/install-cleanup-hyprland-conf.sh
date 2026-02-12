#!/bin/bash

# Cleanup script for hyprland.conf
# Fjerner duplikater av exec-once linjer

HYPRLAND_CONFIG="$HOME/.config/hypr/hyprland.conf"

echo "=== Hyprland Config Cleanup ==="
echo ""

if [ ! -f "$HYPRLAND_CONFIG" ]; then
    echo "Feil: Kan ikke finne $HYPRLAND_CONFIG"
    exit 1
fi

# Backup først
cp "$HYPRLAND_CONFIG" "$HYPRLAND_CONFIG.backup"
echo "✓ Backup laget: $HYPRLAND_CONFIG.backup"

# Tell duplikater før
echo ""
echo "Duplikater FØR cleanup:"
echo "  hypridle: $(grep -c 'exec-once.*hypridle' "$HYPRLAND_CONFIG")"
echo "  hyprpaper: $(grep -c 'exec-once.*hyprpaper' "$HYPRLAND_CONFIG")"
echo "  swww: $(grep -c 'exec-once.*swww' "$HYPRLAND_CONFIG")"

# Fjern alle duplikater og behold kun én av hver
awk '!seen[$0]++' "$HYPRLAND_CONFIG" > "$HYPRLAND_CONFIG.tmp"
mv "$HYPRLAND_CONFIG.tmp" "$HYPRLAND_CONFIG"

echo ""
echo "✓ Duplikater fjernet!"
echo ""
echo "Duplikater ETTER cleanup:"
echo "  hypridle: $(grep -c 'exec-once.*hypridle' "$HYPRLAND_CONFIG")"
echo "  hyprpaper: $(grep -c 'exec-once.*hyprpaper' "$HYPRLAND_CONFIG")"
echo "  swww: $(grep -c 'exec-once.*swww' "$HYPRLAND_CONFIG")"

echo ""
echo "=== Cleanup fullført! ==="
echo "Hvis noe gikk galt, restore backup:"
echo "  cp $HYPRLAND_CONFIG.backup $HYPRLAND_CONFIG"
