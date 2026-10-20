## 1. Was sind Datenanomalien?
---

Datenanomalien sind Fehler, die beim Speichern, Ändern oder Löschen von Daten in einer Datenbank entstehen können. Sie treten auf, wenn Daten mehrfach gespeichert werden oder eine Datenbank nicht sinnvoll strukturiert ist.

## 2. Arten von Datenanomalien
---
### 2.1 Einfügeanomalie 
Daten können nicht **ohne Probleme** hinzugefügt werden.
ZB. Ein Projekt kann nicht in einer Tabelle stehen ohne ein Mitarbeiter.

### 2.2 Änderungsanomalie
Wenn dieselben Daten an mehreren Stellen gespeichert sind, müssen sie bei einer Änderung überall angepasst werden. Andernfalls können unterschiedliche Daten entstehen.

### 2.3 Löschanomalie
Daten können nicht **ohne Probleme** gelöscht werden. Wenn Daten abhängig von einander sind dann werden wichtige Informationen gelöscht.

## 3. Erkennung von Datenanomalien
---
**Datenprüfung:** Überprüfen, ob die Daten richtig gespeichert worden

**Duplikate:** Überprüfen, ob es gleiche Daten gibt

**Regeln:** Überprüfen, ob alle Datein Bedingungen haben.
