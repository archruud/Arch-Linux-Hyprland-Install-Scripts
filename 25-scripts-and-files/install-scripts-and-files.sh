#!/bin/bash

# ============================================================
# Installerer scripts og hyprland.conf
# Kopierer BEGGE til ~/.config/hypr/
# ============================================================

# Finn hvor dette scriptet ligger
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "══════════════════════════════════════════════════════════════"
echo " Installerer scripts og hyprland.conf "
echo "══════════════════════════════════════════════════════════════"
echo ""
echo "Script kjøres fra: $SCRIPT_DIR"
echo ""

# Definer kilde og destinasjon
SOURCE_HYPRLAND="$SCRIPT_DIR/hyprland.conf"
SOURCE_SCRIPTS="$SCRIPT_DIR/scripts"
DEST_HYPR="$HOME/.config/hypr"

# Sjekk at kildefilene eksisterer
echo "✓ Funnet kildefiler:"
if [ -f "$SOURCE_HYPRLAND" ]; then
    echo "  - $SOURCE_HYPRLAND"
else
    echo "  ✗ Finner ikke hyprland.conf"
fi

if [ -d "$SOURCE_SCRIPTS" ]; then
    echo "  - $SOURCE_SCRIPTS"
else
    echo "  ✗ Finner ikke scripts mappen"
fi

echo ""

# Opprett ~/.config/hypr hvis den ikke eksisterer
mkdir -p "$DEST_HYPR"
mkdir -p "$DEST_HYPR/scripts"

# Kopier hyprland.conf til ~/.config/hypr/
if [ -f "$SOURCE_HYPRLAND" ]; then
    echo "📁 Kopierer hyprland.conf til $DEST_HYPR"
    cp -f "$SOURCE_HYPRLAND" "$DEST_HYPR/hyprland.conf"
    
    if [ $? -eq 0 ]; then
        echo "✓ hyprland.conf kopiert"
    else
        echo "✗ Feil ved kopiering av hyprland.conf"
    fi
fi

echo ""

# Kopier scripts til ~/.config/hypr/scripts/
if [ -d "$SOURCE_SCRIPTS" ]; then
    echo "📁 Kopierer scripts til $DEST_HYPR/scripts"
    cp -rf "$SOURCE_SCRIPTS/"* "$DEST_HYPR/scripts/"
    
    if [ $? -eq 0 ]; then
        echo "✓ Scripts kopiert"
    else
        echo "✗ Feil ved kopiering av scripts"
    fi
fi

echo ""

# Gjør alle scripts kjørbare
echo "🔧 Gjør scripts kjørbare..."
chmod +x "$DEST_HYPR/scripts/"* 2>/dev/null

echo ""
echo "══════════════════════════════════════════════════════════════"
echo "✓ Installasjon fullført!"
echo "══════════════════════════════════════════════════════════════"
echo ""
echo "Filer installert:"
echo "  - $DEST_HYPR/hyprland.conf"
echo "  - Scripts i $DEST_HYPR/scripts/"
echo ""
echo "Scripts er nå kjørbare og klare til bruk!"
echo ""
