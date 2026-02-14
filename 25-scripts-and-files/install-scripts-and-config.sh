#!/bin/bash

# ============================================================
# Installerer scripts og hyprland.conf
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
DEST_SCRIPTS="$HOME/.local/share/bin"

# Sjekk at kildefilene eksisterer
if [ ! -f "$SOURCE_HYPRLAND" ]; then
    echo "❌ FEIL: Finner ikke hyprland.conf i $SCRIPT_DIR"
    exit 1
fi

if [ ! -d "$SOURCE_SCRIPTS" ]; then
    echo "❌ FEIL: Finner ikke scripts mappen i $SCRIPT_DIR"
    exit 1
fi

echo "✓ Funnet kildefiler:"
echo "  - $SOURCE_HYPRLAND"
echo "  - $SOURCE_SCRIPTS"
echo ""

# Opprett destinasjonsmapper hvis de ikke eksisterer
mkdir -p "$DEST_HYPR"
mkdir -p "$DEST_SCRIPTS"

echo "📁 Kopierer hyprland.conf til $DEST_HYPR"
cp -f "$SOURCE_HYPRLAND" "$DEST_HYPR/hyprland.conf"

if [ $? -eq 0 ]; then
    echo "✓ hyprland.conf kopiert"
else
    echo "❌ Feil ved kopiering av hyprland.conf"
    exit 1
fi

echo ""
echo "📁 Kopierer scripts til $DEST_SCRIPTS"
cp -rf "$SOURCE_SCRIPTS/"* "$DEST_SCRIPTS/"

if [ $? -eq 0 ]; then
    echo "✓ Scripts kopiert"
else
    echo "❌ Feil ved kopiering av scripts"
    exit 1
fi

# Gjør alle scripts kjørbare
echo ""
echo "🔧 Gjør scripts kjørbare..."
chmod +x "$DEST_SCRIPTS/"*

echo ""
echo "══════════════════════════════════════════════════════════════"
echo "✓ Installasjon fullført!"
echo "══════════════════════════════════════════════════════════════"
echo ""
echo "Filer installert:"
echo "  - $DEST_HYPR/hyprland.conf"
echo "  - Scripts i $DEST_SCRIPTS"
echo ""
