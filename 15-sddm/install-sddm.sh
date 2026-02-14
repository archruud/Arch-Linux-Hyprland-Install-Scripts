#!/bin/bash

# ============================================================
# SDDM Display Manager Installasjon
# ============================================================

# Finn hvor dette scriptet ligger
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "══════════════════════════════════════════════════════════════"
echo " SDDM Display Manager Installasjon "
echo "══════════════════════════════════════════════════════════════"
echo ""
echo "Script kjøres fra: $SCRIPT_DIR"
echo ""

# Installer SDDM
echo "📦 Installerer SDDM..."
sudo pacman -S --needed --noconfirm sddm

# Sjekk om installasjonen var vellykket
if [ $? -ne 0 ]; then
    echo "❌ Feil ved installasjon av SDDM"
    exit 1
fi

# Aktiver SDDM service
echo ""
echo "🔧 Aktiverer SDDM service..."
sudo systemctl enable sddm.service

# Hvis det finnes config-filer i script-mappen, kopier dem
if [ -d "$SCRIPT_DIR/sddm.conf.d" ]; then
    echo ""
    echo "📁 Kopierer SDDM konfigurasjon..."
    sudo mkdir -p /etc/sddm.conf.d
    sudo cp -rf "$SCRIPT_DIR/sddm.conf.d/"* /etc/sddm.conf.d/
    echo "✓ Konfigurasjon kopiert"
fi

# Hvis det finnes tema-filer
if [ -d "$SCRIPT_DIR/themes" ]; then
    echo ""
    echo "🎨 Installerer SDDM tema..."
    sudo mkdir -p /usr/share/sddm/themes
    sudo cp -rf "$SCRIPT_DIR/themes/"* /usr/share/sddm/themes/
    echo "✓ Tema installert"
fi

echo ""
echo "══════════════════════════════════════════════════════════════"
echo "✓ SDDM installasjon fullført!"
echo "══════════════════════════════════════════════════════════════"
echo ""
echo "SDDM er nå aktivert og vil starte ved neste oppstart."
echo "For å starte SDDM nå: sudo systemctl start sddm"
echo ""
