# Funzionalità YouTube Player

## Descrizione
È stata implementata una nuova funzionalità che permette di visualizzare video YouTube correlati alle tablature direttamente nell'app tramite un player fluttuante.

## Caratteristiche Principali

### 1. Player YouTube Fluttuante
- **Posizionamento**: Il player appare come una finestra fluttuante sopra il contenuto principale
- **Trascinabile**: L'utente può trascinare il player in qualsiasi posizione dello schermo
- **Ridimensionabile**: Il player può essere minimizzato o espanso
- **Modalità Audio**: Possibilità di passare alla modalità solo audio per risparmiare batteria

### 2. Integrazione nell'App

#### Bottoni YouTube
- **Schermata di Dettaglio**: Bottone YouTube nella barra superiore
- **Widget MIDI Player**: Bottone YouTube integrato nel player MIDI
- **Card Tablature**: Bottone YouTube in ogni card delle tablature

#### Ricerca Automatica
- Il sistema cerca automaticamente video YouTube correlati alla tablatura
- Utilizza il nome del compositore e il titolo del brano per la ricerca
- Fallback con video di esempio per test

### 3. Controlli del Player

#### Player Espanso
- **Drag Handle**: Icona per trascinare il player
- **Titolo**: Mostra il titolo della tablatura
- **Modalità Video/Audio**: Toggle per passare tra video e solo audio
- **Minimizza**: Riduce il player a una barra compatta
- **Chiudi**: Chiude completamente il player

#### Player Minimizzato
- **Play/Pause**: Controllo di riproduzione
- **Espandi**: Ritorna alla modalità completa
- **Chiudi**: Chiude il player

### 4. Modalità Solo Audio
- Nasconde il video per risparmiare risorse
- Mostra controlli audio semplificati
- Icona musicale per indicare la modalità audio
- Controlli di riproduzione dedicati

## Implementazione Tecnica

### File Creati/Modificati

#### Nuovi File
1. **`lib/services/youtube_service.dart`**
   - Servizio per la ricerca di video YouTube
   - Estrazione di video ID da URL
   - Gestione delle API YouTube (con fallback)

2. **`lib/providers/youtube_provider.dart`**
   - Provider per la gestione dello stato del player
   - Controllo della visibilità del player
   - Gestione degli errori e del caricamento

3. **`lib/widgets/floating_youtube_player.dart`**
   - Widget del player YouTube fluttuante
   - Gestione del trascinamento e ridimensionamento
   - Controlli di riproduzione e modalità

#### File Modificati
1. **`pubspec.yaml`**
   - Aggiunta dipendenza `youtube_player_flutter: ^9.0.1`

2. **`lib/main.dart`**
   - Aggiunto `YouTubeProvider` ai provider dell'app

3. **`lib/screens/tablature_detail_screen.dart`**
   - Aggiunto bottone YouTube nella barra superiore
   - Integrato player fluttuante con Stack
   - Passaggio della tablatura al widget MIDI

4. **`lib/widgets/midi_player_widget.dart`**
   - Aggiunto bottone YouTube nel player MIDI
   - Integrazione con YouTubeProvider

5. **`lib/screens/home_screen.dart`**
   - Aggiunto player YouTube fluttuante globale
   - Modificata struttura con Stack

6. **`lib/widgets/tablature_card.dart`**
   - Aggiunto bottone YouTube in ogni card
   - Integrazione con YouTubeProvider

### Dipendenze
- **youtube_player_flutter**: ^9.0.1 - Player YouTube per Flutter
- **dio**: ^5.3.2 - Client HTTP per le richieste (già presente)
- **html**: ^0.15.4 - Parser HTML per scraping (già presente)

## Utilizzo

### Per l'Utente
1. **Aprire un Video**: Cliccare sul bottone YouTube (icona play rossa) in qualsiasi schermata
2. **Trascinare**: Tenere premuto e trascinare il player nella posizione desiderata
3. **Minimizzare**: Cliccare l'icona minimizza per ridurre il player
4. **Modalità Audio**: Cliccare l'icona videocamera per passare alla modalità solo audio
5. **Chiudere**: Cliccare la X per chiudere il player

### Per lo Sviluppatore
```dart
// Aprire il player YouTube
context.read<YouTubeProvider>().openYouTubePlayer(tablature);

// Chiudere il player
context.read<YouTubeProvider>().closeYouTubePlayer();

// Verificare se una tablatura ha video
final hasVideo = context.read<YouTubeProvider>().hasVideo(tablature);
```

## Note Tecniche

### Ricerca Video
- Attualmente utilizza scraping HTML come fallback (senza API key)
- Per produzione, si consiglia di utilizzare l'API YouTube ufficiale
- I video di fallback sono hardcoded per test

### Performance
- Il player è ottimizzato per il trascinamento fluido
- La modalità audio riduce l'utilizzo di risorse
- Il player si chiude automaticamente quando si cambia schermata

### Limitazioni Attuali
- Ricerca video limitata senza API key YouTube
- Video di fallback per test
- Non persistenza dello stato del player tra sessioni

## Possibili Miglioramenti Futuri
1. Integrazione con API YouTube ufficiale
2. Cache dei video ID trovati
3. Playlist automatiche per compositori
4. Controlli di velocità di riproduzione
5. Salvataggio delle preferenze del player
6. Integrazione con sistema di preferiti