# Virtualisierung

## Hypervisortypen
Software- oder Firmware, die physische Hardware-Ressourcen (CPU, Arbeitsspeicher, Speicherplatz, Netzwerk) abstrahiert und die Erstellung sowie Verwaltung von virtuellen Maschinen (VMs) ermöglicht.

### Hypervisor-1
Der läuft direkt auf der Hardware, ganz ohne normales Betriebssystem darunter. Das macht ihn extrem schnell, sicher und effizient.

### Hypervisor-2
Dieser Typ wird wie ein ganz normales Programm auf einem bereits bestehenden Betriebssystem (wie Windows oder macOS) installiert. Er ist super praktisch zum Testen und Herumspielen auf dem eigenen Laptop, verbraucht aber mehr Leistung.

## Komponentenweise Virtualisierung
Damit eine virtuelle Maschine wie ein echter Computer funktioniert, braucht sie auch die passenden virtuellen Organe. Hier wird dem Gast-System einfach Hardware per Software bereitgestellt.

### Virtualisierte Hardware
Das sind die digitalen Nachbildungen echter PC-Komponenten. Sie teilen sich die Ressourcen des echten Rechners auf.

- vHDX
- vRAM
- vGPU
- vCPU
- vNIC

### Host- & Gastsysteme
Der Host ist der echte, physische Server oder PC, der die Hardware stellt. Das Gastsystem ist die virtuelle Maschine, die läuft und gar nicht merkt, dass sie nur in einer simulierten Umgebung lebt.

## Tools of the Trade
Wenn man Virtualisierung in der Praxis umsetzen will, greift man meistens zu den großen, etablierten Werkzeugen am Markt.

### Hyper-V
Das ist die Virtualisierungslösung direkt von Microsoft. Sie ist tief in Windows Server integriert, extrem stabil und die logische Wahl, wenn man ohnehin in einer reinen Windows-Umgebung arbeitet.

### Proxmox
Eine geniale Open-Source-Plattform, die auf Linux basiert. Proxmox ist extrem beliebt, weil es komplett kostenlos ist, mächtige Funktionen für Backups bietet und sich super bequem über eine Weboberfläche im Browser bedienen lässt.
