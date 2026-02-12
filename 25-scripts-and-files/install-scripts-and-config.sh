#!/bin/bash

# Farger for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Installerer scripts og hyprland.conf ===${NC}\n"

# Definerer kilde og destinasjon
SOURCE_DIR="25-scripts-and-files"
HYPR_CONFIG="$HOME/.config/hypr"
SCRIPTS_DEST="$HYPR_CONFIG/scripts"

# Sjekk om kilde-mappen eksisterer
if [ ! -d "$SOURCE_DIR" ]; then
    echo -e "${RED}Feil: Finner ikke mappen '$SOURCE_DIR'${NC}"
    echo "Kjør scriptet fra samme mappe som '25-scripts-and-files' ligger i"
    exit 1
fi

# Opprett scripts-mappe hvis den ikke eksisterer
echo -e "${BLUE}Oppretter/sjekker scripts-mappe...${NC}"
mkdir -p "$SCRIPTS_DEST"

# Kopier scripts-mappen
if [ -d "$SOURCE_DIR/scripts" ]; then
    echo -e "${GREEN}Kopierer scripts til $SCRIPTS_DEST${NC}"
    cp -rf "$SOURCE_DIR/scripts/"* "$SCRIPTS_DEST/"
    
    # Gjør alle scripts executable
    echo -e "${BLUE}Gjør alle scripts executable...${NC}"
    chmod +x "$SCRIPTS_DEST"/*.sh
    echo -e "${GREEN}Alle scripts er nå executable${NC}\n"
else
    echo -e "${RED}Advarsel: Finner ikke scripts-mappe i $SOURCE_DIR${NC}\n"
fi

# Kopier hyprland.conf
if [ -f "$SOURCE_DIR/hyprland.conf" ]; then
    echo -e "${GREEN}Kopierer hyprland.conf til $HYPR_CONFIG${NC}"
    cp -f "$SOURCE_DIR/hyprland.conf" "$HYPR_CONFIG/hyprland.conf"
    echo -e "${GREEN}hyprland.conf er oppdatert${NC}\n"
else
    echo -e "${RED}Advarsel: Finner ikke hyprland.conf i $SOURCE_DIR${NC}\n"
fi

# Vis oversikt over installerte filer
echo -e "${BLUE}=== Installasjon fullført ===${NC}\n"
echo -e "${GREEN}Scripts installert i:${NC} $SCRIPTS_DEST"
if [ -d "$SCRIPTS_DEST" ]; then
    ls -lh "$SCRIPTS_DEST"/*.sh 2>/dev/null
fi

echo -e "\n${GREEN}Konfigurasjon installert:${NC} $HYPR_CONFIG/hyprland.conf"

echo -e "\n${BLUE}Kjør 'hyprctl reload' eller restart Hyprland for å aktivere endringene${NC}"
