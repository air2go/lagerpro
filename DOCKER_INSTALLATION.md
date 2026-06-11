# 🐳 LagerPro Docker Installation

Installiere LagerPro ganz einfach mit Docker!

---

## 📋 Voraussetzungen

- ✅ Docker installiert ([Download](https://www.docker.com/products/docker-desktop))
- ✅ Docker Compose (meist mit Docker enthalten)
- ✅ Optional: Portainer (für GUI)

---

## 🚀 Option 1: Schnelle Installation (Empfohlen)

### 1. docker-compose.yml erstellen

Erstelle eine neue Datei `docker-compose.yml`:

```yaml
version: '3.8'

services:
  lagerpro:
    image: air2go/lagerpro:latest
    container_name: lagerpro
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
      - JWT_SECRET=AENDERN_SIE_DIESEN_SCHLUESSEL_VOR_DEM_START
    volumes:
      - lagerpro_data:/app/data
      - lagerpro_db:/app/backend/data
    restart: unless-stopped

volumes:
  lagerpro_data:
    driver: local
  lagerpro_db:
    driver: local
```

### 2. JWT Secret ändern ⚠️ **WICHTIG**

Ersetze `AENDERN_SIE_DIESEN_SCHLUESSEL_VOR_DEM_START` durch einen sicheren zufälligen String:

**Linux/Mac:**
```bash
openssl rand -base64 32
```

**Windows PowerShell:**
```powershell
[Convert]::ToBase64String([System.Security.Cryptography.RNGCryptoServiceProvider]::new().GetBytes(32))
```

Beispiel:
```yaml
- JWT_SECRET=FxK9mP2qR7sT3uV6wX1yZ4aB8cD5eF0gH
```

### 3. Container starten

```bash
docker compose up -d
```

### 4. Zugriff

Öffne deinen Browser:
```
http://localhost:3000
```

**Standard-Login:**
- Benutzername: `admin`
- Passwort: `admin123`

⚠️ **Passwort sofort nach dem ersten Login ändern!**

---

## 🔧 Option 2: Portainer GUI Installation

### 1. Portainer öffnen

```
http://dein-nas:9000
```

### 2. Stack erstellen

- Stacks → Add Stack
- Name: `lagerpro`
- Web Editor auswählen
- docker-compose.yml Inhalt kopieren
- Deploy

---

## 📦 Option 3: Manuell mit Image pullen

```bash
# Image herunterladen
docker pull air2go/lagerpro:latest

# Container starten
docker run -d \
  --name lagerpro \
  -p 3000:3000 \
  -e JWT_SECRET=DeinSicheresGeheimnis \
  -v lagerpro_data:/app/data \
  -v lagerpro_db:/app/backend/data \
  --restart unless-stopped \
  air2go/lagerpro:latest
```

---

## 🔗 WooCommerce API einrichten

1. WordPress Admin → WooCommerce → Einstellungen → Erweitert → REST API
2. "Schlüssel hinzufügen" klicken
3. Beschreibung: "LagerPro"
4. Benutzer: Admin-User wählen
5. Berechtigung: Lesen/Schreiben
6. "API-Schlüssel generieren"
7. Consumer Key & Secret in LagerPro eintragen (Einstellungen → WooCommerce)

---

## 📂 Datensicherung

### Backup erstellen

```bash
docker cp lagerpro:/app/backend/data/lager.db ./backup_$(date +%Y%m%d_%H%M%S).db
```

### Volume Backup

```bash
docker run --rm \
  -v lagerpro_db:/app/backend/data \
  -v $(pwd):/backup \
  alpine tar czf /backup/lagerpro_backup.tar.gz -C /app/backend data
```

### Automatisches tägliches Backup (Linux/Mac)

Füge ins Crontab ein:
```bash
crontab -e
```

Dann hinzufügen:
```
0 2 * * * docker cp lagerpro:/app/backend/data/lager.db /backups/lagerpro_$(date +\%Y\%m\%d).db
```

---

## 🔄 Update durchführen

```bash
# Newest Image herunterladen
docker pull air2go/lagerpro:latest

# Container stoppen
docker stop lagerpro

# Container entfernen
docker rm lagerpro

# Neu starten (mit docker-compose)
docker compose up -d
```

**Mit docker-compose einfacher:**
```bash
docker compose down
docker compose up -d --pull always
```

---

## 🐛 Fehlerbehebung

### Container startet nicht

```bash
# Logs anschauen
docker logs lagerpro

# Container prüfen
docker ps -a | grep lagerpro
```

### Port 3000 wird bereits verwendet

```bash
# Anderen Port nutzen in docker-compose.yml
ports:
  - "8080:3000"  # Dann auf http://localhost:8080 zugreifen
```

### Datenbank-Fehler

```bash
# Volume neu erstellen
docker volume rm lagerpro_db
docker compose down
docker compose up -d
```

---

## 📊 Umgebungsvariablen

Optional kannst du diese in `docker-compose.yml` setzen:

```yaml
environment:
  - NODE_ENV=production
  - JWT_SECRET=dein_geheimnis
  - LOG_LEVEL=info
  - PORT=3000
```

---

## 🎯 Tipps & Tricks

### Resource Limits setzen

```yaml
services:
  lagerpro:
    # ... andere config ...
    deploy:
      resources:
        limits:
          cpus: '2'
          memory: 1G
        reservations:
          cpus: '1'
          memory: 512M
```

### Automatischer Restart

```yaml
restart: unless-stopped  # Startet automatisch neu (außer wenn manuell gestoppt)
```

### Logs live anschauen

```bash
docker logs -f lagerpro
```

---

## ❓ Support & weitere Hilfe

- [Docker Documentation](https://docs.docker.com)
- [Docker Compose Reference](https://docs.docker.com/compose/compose-file/)
- GitHub Issues: [air2go/lagerpro](https://github.com/air2go/lagerpro/issues)

---

**Viel Erfolg mit LagerPro! 🚀**
