# Containerisierung

## Konzept und Konfiguration
Während man bei der Virtualisierung gleich ganze Computer nachbaut, teilt man sich bei der Containerisierung einfach das Betriebssystem. Alles wird in kleine, isolierte Boxen gepackt, die schnell starten und überall exakt gleich laufen.

### Speicherabbilder & Register
Das Image ist der fertige Bauplan für deinen Container, ein abgepacktes Paket mit allem, was die App zum Laufen braucht. Die Registry ist einfach die Online-Bibliothek (wie Docker Hub), aus der du dir diese Pläne bei Bedarf ziehst.

### Runtime Environments
Das ist die Laufzeitumgebung, also der Motor, der die Baupläne zum Leben erweckt. Sie sorgt dafür, dass aus dem starren Image ein echter, laufender Container wird und weist ihm die nötigen Systemressourcen zu.

### Netzwerkkonfiguration
Container leben erst einmal isoliert. Über die Netzwerkkonfiguration sorgt man dafür, dass sie miteinander sprechen können, damit Benutzer über den Browser auf die App im Container zugreifen können.

### Persistente Volumes
Container sind von Natur aus vergänglich: Wird einer gelöscht, sind alle neuen Daten weg. Dauerhafte Speicher sind externe Festplatten, die man an den Container ankoppelt, damit Daten (wie Datenbanken oder Logfiles) dauerhaft sicher gespeichert bleiben.

### Containerisierung vs. Virtualisierung
Bei der Virtualisierung hat jede VM ein eigenes, schweres Betriebssystem (Gast) und braucht viel Leistung. Container teilen sich den Kern des Host-Systems, sind leicht, starten in Sekundenbruchteilen und verbrauchen kaum Ressourcen.

## Tools of the Trade
weiss nicht was damit gemeint ist

### Docker
Docker hat Container erst für die breite Masse fit gemacht. Es macht das Leben viel leichter, weil man seine App einfach in ein fertiges Paket steckt und sich keine Sorgen mehr machen muss, ob sie auf einem anderen PC läuft.

### Linux Containers (LXC)
Das ist der Urvater und eine etwas andere Liga. Während Docker meist nur eine einzelne App pro Container startet, fühlt sich LXC eher wie ein leichtgewichtiges, virtuelles Linux-System an, in dem man mehrere Dienste gleichzeitig laufen lassen kann.
