# Guida all'Uso - ClassTab Catalog

## 🎵 Panoramica

ClassTab Catalog è un'applicazione Flutter che permette di catalogare, ricercare e visualizzare le tablature di chitarra classica dal sito [ClassTab.org](https://www.classtab.org). L'app scarica automaticamente oltre 3000 tablature e le organizza in un database locale per un accesso rapido e offline.

## 🚀 Primo Avvio

### 1. Sincronizzazione Iniziale
Al primo avvio dell'app:

1. **Apri l'app** - Vedrai la schermata Home con le statistiche vuote
2. **Tocca il pulsante "Sincronizza"** - Questo avvierà il download del file ZIP da ClassTab.org (circa 13MB)
3. **Attendi il completamento** - Il processo può richiedere alcuni minuti a seconda della connessione
4. **Conferma il successo** - Vedrai le statistiche aggiornate con il numero di tablature scaricate

### 2. Cosa Viene Scaricato
- **File ZIP completo** da ClassTab.org
- **Oltre 3000 tablature** in formato testo
- **Metadati** per ogni tablatura (compositore, titolo, opus, tonalità, difficoltà)
- **Informazioni sui file MIDI** disponibili
- **Link ai video** dimostrativi quando disponibili

## 🔍 Ricerca delle Tablature

### Schermata "Cerca"
1. **Barra di ricerca** - Inserisci il nome del compositore, titolo del brano o opus
2. **Filtri avanzati**:
   - **Compositore** - Filtra per compositore specifico
   - **Difficoltà** - Facile, Intermedio, Avanzato
   - **Caratteristiche** - MIDI disponibile, LHF (Left Hand Fingering), Video
3. **Risultati** - Tocca una tablatura per visualizzarla

### Esempi di Ricerca
- `Bach` - Trova tutte le opere di Bach
- `BWV 1007` - Cerca per numero di opus
- `Prelude` - Cerca per titolo
- `Am` - Cerca per tonalità

## 📖 Visualizzazione delle Tablature

### Schermata Dettaglio
Quando apri una tablatura vedrai:

1. **Informazioni del brano**:
   - Compositore e titolo
   - Opus e tonalità
   - Livello di difficoltà
   - Caratteristiche disponibili

2. **Contenuto della tablatura**:
   - Testo formattato con carattere monospace
   - Numerazione delle righe (opzionale)
   - Scroll verticale per tablature lunghe

3. **Controlli**:
   - **Cuore** - Aggiungi/rimuovi dai preferiti
   - **Condividi** - Condividi la tablatura
   - **Player MIDI** - Se disponibile

## 🎹 Riproduzione MIDI

### Player MIDI Integrato
Per le tablature con file MIDI disponibili:

1. **Controlli di riproduzione**:
   - **Play/Pause** - Avvia/ferma la riproduzione
   - **Stop** - Ferma e riporta all'inizio
   - **Loop** - Ripetizione continua

2. **Controlli avanzati**:
   - **Volume** - Regola il volume di riproduzione
   - **Tempo** - Cambia la velocità (50% - 200%)
   - **Barra di progresso** - Naviga nella traccia

3. **Cache automatica**:
   - I file MIDI vengono scaricati e salvati localmente
   - Riproduzione offline dopo il primo download

## ⭐ Gestione Preferiti

### Schermata "Preferiti"
1. **Aggiungi ai preferiti** - Tocca il cuore su qualsiasi tablatura
2. **Visualizza preferiti** - Vai alla scheda "Preferiti"
3. **Rimuovi dai preferiti** - Tocca nuovamente il cuore
4. **Accesso rapido** - I preferiti sono sempre disponibili offline

## 👨‍🎼 Esplorazione per Compositore

### Schermata "Compositori"
1. **Lista alfabetica** - Tutti i compositori ordinati A-Z
2. **Conteggio opere** - Numero di tablature per compositore
3. **Dettaglio compositore** - Tocca un compositore per vedere tutte le sue opere
4. **Ricerca rapida** - Barra di ricerca nella lista compositori

## ⚙️ Impostazioni

### Configurazione App
1. **Sincronizzazione**:
   - Sincronizzazione automatica
   - Controllo manuale aggiornamenti
   - Data ultima sincronizzazione

2. **Riproduzione MIDI**:
   - Download automatico file MIDI
   - Gestione cache MIDI
   - Pulizia cache

3. **Visualizzazione**:
   - Mostra numeri di riga
   - Dimensione carattere
   - Tema dell'app

4. **Database**:
   - Statistiche utilizzo
   - Pulizia database
   - Esportazione preferiti

## 🔄 Aggiornamenti

### Controllo Aggiornamenti
L'app controlla automaticamente gli aggiornamenti da ClassTab.org:

1. **Controllo automatico** - All'avvio dell'app (se abilitato)
2. **Controllo manuale** - Pulsante "Sincronizza ora" nelle impostazioni
3. **Download incrementale** - Solo le nuove tablature vengono scaricate
4. **Notifiche** - L'app ti avvisa quando ci sono aggiornamenti

### Frequenza Aggiornamenti
- ClassTab.org viene aggiornato periodicamente con nuove tablature
- L'app può controllare gli aggiornamenti quotidianamente
- Gli aggiornamenti sono generalmente piccoli (nuove tablature)

## 💡 Consigli per l'Uso

### Ottimizzazione Prestazioni
1. **Prima sincronizzazione** - Falla con WiFi per risparmiare dati
2. **Cache MIDI** - Scarica i MIDI solo dei brani che ascolti spesso
3. **Pulizia periodica** - Pulisci la cache MIDI se lo spazio è limitato

### Ricerca Efficace
1. **Usa filtri** - Combina ricerca testuale con filtri per risultati precisi
2. **Salva preferiti** - Marca i brani che suoni spesso
3. **Esplora per compositore** - Scopri nuove opere dei tuoi compositori preferiti

### Utilizzo Offline
1. **Database locale** - Tutte le tablature sono disponibili offline
2. **MIDI cache** - I file MIDI scaricati funzionano offline
3. **Sincronizzazione** - Richiede connessione internet solo per aggiornamenti

## 🐛 Risoluzione Problemi

### Problemi Comuni

**Sincronizzazione fallita**:
- Controlla la connessione internet
- Riprova più tardi (il server potrebbe essere occupato)
- Pulisci la cache dell'app

**MIDI non si riproduce**:
- Verifica che il dispositivo supporti la riproduzione MIDI
- Controlla le impostazioni audio del dispositivo
- Riavvia l'app

**App lenta**:
- Pulisci la cache MIDI
- Riavvia l'app
- Controlla lo spazio disponibile sul dispositivo

**Tablature non trovate**:
- Verifica di aver completato la sincronizzazione iniziale
- Prova termini di ricerca diversi
- Controlla i filtri attivi

## 📞 Supporto

Per problemi, bug o suggerimenti:
- Apri un issue su GitHub
- Controlla la documentazione completa nel README.md
- Visita ClassTab.org per informazioni sulle tablature originali

---

**Nota**: Questa app è un client non ufficiale per ClassTab.org. Tutti i diritti sulle tablature appartengono ai rispettivi autori e al sito ClassTab.org.