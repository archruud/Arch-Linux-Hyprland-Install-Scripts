#!/bin/bash

# SWWW Installation & Configuration Script
# Dette setter opp swww (wayland wallpaper daemon) for Hyprland

# Farger
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${GREEN}=== SWWW Setup - Wayland Wallpaper Daemon ===${NC}"
echo ""

# Paths
WALLPAPER_DIR="$HOME/.config/hypr/wallpapers"
HYPRLAND_CONFIG="$HOME/.config/hypr/hyprland.conf"
SWWW_SCRIPT="$HOME/.config/hypr/swww-wallpaper.sh"

# Finn hvor dette scriptet ligger
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Sjekk om swww er installert
if ! command -v swww &> /dev/null; then
    echo -e "${YELLOW}SWWW er ikke installert. Installerer...${NC}"
    if command -v yay &> /dev/null; then
        yay -S --noconfirm swww
    elif command -v paru &> /dev/null; then
        paru -S --noconfirm swww
    else
        echo -e "${RED}Installer swww manuelt: yay -S swww${NC}"
        exit 1
    fi
fi

# Opprett directories
mkdir -p "$HOME/.config/hypr"
mkdir -p "$WALLPAPER_DIR"

# Velg wallpaper
echo -e "${CYAN}Hvilken oppløsning vil du bruke?${NC}"
echo "  1) 1920x1200 (anbefalt for laptop)"
echo "  2) 2560x1600 (for større skjermer)"
echo ""
read -p "Velg (1 eller 2): " resolution_choice

case $resolution_choice in
    1)
        WALLPAPER_FILE="ARCHRUUD_1920x1200.png"
        ;;
    2)
        WALLPAPER_FILE="ARCHRUUD_2560x1600.png"
        ;;
    *)
        echo -e "${YELLOW}Ugyldig valg. Bruker 1920x1200${NC}"
        WALLPAPER_FILE="ARCHRUUD_1920x1200.png"
        ;;
esac

# Kopier wallpaper hvis den finnes i script directory
if [ -f "$SCRIPT_DIR/wallpapers/$WALLPAPER_FILE" ]; then
    echo -e "${GREEN}Kopierer wallpaper fra pakken...${NC}"
    cp "$SCRIPT_DIR/wallpapers/$WALLPAPER_FILE" "$WALLPAPER_DIR/"
elif [ ! -f "$WALLPAPER_DIR/$WALLPAPER_FILE" ]; then
    echo -e "${YELLOW}Wallpaper finnes ikke i $WALLPAPER_DIR${NC}"
    echo -e "${YELLOW}Kopier $WALLPAPER_FILE til $WALLPAPER_DIR manuelt${NC}"
fi

# Lag swww startup script
echo -e "${GREEN}Lager swww startup script...${NC}"

cat > "$SWWW_SCRIPT" << EOF
#!/bin/bash

# SWWW Wallpaper Setter - Archruud
# Dette scriptet starter swww daemon og setter wallpaper

# Start swww daemon (hvis ikke allerede kjører)
if ! pgrep -x swww-daemon > /dev/null; then
    swww-daemon &
    sleep 1
fi

# Sett wallpaper med fade transition
swww img "$WALLPAPER_DIR/$WALLPAPER_FILE" \\
    --transition-type fade \\
    --transition-duration 2 \\
    --transition-fps 60

# Alternativt: random transition hver gang
# TRANSITIONS=("fade" "wipe" "grow" "wave")
# RANDOM_TRANSITION=\${TRANSITIONS[\$RANDOM % \${#TRANSITIONS[@]}]}
# swww img "$WALLPAPER_DIR/$WALLPAPER_FILE" --transition-type \$RANDOM_TRANSITION
EOF

chmod +x "$SWWW_SCRIPT"
echo -e "${GREEN}Startup script opprettet: $SWWW_SCRIPT${NC}"

# Sjekk om swww allerede er i hyprland.conf
if [ ! -f "$HYPRLAND_CONFIG" ]; then
    echo -e "${RED}Feil: Kan ikke finne $HYPRLAND_CONFIG${NC}"
    exit 1
fi

# Fjern eventuelle gamle swww/hyprpaper linjer først
echo -e "${CYAN}Rydder opp i hyprland.conf...${NC}"
sed -i '/exec-once.*swww/d' "$HYPRLAND_CONFIG"
sed -i '/exec-once.*hyprpaper/d' "$HYPRLAND_CONFIG"

# Legg til swww startup script i hyprland.conf
echo -e "${GREEN}Legger til swww i hyprland.conf...${NC}"

# Finn AUTOSTART seksjonen og legg til der
if grep -q "### AUTOSTART ###" "$HYPRLAND_CONFIG"; then
    # Legg til etter AUTOSTART header
    sed -i '/### AUTOSTART ###/a exec-once = ~/.config/hypr/swww-wallpaper.sh' "$HYPRLAND_CONFIG"
else
    # Legg til på toppen av filen (etter kommentarer)
    sed -i '/^[^#]/i exec-once = ~/.config/hypr/swww-wallpaper.sh' "$HYPRLAND_CONFIG"
fi

echo -e "${GREEN}SWWW aktivert i hyprland.conf${NC}"

# Test swww nå
echo ""
echo -e "${CYAN}Starter swww nå...${NC}"
bash "$SWWW_SCRIPT"

# Sjekk om swww kjører
sleep 2
if pgrep -x swww-daemon > /dev/null; then
    echo -e "${GREEN}✓ SWWW daemon kjører!${NC}"
    echo -e "${GREEN}✓ Wallpaper er satt!${NC}"
else
    echo -e "${RED}✗ SWWW startet ikke${NC}"
fi

echo ""
echo -e "${GREEN}=== Setup fullført! ===${NC}"
echo ""
echo -e "${YELLOW}Viktige filer:${NC}"
echo "  Startup script: $SWWW_SCRIPT"
echo "  Wallpaper: $WALLPAPER_DIR/$WALLPAPER_FILE"
echo ""
echo -e "${YELLOW}Kommandoer:${NC}"
echo "  Sett wallpaper: swww img /path/to/image.png"
echo "  Bytt med fade: swww img /path/to/image.png --transition-type fade"
echo "  Stop daemon: pkill swww-daemon"
echo "  Start daemon: swww-daemon &"
echo ""
echo -e "${YELLOW}Transitions du kan bruke:${NC}"
echo "  fade, wipe, grow, wave, outer, random"
echo ""
echo -e "${YELLOW}Eksempel kommando:${NC}"
echo "  swww img $WALLPAPER_DIR/$WALLPAPER_FILE --transition-type wave --transition-duration 3"
echo ""
echo -e "${CYAN}SWWW vil starte automatisk ved neste Hyprland oppstart!${NC}"
