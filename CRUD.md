# Create, Read, Update, Delete (CRUD)

CRUD ist eine Akronym für die vier grundlegende Operationen, die auf Daten in einer Datenbank durchgeführt werden können: Create (Erstellen), Read (lesen), Update (Aktualisieren) und Delete (Löschen). Diese Operationen bilden die Basis für die Interaktion mit Datenbanken und sind entscheidend für die Verwaltung von Daten.

## CREATE (Erstellen)

CREATE erstellt neue Datenbankobjekte in denen, beispielsweise, Datensätze gespeichert werden können.


```sql
CREATE TYPE esrb_rating AS ENUM ('Everyone', 'Teen', 'Mature');

CREATE TABLE developers (
    developer_id SERIAL PRIMARY KEY,
    studio_name VARCHAR(100) NOT NULL UNIQUE,
    headquarters TEXT,
    founded_year INTEGER CHECK (founded_year > 1950)
);
```

## INSERT INTO ... (Einfügen)

INSERT INTO erstellt neue Datensätze in vorher bestimmten Datenobjekte, bzw. Tabellen. Die Spalten, in die die Daten eingefügt werden sollen, müssen angegeben werdem.

```sql
INSERT INTO platforms (platform_name, manufacturer)
VALUES ('PlayStation 5', 'Sony'),
       ('PC', 'Microsoft'),
       ('Switch', 'Nintendo');
RETURNING platform_name, manufacturer;
```

## READ (Lesen)

Select holt sich allle möglichen Daten abhängig davon was näher spezifiziert wird. Es können einzelne Spalten, mehrere Spalten oder alle Spalten einer Tabelle ausgewählt werden. Außerdem können Bedingungen angegeben werdn ,um die Ergebnisse zu filtern.

```sql
select title as "Game Title", price as "Current Price", price * 1,2  as "Price + Tax"
from games
where price > 35.00;
```

#### Mathematische Funktionen
Mathematische Funktionen helfen in SQL dabei bestimmte Berechnungen auf den Daten durchzuführen. Sie können verwendet werden, um Summen, Durchschnitte, Minimum und Maximum zu berechnen.

```sql
select 
	count(*) as total_games,					-- Zählt alle Spiele
	sum(price) as sum_price,					-- Summiert den Preis aller Spiele
	round(avg(price),2) as average_price,		-- Berechnet den durchschnittlichen Spielpreis auf 2 Kommastellen
	min(price) as minimum_price,				-- holt den kleinsten bekannten Preis
	max(price) as maximum_price					-- holt den größten bekannten Preis
from games
;
```

#### Gruppierungen

Die Gruppierungen von Daten ermöglicht es, Datensätze basierend auf bestimmte Kriterien zusammenzufassen. Dies ust besonders nützlich, um aggregierte Information zu erhalten, wie z.B. die Anzahl der Spiele pro Bewerungskategorie.

```sql
select 
	rating,
	count(*) as games_count
from games
group by rating
;
```

#### Sortierung 
Die Sortierung von Daten ermöglicht es, die Ergebnisse einer Abfrage in einer bestimmten Reichenfolge anzuzeigen. Dies kann aufsteigend (ASC) oder absteigend (DESC) erfolgen.

```sql
select 
	developer_id,
	title,
	price
from games
where developer_id = 1
order by price desc --descending
limit 3
;
```

#### Patterns 
Patterns ermögliches es, Daten basierend auf bestimmten Mustern zu filtern. Dies ist besonders nützlich, um Datensätze zu finden, die bestimmte Zeichenfolge enthalten oder bestimmen Kriterien entsprechen.

```sql
-- LIKE: Das %-Zeichen signalisiert, dass ab dieser Stelle beliebige Zeichen folgen können.
select * 
from  games
where title like 'Dark%'    --Sucht beliebe Zeichen bis zu einem 'o' und sucht anschließend weiter.
;
```

#### Boolesche Logik

Die Boolesche Logik ermöglicht es, komplexe Bedingungen in SQL-Abfragen zu erstellen. Mit Operatoren wie AND, OR und NOT können Sie mehrere Bedingungen kombinieren, um die gewünschte Ergebnisse zu erhalten. Dies basiert auf der booleschen Algebra, die in der Informatik weit verbreitet ist, und sich am besten mit zwei gegensätzlichen Zuständen (wahr/falsch) beschreiben lässt, wie z.B. Wahr oder Falsch, heiß oder kalt, 1 oder 0.

```sql
-- Boolesche Logik, kurz erklärt - Waht oder Falsch, Heiß oder Kalt
-- NOT: Flipt in das Gegenteilige
-- AND: Verlangt das beide Wahr ist
-- OR: Verlang das eines oder beides Wahr istselect * 
from  games
where title not like '%o%'
;

select * 
from  games
where title like '%o%' and title like '%e%'
;
```

#### Intervalle 

Intervalle ermöglichen es, Daten basierend auf einem bestimmten Bereich zu filtern. Dies ust besonders nützlich, um Datensätze zu finden, die innerhalb eines bestimmten Preisbereichs oder einer bestimmten Kategorie liegen.

```sql
select *
from games
where price between 10.00 and 50.00
	or genre in ('ACTION', 'Action RPG')
	
;
```

