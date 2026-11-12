# Lerntagebuch: Alpine Linux Server & PostgreSQL für DBeaver einrichten

## 1. Zielsetzung
Einrichtung eines ressourcensparenden Linux-Servers auf Basis von Alpine Linux (in einer virtuellen Maschine), Installation einer PostgreSQL-Datenbank sowie Freigabe des Fernzugriffs, um die Datenbank von außen über DBeaver verwalten zu können.

---

## 2. Durchgeführte Schritte & Gelerntes

### A. Installation & Betriebsmodi von Alpine Linux
* Installationsmodus `sys`: Damit Änderungen, Pakete und Datenbankinhalte nach einem Neustart (`reboot`) nicht verloren gehen (wie im reinen RAM-/Diskless-Modus), muss Alpine über `setup-alpine` im `sys`-Modus fest auf die virtuelle Festplatte geschrieben werden.

* Paketquellen (`repositories`): Um zusätzliche Software wie PostgreSQL installieren zu können, müssen die Online-Paketquellen (`main` und `community`) in `/etc/apk/repositories` aktiviert sein.

### B. Netzwerkkonfiguration & Internetverbindung prüfen
* Schnittstellen & IP prüfen: Mit `ip a` lässt sich prüfen, ob die Netzwerkkarte (`eth0`) aktiv ist (`state UP`) und eine IP-Adresse über DHCP erhalten hat.
* Verbindung testen: Mit `ping -c 4 8.8.8.8` wird die grundlegende Internetverbindung getestet und mit `ping -c 4 google.com` die DNS-Namensauflösung überprüft.
* Dauerhafte Einrichtung: Über `setup-interfaces` (Auswahl `dhcp` für IPv4) sowie `rc-service networking start` und `rc-update add networking boot` startet das Netzwerk bei jedem Bootvorgang automatisch.

### C. PostgreSQL installieren & für Fernzugriff konfigurieren
* Installation & Autostart:
  ```sh
  apk update && apk add postgresql postgresql-contrib
  rc-update add postgresql default
  service postgresql start
  ```
* Datenbank-Passwort setzen: Über `psql -U postgres` öffnet man die Datenbank-Konsole und legt mit `\password postgres` ein Passwort für den Standard-Admin fest.
* Netzwerkzugriff freischalten: Standardmäßig lauscht PostgreSQL nur lokal (`127.0.0.1:5432`). Für DBeaver mussten zwei Konfigurationsdateien unter `/etc/postgresql/` angepasst werden:
  1. In `postgresql.conf`: `listen_addresses = '*'` setzen, damit Anfragen von allen IP-Adressen angenommen werden.
  2. In `pg_hba.conf`: `host all all 0.0.0.0/0 scram-sha-256` ergänzen, um Passwort-Logins aus dem Netzwerk zu erlauben.
  3. Dienst mit `rc-service postgresql restart` neu starten.

### D. Troubleshooting & Verbindung mit DBeaver
* Offene Ports kontrollieren: Da `ss` unter Alpine standardmäßig nicht installiert ist, lässt sich mit `netstat -tulpn | grep 5432` prüfen, ob PostgreSQL erfolgreich auf `0.0.0.0:5432` (`LISTEN`) wartet.
* DBeaver-Verbindung: Mit der ausgelesenen Server-IP (`172.20.75.188`), Port `5432`, der Datenbank `postgres` und dem Benutzer `postgres` konnte die Verbindung erfolgreich hergestellt werden.

---

## 3. Wichtige Befehle (Spickzettel)

| Befehl | Funktion |
| :--- | :--- |
| `setup-alpine` | Startet den Einrichtungsassistenten für Alpine Linux (Netzwerk, Tastatur, Festplatte) |
| `ip -4 a` | Zeigt die aktuelle IPv4-Adresse des Servers an |
| `ping -c 4 8.8.8.8` | Prüft die Internetverbindung |
| `psql -U postgres` | Öffnet die PostgreSQL-Konsole als Admin |
| `rc-service postgresql restart` | Startet den Datenbankdienst neu |
| `netstat -tulpn \| grep 5432` | Prüft, auf welcher IP-Adresse Port 5432 lauscht |
