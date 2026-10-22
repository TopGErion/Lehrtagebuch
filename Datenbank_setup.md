# Datenbanksetup

Datenbanken sind Informationsspeichersysteme die spezialisiert auf das Speichern von Daten sind. Sie werden in der Regel über eine Schnittstelle angesprochen und können über Abfragesprache wie SQL oder GraphQL  Daten bereitstellen.
Man unterscheidet zwischen Server und Clientapplikationen, die auf unterschiedlichen Systemen laufen können. Die Serverapplikation stellt die Datenbank bereit und verwaltet die Daten, während die Clientapplikation die Datenbank abfragt und die Ergebnisse anzeigt.

## Containerumgebung

Eine Containerisierungsplattform ist eine isolierte Umgebung, in der Anwendung und ihre Abhängigkeiten zusammengefasst werden, Container ermöglichen es, Anwendungen konsistent auf verschiedene Systeme auszuführen, unabhängig von der zugrunde liegende Infrastruktur.

#### Docker

Docker ist eine Containerisierungsplattform, die es ermöglicht, Anwendungen und ihre Abhängigkeiten in Container zu verpacken und auszuführen. Dies kann man mithilfe der Command Line Interface (CLI), Dockerfile, Docker Compose oder Docker Swarn tun.

#### Docker Compose

Docker Compose baut auf Docker auf und ermöglicht es, Multi-Container-Anwendungen zu definieren und zu verwalten. Mit einer YAML-Datei können Sie die Dienste, Netzwerke und Volumes Ihrer Anwendung konfigurieren und mit einem einziegen Befehl starten.

## Datenbankinstanzen

Datenbanken kann man auf unterschiedlichen Varianten hin bereitstsellen und konfigurieren

#### Datenbankserver

Postgres oder Postgis sind Beispiele für Datenbankserver, die auf einem Server installiert werden können. Die bieten eine Schnittstelle für Clientanwendungen, um auf die Daten zugreifen und Abfragen auszuführen.

#### Datenbakclients

DBeaver oder pgAdmin sind Beispiele für Datenbankclients, die auf einem Clientsystem installiert werden können. Sie bieten eine grafische Benutzeroberfläche, um Datenbanken zu verwalten, Abfragen auszuführen und Ergebnisse auszuzeigen

