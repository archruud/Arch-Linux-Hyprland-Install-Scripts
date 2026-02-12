# Hyprland Modul Installer System

## Oversikt
Dette systemet lar deg enkelt styre hvilke moduler som skal installeres og i hvilken rekkefølge.

## Filer
- **install-order.conf** - Konfigurasjonsfil som definerer installasjonsrekkefølge
- **run-installer.sh** - Hovedscript som kjører installasjonene

## Hvordan bruke

### 1. Rediger install-order.conf
Åpne `install-order.conf` i en teksteditor:
```bash
nano install-order.conf
```

### 2. Styr installasjoner
```bash
# Denne installeres
01-base

# Kommenter ut for å hoppe over
# 05-hyprlock

# Du kan også legge til kommentarer
07-power-button  # Dette installeres
```

### 3. Kjør installasjonen
```bash
chmod +x run-installer.sh
./run-installer.sh
```

## Eksempler

### Bytte rekkefølge
Hvis du vil installere power-button før hyprlock:
```bash
# Gammelt
05-hyprlock
07-power-button

# Nytt
05-power-button
07-hyprlock
```

### Hopp over moduler
For å hoppe over en modul, legg til # foran:
```bash
# 05-hyprlock  # Denne hoppes over
06-wlogout
07-power-button
```

### Installer bare noen få moduler
Kommenter ut alt unntatt det du vil installere:
```bash
# 01-base
# 02-post-install
03-swww
# 04-hyprdle
05-hyprlock
# ... resten
```

## Krav
- Hver mappe må inneholde et script som starter med `install-*.sh`
- Script må være kjørbart (chmod +x)
- Mappene må være i samme directory som run-installer.sh

## Tips
1. Test én modul om gangen først
2. Bruk # for å dokumentere hvorfor du hopper over noe
3. Ta backup av install-order.conf hvis du gjør store endringer

## Feilsøking

### "Mappe ikke funnet"
- Sjekk at mappenavnet i install-order.conf matcher faktisk mappenavn
- Mappenavn er case-sensitive

### "Ingen install-*.sh funnet"
- Sjekk at mappen har et install script
- Navnet må starte med "install-" og slutte med ".sh"

### Installasjon feiler
- Kjør modulen manuelt for å se feilmelding:
  ```bash
  cd 05-hyprlock
  ./install-hyprlock.sh
  ```

## Struktur
```
Arch-Linux-Hyprland-Install-Scripts/
├── install-order.conf       # Din konfigurasjon
├── run-installer.sh         # Hovedscript
├── 01-base/
│   └── install-packages.sh
├── 02-post-install/
│   └── install-post.sh
├── 05-hyprlock/
│   └── install-hyprlock.sh
└── ...
```
