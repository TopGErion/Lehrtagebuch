# SQL mit Postgres – Gültigkeitsregeln (Constraints)

*Antworten einfach und verständlich erklärt*

---

## Teil 1: Gültigkeitsregeln und Constraints

### 1. Was ist ein Constraint und warum reicht Prüfung nur in der Anwendung nicht?

Ein **Constraint** ist eine Regel, die die Datenbank selbst überwacht. Sie legt fest, welche Daten erlaubt sind (z. B. „Preis muss größer als 0 sein“). Passt ein Wert nicht, lehnt die Datenbank ihn ab.

**Warum riskant, nur in der Anwendung zu prüfen?**
- Oft greifen **mehrere Programme** auf dieselbe Datenbank zu (Website, App, Admin-Tool, Import-Skripte). Vergisst eines davon die Prüfung, landen falsche Daten in der Datenbank.
- Jemand kann direkt per SQL Daten ändern und die Anwendung komplett umgehen.
- Programmierfehler passieren.

👉 Die Datenbank ist die **letzte Verteidigungslinie** – sie schützt die Daten immer, egal woher sie kommen.

---

### 2. Wozu dient ein Primary Key und welche zwei Eigenschaften muss er haben?

Der **Primärschlüssel** identifiziert jede Zeile **eindeutig** – wie eine Ausweisnummer für jeden Datensatz.

Die zwei Pflicht-Eigenschaften:
1. **Eindeutig (UNIQUE):** Kein Wert darf doppelt vorkommen.
2. **Nicht leer (NOT NULL):** Jede Zeile muss einen Wert haben.

---

### 3. Unterschied zwischen Primary Key und Unique Constraint?

| | Primary Key | Unique Constraint |
|---|---|---|
| Wert muss eindeutig sein | ✅ | ✅ |
| NULL erlaubt? | ❌ Nein | ✅ Ja |
| Wie viele pro Tabelle? | Nur **einer** | **Beliebig viele** |
| Bedeutung | *Die* Identität der Zeile | „Dieser Wert darf nicht doppelt vorkommen“ |

**Beispiel:** `id` ist der Primary Key, `e_mail` ist UNIQUE (darf nicht doppelt sein, ist aber nicht *die* Identität des Kunden).

---

### 4. Was bewirkt NOT NULL?

`NOT NULL` bedeutet: **Diese Spalte darf nicht leer sein.** Wer versucht, keinen Wert einzutragen, bekommt einen Fehler.

**Ohne NOT NULL:** Lässt man beim Einfügen einen Wert weg, speichert die Datenbank einfach `NULL` (= „unbekannt / nichts“) – ohne Fehlermeldung. So können unvollständige Datensätze entstehen (z. B. ein Produkt ohne Namen).

---

### 5. Wie funktionieren CHECK-Constraints?

Ein **CHECK** prüft bei jedem Einfügen und Ändern eine Bedingung. Ist sie **falsch**, wird die Änderung abgelehnt.

```sql
preis NUMERIC(10,2) CHECK (preis > 0)
```

Typische Einsätze:
- **Zahlen:** Preis > 0, Alter >= 18, Rabatt zwischen 0 und 100
- **Texte:** nur bestimmte Werte erlaubt (`status IN ('neu', 'bezahlt')`), Mindestlänge (`length(plz) = 4`)
- **Datum:** `ende_datum > start_datum`

> Hinweis: Ergibt die Bedingung `NULL` (z. B. weil `preis` leer ist), gilt der CHECK als **bestanden**. Wer das verhindern will, braucht zusätzlich `NOT NULL`.

---

### 6. Wozu dienen Foreign Keys und was ist referentielle Integrität?

Ein **Fremdschlüssel** verbindet zwei Tabellen: Eine Spalte in Tabelle A verweist auf den Primärschlüssel in Tabelle B.

**Referentielle Integrität** heißt: **Jeder Verweis zeigt auf etwas, das wirklich existiert.**

Beispiel: Eine Bestellung mit `kunde_id = 99` darf es nur geben, wenn es auch einen Kunden mit `id = 99` gibt. Die Datenbank verhindert:
- Einfügen von Verweisen ins Leere
- Löschen von Datensätzen, auf die noch verwiesen wird (je nach Einstellung)

---

### 7. Was passiert bei ON DELETE RESTRICT / NO ACTION?

Will man eine Zeile in der **Elterntabelle** (z. B. einen Kunden) löschen, auf die noch Zeilen in der **Kindtabelle** (z. B. Bestellungen) verweisen, **verweigert die Datenbank das Löschen** und gibt einen Fehler aus.

Man muss zuerst die abhängigen Daten löschen oder ändern.

*(Kleiner Unterschied: RESTRICT prüft sofort, NO ACTION erst am Ende des Befehls bzw. kann aufgeschoben werden. Im Ergebnis meist gleich.)*

---

### 8. ON DELETE CASCADE vs. ON DELETE SET NULL

| Option | Was passiert beim Löschen des Elternteils? | Sinnvoll wenn… |
|---|---|---|
| **CASCADE** | Alle abhängigen Zeilen werden **mitgelöscht** | Die Kinddaten ohne Elternteil sinnlos sind. Beispiel: Bestellung gelöscht → Bestellpositionen auch löschen |
| **SET NULL** | Der Verweis wird auf **NULL** gesetzt, die Zeile bleibt | Die Kinddaten auch allein Sinn ergeben. Beispiel: Mitarbeiter verlässt Firma → Projekte bleiben, Feld „verantwortlich“ wird leer |

⚠️ CASCADE ist mächtig, aber gefährlich: Ein Löschbefehl kann viele Daten in anderen Tabellen mitreißen.

---

### 9. Warum Constraints selbst benennen?

```sql
CONSTRAINT chk_alter CHECK (alter >= 18)
```

- **Verständliche Fehlermeldungen:** Statt `benutzer_alter_check1` steht da `chk_alter` – man weiß sofort, welche Regel verletzt wurde.
- **Leichter zu ändern/löschen:** `ALTER TABLE ... DROP CONSTRAINT chk_alter` – man muss den Namen nicht erst suchen.
- **Gleiche Namen auf allen Systemen** (Entwicklung, Test, Produktion) → Migrationsskripte funktionieren überall.

---

### 10. Zeitpunkt der Auswertung / DEFERRABLE INITIALLY DEFERRED

Normalerweise prüft die Datenbank einen Constraint **sofort** nach jedem Befehl (*IMMEDIATE*).

**DEFERRABLE INITIALLY DEFERRED** heißt: Die Prüfung wird **bis zum Ende der Transaktion (COMMIT) aufgeschoben**.

**Wozu?** Manchmal ist ein Zustand nur *zwischendurch* ungültig. Beispiel: Zwei Tabellen verweisen gegenseitig aufeinander – egal welche man zuerst befüllt, der Verweis zeigt kurz ins Leere. Mit aufgeschobener Prüfung ist das okay, solange beim COMMIT alles stimmt.

> In PostgreSQL geht das nur für UNIQUE, PRIMARY KEY, FOREIGN KEY und EXCLUDE – **nicht** für CHECK und NOT NULL.

---

### 11. Probleme beim nachträglichen Hinzufügen eines Constraints mit ALTER TABLE

Wenn bereits **ungültige Altdaten** in der Tabelle sind:
- PostgreSQL prüft beim Hinzufügen **alle vorhandenen Zeilen**. Gibt es nur eine ungültige, **schlägt der ganze Befehl fehl**.
- Man muss die Altdaten zuerst **bereinigen** (korrigieren oder löschen) – dabei stellt sich die Frage: *Was ist der richtige Wert?* Löschen kann wichtige Informationen vernichten.
- Bei großen Tabellen dauert die Prüfung lange und **sperrt die Tabelle**.

Ausweg: `NOT VALID` – der Constraint gilt dann nur für **neue** Daten; später kann man mit `VALIDATE CONSTRAINT` die Altdaten prüfen.

```sql
ALTER TABLE produkte ADD CONSTRAINT chk_preis CHECK (preis > 0) NOT VALID;
-- Altdaten bereinigen ...
ALTER TABLE produkte VALIDATE CONSTRAINT chk_preis;
```

---

### 12. NULL-Werte bei UNIQUE in PostgreSQL

**Ja, NULL darf mehrfach vorkommen.** Grund: NULL bedeutet „unbekannt“, und zwei unbekannte Werte gelten nicht als gleich.

Möchte man nur **ein einziges** NULL erlauben, gibt es ab PostgreSQL 15:

```sql
UNIQUE NULLS NOT DISTINCT (spalte)
```

---

### 13. Kann ein CHECK eine andere Tabelle abfragen?

**Nein.** Ein CHECK darf nur Werte **der aktuellen Zeile** prüfen – keine Unterabfragen auf andere Tabellen.

**Lösungen stattdessen:**
- **Foreign Key** – für „existiert dieser Wert in der anderen Tabelle?“ (die häufigste und beste Lösung)
- **Trigger** – für kompliziertere Regeln über mehrere Tabellen

---

### 14. Surrogate Key vs. Natural Key

| | Surrogate Key (künstlich) | Natural Key (fachlich) |
|---|---|---|
| Beispiel | `id SERIAL`, UUID | E-Mail, Steuer-ID, ISBN |
| Bedeutung außerhalb der DB | keine | ja, kommt aus der realen Welt |
| Ändert sich? | nie | kann sich ändern (neue E-Mail!) |
| Größe/Tempo | klein, schnell | oft lange Texte, langsamer |

**Faustregel:** Surrogate Key als Primärschlüssel nehmen, den Natural Key zusätzlich mit `UNIQUE` absichern.

---

### 15. Performance-Auswirkungen von PRIMARY KEY / UNIQUE

Für PRIMARY KEY und UNIQUE legt die Datenbank automatisch einen **Index** an. Bei jedem INSERT/UPDATE muss sie:
1. im Index nachsehen, ob der Wert schon existiert, und
2. den Index aktualisieren.

👉 Schreiben wird **etwas langsamer**.

**Warum trotzdem gewollt?**
- Korrekte Daten sind viel wichtiger als ein paar Millisekunden.
- Der Index macht dafür das **Suchen und Lesen** viel schneller – und meistens wird viel öfter gelesen als geschrieben.

---

### 16. Was passiert in einer Transaktion bei einer Constraint-Verletzung?

Eine Transaktion ist **„alles oder nichts“** (Atomarität).

Wird auch nur **ein** Constraint verletzt, ist die ganze Transaktion fehlerhaft. **Keine** Änderung wird gespeichert – auch nicht die fehlerfreien. Es bleibt nur ein `ROLLBACK`.

*(Ausnahme: Man hat vorher bewusst `SAVEPOINT`s gesetzt und rollt nur bis zu diesem zurück.)*

---

### 17. Constraint deaktivieren oder löschen

**Löschen:**
```sql
ALTER TABLE benutzer DROP CONSTRAINT chk_alter;
```

**Temporär „deaktivieren“:** PostgreSQL hat kein einfaches „Ausschalten“ für CHECK/UNIQUE. Möglichkeiten:
- Constraint löschen und später neu anlegen (evtl. mit `NOT VALID`).
- Foreign Keys mit `DEFERRABLE` bis zum Transaktionsende aufschieben.
- Für Massenimporte (Achtung, nur für Profis!): `SET session_replication_role = replica;` – damit werden Trigger und damit auch Foreign-Key-Prüfungen übersprungen.

---

### 18. Exclusion Constraint (EXCLUDE)

Ein **UNIQUE** verbietet nur **exakt gleiche** Werte.

Ein **EXCLUDE** verbietet Werte, die mit einem **beliebigen Operator** „kollidieren“ – z. B. **überlappende Zeiträume**.

**Beispiel:** Ein Raum darf nicht zweimal zur selben Zeit gebucht sein:

```sql
CREATE EXTENSION btree_gist;

CREATE TABLE buchungen (
    raum_id INT,
    zeitraum TSRANGE,
    EXCLUDE USING gist (raum_id WITH =, zeitraum WITH &&)
);
```

Bedeutung: Verboten sind zwei Zeilen mit **gleichem Raum** (`=`) und **überlappendem Zeitraum** (`&&`).

👉 UNIQUE ist eigentlich ein Spezialfall von EXCLUDE (nur mit `=`).

---

### 19. Warum den Primärschlüssel nie ändern?

- **Andere Tabellen verweisen darauf.** Ändert sich der Schlüssel, müssen alle Verweise mitgeändert werden – sonst zeigen sie ins Leere oder (schlimmer) auf den falschen Datensatz.
- **Außerhalb der DB** wird die ID ebenfalls genutzt: URLs, Rechnungen, Logs, Caches, andere Systeme. Die kann die Datenbank nicht automatisch anpassen.
- Es ist **langsam und riskant** (viele Updates, Sperren).

👉 Ein Primärschlüssel soll **stabil** sein wie eine Sozialversicherungsnummer.

---

### 20. DEFAULT vs. NOT NULL

- **DEFAULT** = „Wenn **kein** Wert angegeben wird, nimm diesen hier.“ → *liefert* einen Wert.
- **NOT NULL** = „Leer ist **verboten**.“ → *prüft* einen Wert.

**Zusammenspiel beim INSERT:**
1. Spalte wird weggelassen → DEFAULT springt ein → NOT NULL ist zufrieden ✅
2. Spalte weggelassen, **kein** DEFAULT → Wert ist NULL → NOT NULL meldet Fehler ❌
3. Jemand schreibt **ausdrücklich** `NULL` → DEFAULT greift **nicht** → NOT NULL meldet Fehler ❌

```sql
registriert_am TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
```

---

## Teil 2: Szenario – E-Commerce-Datenbank

### 1. Warum `id SERIAL PRIMARY KEY` statt E-Mail als Primärschlüssel?

- Die E-Mail-Adresse **kann sich ändern**. Dann müsste man sie auch in allen Bestellungen ändern.
- Eine Zahl ist **kleiner und schneller** als ein langer Text – besonders bei Verknüpfungen (JOINs).
- Die E-Mail ist personenbezogen (Datenschutz) und hätte dann in vielen Tabellen etwas verloren.
- Die künstliche ID **ändert sich nie** und hat keine Bedeutung – perfekt als Schlüssel.

---

### 2. Wie verhindert man doppelte E-Mail-Adressen?

Mit einem **UNIQUE-Constraint** (plus NOT NULL):

```sql
e_mail VARCHAR(255) NOT NULL UNIQUE
```

Die Datenbank legt einen Index an und prüft bei jedem INSERT/UPDATE, ob die Adresse schon existiert. Wenn ja → Fehler, der zweite Kunde wird nicht angelegt.

> Tipp: `Max@Shop.at` und `max@shop.at` gelten als verschieden. Dagegen hilft ein Unique-Index auf `lower(e_mail)`:
> ```sql
> CREATE UNIQUE INDEX uq_kunden_email ON kunden (lower(e_mail));
> ```

---

### 3. Warum reicht NUMERIC nicht für den Preis?

`NUMERIC` sagt nur: „Hier steht eine Zahl.“ Auch `-5.00` oder `0.00` sind gültige Zahlen.

Ein CHECK legt die **Geschäftsregel** fest:

```sql
preis NUMERIC(10,2) NOT NULL CONSTRAINT chk_preis CHECK (preis > 0)
```

Jetzt wird jedes Produkt mit Preis 0 oder negativ abgelehnt.

---

### 4. Welcher Foreign Key bei `bestellungen.kunde_id`?

```sql
CONSTRAINT fk_kunde FOREIGN KEY (kunde_id) REFERENCES kunden(id)
```

Versucht jemand, eine Bestellung mit einer `kunde_id` einzutragen, die es in `kunden` **nicht gibt**, lehnt die Datenbank das ab (Fehler: *foreign key violation*). So gibt es keine „Geister-Bestellungen“ ohne Kunden.

---

### 5. Warum ist ON DELETE RESTRICT beim Kundenlöschen erwünscht?

- **Gesetzliche Aufbewahrungspflicht:** Rechnungen und Bestellungen müssen jahrelang (in Österreich meist 7 Jahre) aufbewahrt werden.
- **Buchhaltung:** Umsätze, Steuern und Statistiken würden plötzlich nicht mehr stimmen.
- Mit CASCADE würden alle Bestellungen **unbemerkt mitgelöscht**.

👉 Die Fehlermeldung ist ein **Schutz**, kein Bug: Sie zwingt dazu, bewusst zu entscheiden – z. B. den Kunden zu **anonymisieren** oder als `inaktiv` zu markieren, statt ihn zu löschen.

---

### 6. Warum ein zusammengesetzter Primärschlüssel in `bestell_positionen`?

Ohne ihn könnte dasselbe Produkt **zweimal als eigene Zeile** in derselben Bestellung stehen:

| bestellung_id | produkt_id | menge |
|---|---|---|
| 1 | 7 | 2 |
| 1 | 7 | 3 |

Das ist verwirrend: Sind es 5 Stück? Oder ein Fehler? Richtig wäre **eine** Zeile mit `menge = 5`.

```sql
CREATE TABLE bestell_positionen (
    bestellung_id INT REFERENCES bestellungen(id) ON DELETE CASCADE,
    produkt_id    INT REFERENCES produkte(id),
    menge         INT NOT NULL,
    PRIMARY KEY (bestellung_id, produkt_id)
);
```

Die **Kombination** aus Bestellung und Produkt muss eindeutig sein.

---

### 7. Wie verhindert man Mengen kleiner als 1?

Mit einem CHECK:

```sql
menge INT NOT NULL CONSTRAINT chk_menge CHECK (menge >= 1)
```

0 oder negative Mengen werden abgelehnt.

---

### 8. Wie erlaubt man nur bestimmte Statuswerte?

Mit einem CHECK und `IN`:

```sql
ALTER TABLE bestellungen
ADD COLUMN status VARCHAR(50) NOT NULL DEFAULT 'neu'
    CONSTRAINT chk_status CHECK (status IN ('neu', 'bezahlt', 'versandet', 'storniert'));
```

`'fantasiestatus'` wird abgelehnt.

**Alternativen:**
- Eigener **ENUM-Typ**: `CREATE TYPE bestellstatus AS ENUM ('neu', 'bezahlt', 'versandet', 'storniert');`
- **Eigene Tabelle** `status` + Foreign Key – praktisch, wenn sich die Liste oft ändert.

---

### 9. CHECK-Constraint ändern (Preis = 0 jetzt erlaubt)

In PostgreSQL kann man einen CHECK **nicht direkt ändern** – man löscht ihn und legt einen neuen an. Am besten **in einer Transaktion**, damit es keinen Moment ohne Schutz gibt:

```sql
BEGIN;
ALTER TABLE produkte DROP CONSTRAINT chk_preis;
ALTER TABLE produkte ADD CONSTRAINT chk_preis CHECK (preis >= 0);
COMMIT;
```

**Warum sind die Altdaten sicher?** Die neue Regel (`>= 0`) ist **lockerer** als die alte (`> 0`). Alle alten Preise waren > 0 und erfüllen damit auch die neue Regel automatisch. Klappt etwas nicht, wird dank Transaktion alles zurückgerollt.

---

### 10. Warum schlafen alle ruhiger mit Constraints in der Datenbank?

- **Ein zentraler Schutz** für alle: Website, App, Admin-Tool, Import-Skripte, manuelles SQL – niemand kommt daran vorbei.
- **Fehler im Code** (Bugs, vergessene Prüfungen, neue Entwickler) können keine kaputten Daten mehr erzeugen.
- **Keine Geister-Datensätze**, keine doppelten Kunden, keine negativen Preise, keine falschen Status.
- Die Regeln sind **an einem Ort dokumentiert** – im Schema selbst.
- Weniger Datenchaos = weniger nächtliche Notfälle, korrekte Buchhaltung, zufriedene Kunden.

👉 **Frontend-Prüfung** = Komfort für den Benutzer (schnelles Feedback).
👉 **Datenbank-Constraints** = echte Sicherheit für die Daten.
