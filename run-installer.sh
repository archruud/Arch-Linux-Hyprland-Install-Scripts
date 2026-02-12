#!/bin/bash

# ===========================================
# Hyprland Master Installer
# Installer moduler basert på install-order.conf
# ===========================================

set -e

# Farger for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Base directory (endre dette hvis nødvendig)
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="$BASE_DIR/install-order.conf"

# Teller
INSTALLED=0
SKIPPED=0
FAILED=0

# Arrays for logging
declare -a INSTALLED_MODULES
declare -a SKIPPED_MODULES
declare -a FAILED_MODULES

# Funksjon for å printe med farger
print_header() {
    echo -e "\n${BLUE}═══════════════════════════════════════════${NC}"
    echo -e "${BLUE}  $1${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════${NC}\n"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${YELLOW}ℹ${NC} $1"
}

print_skip() {
    echo -e "${YELLOW}⊗${NC} $1"
}

# Sjekk om config fil eksisterer
if [ ! -f "$CONFIG_FILE" ]; then
    print_error "Konfigurasjonsfil ikke funnet: $CONFIG_FILE"
    exit 1
fi

print_header "Hyprland Modul Installer"
echo "Base directory: $BASE_DIR"
echo "Config file: $CONFIG_FILE"
echo ""

# Les konfigurasjonsfil
while IFS= read -r line || [ -n "$line" ]; do
    # Hopp over tomme linjer og kommentarer
    if [[ -z "$line" ]] || [[ "$line" =~ ^[[:space:]]*# ]]; then
        continue
    fi
    
    # Fjern leading/trailing whitespace
    module=$(echo "$line" | xargs)
    
    # Sjekk om modul er utkommentert (for sikkerhetsskyld)
    if [[ "$module" =~ ^# ]]; then
        continue
    fi
    
    module_path="$BASE_DIR/$module"
    
    # Sjekk om mappe eksisterer
    if [ ! -d "$module_path" ]; then
        print_error "Mappe ikke funnet: $module"
        FAILED=$((FAILED + 1))
        FAILED_MODULES+=("$module (mappe ikke funnet)")
        continue
    fi
    
    # Finn install script
    install_script=$(find "$module_path" -maxdepth 1 -name "install-*.sh" -type f | head -n 1)
    
    if [ -z "$install_script" ]; then
        print_skip "Ingen install-*.sh funnet i: $module"
        SKIPPED=$((SKIPPED + 1))
        SKIPPED_MODULES+=("$module (ingen install script)")
        continue
    fi
    
    script_name=$(basename "$install_script")
    
    print_header "Installerer: $module"
    print_info "Script: $script_name"
    
    # Gjør script kjørbart
    chmod +x "$install_script"
    
    # Kjør install script
    if (cd "$module_path" && ./"$script_name"); then
        print_success "✓ $module installert!"
        INSTALLED=$((INSTALLED + 1))
        INSTALLED_MODULES+=("$module")
    else
        print_error "✗ Feil ved installasjon av $module"
        FAILED=$((FAILED + 1))
        FAILED_MODULES+=("$module (installasjon feilet)")
    fi
    
    echo ""
    
done < "$CONFIG_FILE"

# Print sammendrag
print_header "Installasjonssammendrag"

echo -e "${GREEN}Installert: $INSTALLED${NC}"
if [ ${#INSTALLED_MODULES[@]} -gt 0 ]; then
    for module in "${INSTALLED_MODULES[@]}"; do
        echo -e "  ${GREEN}✓${NC} $module"
    done
fi
echo ""

if [ $SKIPPED -gt 0 ]; then
    echo -e "${YELLOW}Hoppet over: $SKIPPED${NC}"
    for module in "${SKIPPED_MODULES[@]}"; do
        echo -e "  ${YELLOW}⊗${NC} $module"
    done
    echo ""
fi

if [ $FAILED -gt 0 ]; then
    echo -e "${RED}Feilet: $FAILED${NC}"
    for module in "${FAILED_MODULES[@]}"; do
        echo -e "  ${RED}✗${NC} $module"
    done
    echo ""
fi

print_header "Ferdig!"

if [ $FAILED -gt 0 ]; then
    exit 1
else
    exit 0
fi
