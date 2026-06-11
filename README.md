# lagerpro
LagerPro – WooCommerce Lagerverwaltung
# LagerPro – WooCommerce Lagerverwaltung

Eine moderne Lagerverwaltungs-Web-App für WooCommerce Shops auf Basis Portainer App Mehrplatzfähig
Warenwirtschaft als Mastersystem für die Lagerhaltung und Bestandsüberwachung und Inventurauswertung in Echtzeit

## Funktionen
- ✅ Hauptartikel mit beliebig vielen Unterartikeln
- ✅ Zwei Lagerstätten: Hauptlager & Pickinglager
- ✅ Wareneingänge erfassen
- ✅ Umlagerung zwischen Lagern
- ✅ Nachbestellungen verwalten
- ✅ WooCommerce Bestand synchronisieren
- ✅ Berichte & CSV-Export
- ✅ Benutzerverwaltung (2–5 Benutzer)
- ✅ Retourenverwaltung mit Barcodescanner und/oder Kameraverwaltung
- ✅ Bundleartikel (beliebige Optionen)
- ✅ Bestellüberwachung Verkäufe/Bestände/Lieferzeit abgleich mit Meldesystem
- ✅ Automatisches Ordersystem via Mail
---

## Installation

### Voraussetzungen
- Docker & Docker Compose installiert
- Optional: Portainer

### 1. Dateien auf den Server kopieren

```bash
scp -r lager-app/ user@ihr-server:/opt/lagerpro
```
Oder per FTP/SFTP/Portainer File Manager.

### 2. JWT Secret ändern

In `docker-compose.yml` diesen Wert ändern:
```yaml
- JWT_SECRET=AENDERN_SIE_DIESEN_SCHLUESSEL_VOR_DEM_START
```
Ersetzen Sie es durch einen langen zufälligen String, z.B.:
```
JWT_SECRET=meinSicheresGeheimnis2024xyzABCDEF
```

### 3. Starten

```bash
cd /opt/lagerpro
docker compose up -d --build
```

### 4. Aufrufen

```
http://ihr-server-ip:3000
```

**Standard-Login:**
- Benutzername: `admin`
- Passwort: `admin123`

⚠️ **Passwort sofort nach dem ersten Login ändern!**

---

## Portainer Installation (Stack)

1. Portainer öffnen → Stacks → Add Stack
2. Name: `lagerpro`
3. Web Editor: Inhalt von `docker-compose.yml` einfügen
4. Deploy the stack

---

## WooCommerce API einrichten

1. WordPress Admin → WooCommerce → Einstellungen → Erweitert → REST API
2. "Schlüssel hinzufügen" klicken
3. Beschreibung: "LagerPro"
4. Benutzer: Admin-User wählen
5. Berechtigung: Lesen/Schreiben
6. "API-Schlüssel generieren"
7. Consumer Key & Secret in LagerPro unter Einstellungen eintragen

---

## Erweiterungen

Da der Code offen liegt, können Sie einfach erweitern:

- **Neue Seite:** JS-Datei in `frontend/js/pages/` anlegen + in `index.html` einbinden
- **Neue API:** Route in `backend/server.js` hinzufügen
- **Neue DB-Felder:** `CREATE TABLE` in der DB-Init anpassen

---

## Backup

Die Datenbank liegt im Docker-Volume `lagerpro_data`.
Backup-Befehl:
```bash
docker cp lagerpro:/data/lager.db ./backup_$(date +%Y%m%d).db
```

## Update

```bash
cd /opt/lagerpro
docker compose down
docker compose up -d --build
```
