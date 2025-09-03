# ClassTab Catalog

Un'applicazione Flutter per catalogare e visualizzare le tablature di chitarra classica dal sito [ClassTab.org](https://www.classtab.org).

## Caratteristiche

### 🎵 Catalogazione delle Tablature
- Oltre 3000 tablature di chitarra classica
- Organizzate per compositore
- Ricerca avanzata per titolo, compositore e opus
- Filtri per difficoltà, caratteristiche (MIDI, LHF, Video)

### 🎼 Visualizzazione
- Visualizzazione ottimizzata delle tablature in formato testo
- Carattere monospace per allineamento perfetto
- Controllo della dimensione del carattere
- Opzione per mostrare i numeri di riga
- Evidenziazione delle informazioni importanti

### 🎹 Riproduzione MIDI
- Riproduzione dei file MIDI associati alle tablature
- Controlli di riproduzione (play, pause, stop)
- Controllo del volume e del tempo
- Modalità loop
- Cache locale per riproduzione offline

### ⭐ Gestione Preferiti
- Salva le tablature preferite
- Accesso rapido ai brani preferiti
- Gestione completa della lista preferiti

### 🔄 Sincronizzazione
- Download automatico dal sito ClassTab.org
- Estrazione e parsing del file ZIP (13MB)
- Controllo degli aggiornamenti
- Sincronizzazione incrementale

## Struttura delle Tablature

Le tablature provengono da ClassTab.org e includono:

- **Compositore**: Nome del compositore
- **Titolo**: Titolo del brano
- **Opus**: Numero dell'opus (quando disponibile)
- **Tonalità**: Tonalità del brano
- **Difficoltà**: Livello di difficoltà (facile, intermedio, avanzato)
- **MIDI**: File MIDI per l'ascolto
- **LHF**: Left Hand Fingering (diteggiatura mano sinistra)
- **Video**: Link a video dimostrativi

## Tecnologie Utilizzate

### Framework e Linguaggi
- **Flutter**: Framework UI cross-platform
- **Dart**: Linguaggio di programmazione

### Gestione dello Stato
- **Provider**: State management pattern

### Database e Storage
- **SQLite**: Database locale per le tablature
- **SharedPreferences**: Impostazioni dell'app
- **Path Provider**: Gestione dei percorsi file

### Networking e Parsing
- **Dio**: Client HTTP per download
- **HTML Parser**: Parsing delle pagine web
- **Archive**: Gestione file ZIP

### Audio
- **Flutter MIDI Command**: Riproduzione file MIDI

### UI Components
- **Material Design Icons**: Icone aggiuntive
- **Flutter SpinKit**: Indicatori di caricamento
- **Flutter TypeAhead**: Ricerca con suggerimenti

## Installazione

### Prerequisiti
- Flutter SDK (>=3.10.0)
- Dart SDK (>=3.0.0)
- Android Studio / VS Code
- Dispositivo Android o emulatore

### Passi per l'installazione

1. **Clona il repository**
   ```bash
   git clone <repository-url>
   cd classtab_catalog
   ```

2. **Installa le dipendenze**
   ```bash
   flutter pub get
   ```

3. **Configura l'ambiente**
   ```bash
   flutter doctor
   ```

4. **Esegui l'app**
   ```bash
   flutter run
   ```

## Utilizzo

### Prima Configurazione
1. Apri l'app
2. Tocca il pulsante di sincronizzazione nella home
3. Conferma il download (circa 13MB)
4. Attendi il completamento della sincronizzazione

### Ricerca delle Tablature
1. Vai alla scheda "Cerca"
2. Inserisci il termine di ricerca
3. Usa i filtri per raffinare i risultati
4. Tocca una tablatura per visualizzarla

### Riproduzione MIDI
1. Apri una tablatura con file MIDI
2. Usa i controlli del player MIDI
3. Regola volume e velocità secondo le preferenze

### Gestione Preferiti
1. Tocca l'icona del cuore su una tablatura
2. Vai alla scheda "Preferiti" per vederle tutte
3. Rimuovi dai preferiti toccando nuovamente il cuore

## Struttura del Progetto

```
lib/
├── main.dart                 # Entry point dell'app
├── models/                   # Modelli dati
│   └── tablature.dart
├── providers/                # State management
│   ├── tablature_provider.dart
│   └── midi_provider.dart
├── services/                 # Servizi business logic
│   ├── database_service.dart
│   └── classtab_service.dart
├── screens/                  # Schermate dell'app
│   ├── home_screen.dart
│   ├── search_screen.dart
│   ├── favorites_screen.dart
│   ├── composers_screen.dart
│   ├── composer_detail_screen.dart
│   ├── tablature_detail_screen.dart
│   └── settings_screen.dart
└── widgets/                  # Widget riutilizzabili
    ├── tablature_card.dart
    ├── statistics_card.dart
    ├── search_filters.dart
    └── midi_player_widget.dart
```

## Funzionalità Future

- [ ] Esportazione delle tablature in PDF
- [ ] Condivisione delle tablature
- [ ] Modalità offline completa
- [ ] Supporto per tablature personalizzate
- [ ] Integrazione con YouTube per i video
- [ ] Metronomo integrato
- [ ] Accordatore per chitarra

## Contribuire

1. Fork del progetto
2. Crea un branch per la feature (`git checkout -b feature/AmazingFeature`)
3. Commit delle modifiche (`git commit -m 'Add some AmazingFeature'`)
4. Push al branch (`git push origin feature/AmazingFeature`)
5. Apri una Pull Request

## Licenza

Questo progetto è distribuito sotto licenza MIT. Vedi il file `LICENSE` per i dettagli.

## Riconoscimenti

- **ClassTab.org**: Per la fantastica collezione di tablature di chitarra classica
- **Flutter Team**: Per l'eccellente framework
- **Comunità Open Source**: Per le librerie utilizzate

## Supporto

Per supporto, bug report o richieste di funzionalità:
- Apri un issue su GitHub
- Contatta il team di sviluppo

---

**Nota**: Questa applicazione è un client non ufficiale per ClassTab.org. Tutti i diritti sulle tablature appartengono ai rispettivi autori e al sito ClassTab.org.