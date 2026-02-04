# 📊 Waybar Installasjon - Archruud's Setup

**KOMPLETT automatisk installasjon med nmgui!**

## 🎯 Design Filosofi

Alle tre moduler har **samme design** - floating windows fra Waybar ikoner:

- **nmgui** for WiFi (ikke system tray)
- **blueman-manager** for Bluetooth (ikke system tray)
- **pavucontrol** for Audio (ikke system tray)

**Hvorfor ikke system tray?** PipeWire har ingen fungerende tray applet, så alle tre må være konsistente floating windows! 🎨

## 📦 Innhold

```
waybar-archruud/
├── install-waybar-final.sh    # Installasjonsskript (kjør dette!)
├── README-waybar.md           # Denne filen
└── waybar-clean/              # Waybar konfigurasjon
    ├── config
    ├── style.css
    ├── UserModules            # nmgui, blueman, pavucontrol config
    ├── Modules*
    └── wallust/
        └── colors-waybar.css
```

## 🚀 Installasjon (1 kommando!)

```bash
cd waybar-archruud
chmod +x install-waybar-final.sh
./install-waybar-final.sh
```

**Det er alt!** Scriptet gjør resten automatisk! ✅

## 📋 Hva Scriptet Gjør Automatisk

1. ✅ **Installerer pakker**:
   - waybar (official repos)
   - blueman (official repos)
   - pavucontrol (official repos)
   - nmgui-bin (fra AUR - pre-kompilert binær, fungerer perfekt!)

2. ✅ **Lager backup** av eksisterende ~/.config/waybar

3. ✅ **Kopierer waybar-clean** til ~/.config/waybar

4. ✅ **Legger til i hyprland.conf**:
   - `exec-once = waybar` (autostart)
   - `bind = $mainMod, R, exec, pkill -SIGUSR2 waybar...` (reload)
   - Window rules for nmgui, blueman, pavucontrol

5. ✅ **Starter waybar** automatisk!

## 🎨 Waybar Moduler (Samme Design!)

Alle tre moduler åpner som **floating windows** med samme design:

| Modul | Program | Window Class | Størrelse |
|-------|---------|--------------|-----------|
| 📶 WiFi | nmgui | com.network.manager | 450x600 |
| 🔵 Bluetooth | blueman-manager | blueman-manager | 600x700 |
| 🔊 Audio | pavucontrol | org.pulseaudio.pavucontrol | 800x900 |

## ⌨️ Waybar Interaksjon

- **WiFi ikon** → Klikk for å åpne nmgui
- **Bluetooth ikon** → Klikk for å åpne blueman-manager
- **Audio/Mikrofon ikon** → Klikk for å åpne pavucontrol
- **Super + R** → Reload waybar

## 📁 Din Konfigurasjon

**Layout:**
- **Venstre:** Menu, Workspaces, Window title
- **Senter:** Clock
- **Høyre:** WiFi (nmgui), Bluetooth, Audio, Microphone, Battery, Power

**Farger:**
- Archruud's custom blue theme (#2e92db)
- Wallust colors fra wallust/colors-waybar.css

## 🔧 Window Rules (Legges til automatisk)

```bash
# WiFi/Network Manager - nmgui
windowrule = float, ^(com.network.manager)$
windowrule = size 450 600, ^(com.network.manager)$
windowrule = center, ^(com.network.manager)$
windowrule = animation slide, ^(com.network.manager)$

# Bluetooth Manager
windowrule = float, ^(blueman-manager)$
windowrule = size 600 700, ^(blueman-manager)$
windowrule = center, ^(blueman-manager)$
windowrule = animation slide, ^(blueman-manager)$

# Audio Control
windowrule = float, ^(org.pulseaudio.pavucontrol)$
windowrule = size 800 900, ^(org.pulseaudio.pavucontrol)$
windowrule = center, ^(org.pulseaudio.pavucontrol)$
windowrule = animation slide, ^(org.pulseaudio.pavucontrol)$
```

## 🔄 Kontrollere Waybar

```bash
# Reload waybar (Super + R)
pkill -SIGUSR2 waybar

# Restart waybar
pkill waybar && waybar &

# Sjekk om waybar kjører
pgrep waybar
```

## ⚙️ UserModules Config

Din `UserModules` fil bruker:

```json
{
    "custom/wifiuser": {
        "format": "  ",
        "on-click": "nmgui",
        "tooltip": true,
        "tooltip-format": "Left Click: Wifi Menu"
    },
    
    "group/div#user": {
        "orientation": "inherit",
        "modules": [
            "custom/wifiuser",
            "bluetooth",
            "pulseaudio",
            "pulseaudio#microphone"
        ]
    }
}
```

## 🐛 Feilsøking

### nmgui-bin installeres ikke

```bash
# Installer manuelt
yay -S nmgui-bin --noconfirm

# Eller med paru
paru -S nmgui-bin --noconfirm

# nmgui-bin er en pre-kompilert binær - ingen problemer med Python!
```

### Waybar starter ikke

```bash
# Sjekk feilmeldinger
waybar

# Sjekk konfigurasjon
cat ~/.config/waybar/config
```

### Moduler fungerer ikke

```bash
# Sjekk at programmer er installert
which nmgui              # WiFi
which blueman-manager    # Bluetooth
which pavucontrol        # Audio

# Test manuelt
nmgui &
blueman-manager &
pavucontrol &
```

### Window rules fungerer ikke

```bash
# Restart Hyprland (logg ut/inn)

# Eller sjekk window class
hyprctl clients | grep -i "network.manager\|blueman\|pavucontrol"
```

## 💡 Hvorfor nmgui?

**nmgui** brukes i stedet for nm-connection-editor fordi:

1. ✅ **Konsistent design** med blueman og pavucontrol
2. ✅ **Floating window** (ikke system tray)
3. ✅ **Moderne GUI** med bedre UX
4. ✅ **Passer sammen** med PipeWire setup (som ikke har tray applet)

**Alle tre moduler** må åpnes på samme måte - som floating windows fra Waybar ikoner!

## 📝 Viktige Notater

- ✅ Scriptet kan kjøres flere ganger uten problemer
- ✅ Lager automatisk backup av eksisterende konfigurasjon
- ✅ nmgui installeres med --skipcheck (Python 3.14 workaround)
- ✅ Alle pakker installeres med --needed (unngår overskriving)
- ✅ Legger til konfigurasjon kun hvis den ikke allerede finnes
- ✅ Starter waybar automatisk etter installasjon
- ✅ Waybar starter automatisk ved neste Hyprland oppstart

## 🎨 Endre Konfigurasjon

### Endre Farger

```bash
# Rediger style.css
nano ~/.config/waybar/style.css

# Eller bruk wallust farger
nano ~/.config/waybar/wallust/colors-waybar.css
```

### Endre Moduler

```bash
# Rediger config
nano ~/.config/waybar/config

# Rediger UserModules (WiFi, Bluetooth, Audio)
nano ~/.config/waybar/UserModules
```

## 🔗 Avhengigheter

**Official Repos:**
- waybar
- blueman
- pavucontrol

**AUR:**
- nmgui-bin (pre-kompilert binær - installeres automatisk, ingen Python problemer!)

**AUR Helper Required:**
- yay eller paru (må være installert først)

## 📸 Resultat

Etter installasjon får du:
- 📊 Waybar kjører i toppen
- 📶 WiFi ikon (klikk → nmgui floating window)
- 🔵 Bluetooth ikon (klikk → blueman floating window)
- 🔊 Audio ikon (klikk → pavucontrol floating window)
- 🎨 Alle tre med samme design og animasjoner!

---

**Laget for Archruud's Hyprland setup** 🚀

**Ingen kompliserte steg - bare kjør scriptet!** ✨
