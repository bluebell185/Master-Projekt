<div align="center">
  <h1>aissistant</h1>
  <h2>- Beauty Recommendation App -</h2>
  <p> Masterprojekt </p>
</div>

## Überblick
**aissistant** ist eine mobile App, die künstliche Intelligenz mit persönlicher Unterstützung kombiniert, um als virtueller Make-up-Guide zur Seite zu stehen. Dank präziser Gesichtsanalyse erkennt die App individuellen Merkmale und gibt personalisierte Empfehlungen für Make-up-Looks. Diese können direkt mit Augmented Reality (AR) als Filter ausprobiert werden – spielerisch, intuitiv und ganz ohne Risiko. Sie macht den Einstieg in die Welt des Make-ups leichter: mit modernen Technologien hilft sie, neue Looks zu entdecken, passende Produkte auszuwählen und Kreativität auszuleben. <br> 

## Features
- **Analysis**: Das Analysis-Feature nutzt moderne Gesichtsanalyse, um verschiedene Face Features wie Augenform, Augenfarbe, Teint und Gesichtsform zu identifizieren. Basierend auf diesen Daten generiert das System individuelle Make-up-Empfehlungen, beispielsweise passende Lidschattenfarben oder geeignete Eyeliner-Stile. Zusätzlich stellt aissistant eine Galerie mit passenden Looks bereit, die visuell veranschaulichen, wie die empfohlenen Looks aufgetragen aussehen können. Nutzer haben die Möglichkeit, diese Looks direkt mithilfe von AR auch bei sich direkt aufzutragen.

- **Look Generator**: Dieses Feature richtet sich an Nutzer, die eine grobe Vorstellung von bestimmten Anhaltspunkten haben, aber nicht genau wissen, wie sie es umsetzen sollen. Ob ein kreativer Morgen, ein entspanntes Mittagessen oder ein elegantes Abend-Date – der Look Generator erstellt automatisch einen passenden Make-up-Look basierend auf den eingegebenen Vorgaben. Nutzer können einfach angeben, welchen Anlass sie haben oder welche Stimmung sie ausdrücken möchten, und das System generiert daraufhin einen vollständigen Look. Dieser wird anschließend virtuell aufgetragen, sodass er direkt ausprobiert und angepasst werden kann.

- **User Account**: Durch das Anlegen eines User Accounts können wichtige persönliche Merkmale, die durch die Gesichtsanalyse erfasst wurden, gespeichert werden. Dies ermöglicht eine kontinuierliche Nutzung der individuell angepassten Make-up-Empfehlungen, ohne dass bei jeder Verwendung eine neue Analyse durchgeführt werden muss. Falls sich die Gesichtsdaten ändern oder eine aktualisierte Analyse gewünscht ist, kann die Gesichtsanalyse jederzeit erneut durchgeführt und die gespeicherten Daten aktualisiert werden.

- **Speichern der Looks**: Es gibt auch die Möglichkeit, einen erstellten Make-up-Look als Bild zu speichern. Dieses Bild wird direkt in der Galerie des Geräts abgelegt, sodass der Look jederzeit wieder angesehen und nachgeschminkt werden kann. Dadurch lassen sich bevorzugte Stile festhalten und bei Bedarf mit anderen teilen.

## Technologie-Stack
- **Flutter** für plattformübergreifende Entwicklung
- **Dart** als Programmiersprache
- **Google ML Kit** zur Gesichts- und Featureerkennung
- **DeepAR** für AR-Filter-Applikation
- **DeepAR Studio** zur Erstellung von AR-Filtern
- **Firebase** für User Account und Speicherung der Analyseergebnisse

## Installation
### Voraussetzungen
- USB-Debugging aktiviert (zu finden unter Entwickleroptionen)
- Flutter SDK installiert ([Installation](https://flutter.dev/docs/get-started/install))
- Android Studio oder Visual Studio Code mit Flutter-Plugin

### Installation der Flutter-App auf einem Android-Gerät per USB-Kabel

#### USB-Debugging aktivieren
1. Öffnen der **Einstellungen** auf dem Android-Gerät.
2. Zu **Über das Telefon** gehen.
3. **7-mal auf die Build-Nummer** tippen, um die **Entwickleroptionen** zu aktivieren.
4. Zurück zu **Einstellungen** > **Entwickleroptionen**.
5. Aktivieren von **USB-Debugging**.

#### Gerät mit dem Computer verbinden
1. Verbinden des Android-Geräts über ein **USB-Kabel** mit dem Computer.
2. Überprüfen, ob das Gerät erkannt wird, indem folgender Befehl im Terminal oder in der Eingabeaufforderung ausgeführt wirdt:
   ```sh
   flutter devices

### Installationsschritte
1. **Repository klonen:**
   ```sh
   git clone https://github.com/bluebell185/Master-Projekt.git
   cd Master-Projekt
   ```
2. **Abhängigkeiten installieren:**
   ```sh
   flutter pub get
   ```
3. **App starten:**
   ```sh
   flutter run
   ```
