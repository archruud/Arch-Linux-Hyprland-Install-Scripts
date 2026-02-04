#!/bin/bash

# Hypridle Installation & Configuration Script v2 - FIXED
# Dette setter opp hypridle for Hyprland (uten duplikater!)

# Farger
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}=== Hypridle Setup (Fixed version) ===${NC}"

# Paths
HYPRIDLE_CONFIG="$HOME/.config/hypr/hypridle.conf"
HYPRLAND_CONFIG="$HOME/.config/hypr/hyprland.conf"

# Sjekk om yay/paru er installert
if ! command -v yay &> /dev/null && ! command -v paru &> /dev/null; then
    echo -e "${RED}Ingen AUR helper (yay/paru) funnet${NC}"
    echo -e "${YELLOW}Installer yay eller paru først${NC}"
    exit 1
fi

# Installer hypridle
if ! command -v hypridle &> /dev/null; then
    echo -e "${YELLOW}Installerer hypridle...${NC}"
    if command -v yay &> /dev/null; then
        yay -S --noconfirm hypridle
    else
        paru -S --noconfirm hypridle
    fi
fi

# Installer hyprlock (anbefalt)
if ! command -v hyprlock &> /dev/null; then
    echo -e "${YELLOW}Installerer hyprlock...${NC}"
    if command -v yay &> /dev/null; then
        yay -S --noconfirm hyprlock
    else
        paru -S --noconfirm hyprlock
    fi
fi

# Opprett config directory
mkdir -p "$HOME/.config/hypr"

# Opprett hypridle.conf
echo -e "${GREEN}Oppretter hypridle konfigurasjon...${NC}"
cat > "$HYPRIDLE_CONFIG" << 'EOF'
general {
    lock_cmd = pidof hyprlock || hyprlock       # Kjør hyprlock hvis ikke allerede kjører
    before_sleep_cmd = loginctl lock-session    # Lås før suspend
    after_sleep_cmd = hyprctl dispatch dpms on  # Skru på skjerm etter suspend
    ignore_dbus_inhibit = false                 # Ignorer om program blokkerer idle
}

# Listener for å dimme skjerm etter 5 minutter
listener {
    timeout = 300                               # 5 minutter
    on-timeout = brightnessctl -s set 10%       # Dimme til 10%
    on-resume = brightnessctl -r                # Gjenopprett lysstyrke
}

# Listener for å skru av skjerm etter 10 minutter
listener {
    timeout = 600                               # 10 minutter
    on-timeout = hyprctl dispatch dpms off      # Skru av skjerm
    on-resume = hyprctl dispatch dpms on        # Skru på skjerm
}

# Listener for å låse skjerm etter 15 minutter
listener {
    timeout = 900                               # 15 minutter
    on-timeout = loginctl lock-session          # Lås session
}

# Listener for suspend etter 30 minutter
listener {
    timeout = 1800                              # 30 minutter
    on-timeout = systemctl suspend              # Suspend system
}
EOF

echo -e "${GREEN}Hypridle konfigurasjon opprettet: $HYPRIDLE_CONFIG${NC}"

# Sjekk om hyprland.conf eksisterer
if [ ! -f "$HYPRLAND_CONFIG" ]; then
    echo -e "${RED}Feil: Kan ikke finne $HYPRLAND_CONFIG${NC}"
    exit 1
fi

# FIKSET: Fjern ALLE eksisterende hypridle linjer først
echo -e "${YELLOW}Rydder opp i hyprland.conf...${NC}"
sed -i '/exec-once.*hypridle/d' "$HYPRLAND_CONFIG"

# Legg til EN gang
echo -e "${GREEN}Legger til hypridle i hyprland.conf (kun EN gang)...${NC}"

# Finn AUTOSTART seksjonen og legg til der
if grep -q "### AUTOSTART ###" "$HYPRLAND_CONFIG"; then
    # Legg til etter AUTOSTART header
    sed -i '/### AUTOSTART ###/a exec-once = hypridle' "$HYPRLAND_CONFIG"
else
    # Legg til på toppen av filen (etter kommentarer)
    sed -i '/^[^#]/i exec-once = hypridle' "$HYPRLAND_CONFIG"
fi

echo -e "${GREEN}Hypridle aktivert i hyprland.conf (uten duplikater!)${NC}"

# Sjekk om hyprlock er installert
if ! command -v hyprlock &> /dev/null; then
    echo -e "${YELLOW}Hyprlock er ikke installert (anbefales for locking)${NC}"
    echo -e "${YELLOW}Installere hyprlock? (y/n)${NC}"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        if command -v yay &> /dev/null; then
            yay -S --noconfirm hyprlock
        elif command -v paru &> /dev/null; then
            paru -S --noconfirm hyprlock
        fi
    fi
fi

# Sjekk om brightnessctl er installert
if ! command -v brightnessctl &> /dev/null; then
    echo -e "${YELLOW}Brightnessctl er ikke installert (trengs for auto-dimming)${NC}"
    echo -e "${YELLOW}Installere brightnessctl? (y/n)${NC}"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        sudo pacman -S --noconfirm brightnessctl
    fi
fi

echo ""
echo -e "${GREEN}=== Hypridle setup fullført! ===${NC}"
echo ""
echo -e "${YELLOW}Timeouts:${NC}"
echo "  300s  (5 min)  - Dimme skjerm til 10%"
echo "  600s  (10 min) - Skru av skjerm"
echo "  900s  (15 min) - Lås skjerm"
echo "  1800s (30 min) - Suspend system"
echo ""
echo -e "${YELLOW}Kommandoer:${NC}"
echo "  Start nå: hypridle &"
echo "  Stop: pkill hypridle"
echo "  Rediger config: nano $HYPRIDLE_CONFIG"
echo ""
echo -e "${CYAN}Hypridle vil starte automatisk ved neste Hyprland oppstart!${NC}"
