// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'ClassTab Catalog';

  @override
  String get home => 'Home';

  @override
  String get search => 'Cerca';

  @override
  String get composers => 'Compositori';

  @override
  String get favorites => 'Preferiti';

  @override
  String get syncWithClassTab => 'Sincronizza con ClassTab.org';

  @override
  String get synchronization => 'Sincronizzazione';

  @override
  String get syncDialogContent =>
      'Vuoi sincronizzare le tablature con ClassTab.org? Questo scaricherà tutti i dati più recenti (circa 13MB).';

  @override
  String get cancel => 'Annulla';

  @override
  String get sync => 'Sincronizza';

  @override
  String get loadingTablatures => 'Caricamento tablature...';

  @override
  String get retry => 'Riprova';

  @override
  String get noTablaturesFound => 'Nessuna tablatura trovata';

  @override
  String get syncToDownloadTablatures =>
      'Sincronizza con ClassTab.org per scaricare le tablature';

  @override
  String get syncNow => 'Sincronizza ora';

  @override
  String get recentTablatures => 'Tablature Recenti';

  @override
  String viewAllTablatures(int count) {
    return 'Vedi tutte le $count tablature';
  }

  @override
  String get youTubeVideo => 'Video YouTube';

  @override
  String get settings => 'Impostazioni';

  @override
  String get searchTablatures => 'Cerca tablature...';

  @override
  String get composer => 'Compositore';

  @override
  String get title => 'Titolo';

  @override
  String get difficulty => 'Difficoltà';

  @override
  String get all => 'Tutti';

  @override
  String get easy => 'Facile';

  @override
  String get medium => 'Medio';

  @override
  String get hard => 'Difficile';

  @override
  String get expert => 'Esperto';

  @override
  String get clearFilters => 'Cancella filtri';

  @override
  String get noResults => 'Nessun risultato trovato';

  @override
  String get tryDifferentSearch =>
      'Prova un termine di ricerca diverso o cancella i filtri';

  @override
  String get totalTablatures => 'Tablature totali';

  @override
  String get totalComposers => 'Compositori totali';

  @override
  String get favoriteTablatures => 'Tablature preferite';

  @override
  String get lastSync => 'Ultima sincronizzazione';

  @override
  String get never => 'Mai';

  @override
  String get addToFavorites => 'Aggiungi ai preferiti';

  @override
  String get removeFromFavorites => 'Rimuovi dai preferiti';

  @override
  String get viewTablature => 'Visualizza tablatura';

  @override
  String get playMidi => 'Riproduci MIDI';

  @override
  String get watchOnYouTube => 'Guarda su YouTube';

  @override
  String get noFavorites => 'Nessun preferito ancora';

  @override
  String get addFavoritesMessage =>
      'Aggiungi alcune tablature ai tuoi preferiti per vederle qui';

  @override
  String get browseTablatures => 'Sfoglia tablature';

  @override
  String tablaturesByComposer(String composer) {
    return 'Tablature di $composer';
  }

  @override
  String get noTablaturesForComposer =>
      'Nessuna tablatura trovata per questo compositore';

  @override
  String get midiSettings => 'Impostazioni MIDI';

  @override
  String get enableMidi => 'Abilita riproduzione MIDI';

  @override
  String get midiVolume => 'Volume MIDI';

  @override
  String get generalSettings => 'Impostazioni Generali';

  @override
  String get language => 'Lingua';

  @override
  String get theme => 'Tema';

  @override
  String get light => 'Chiaro';

  @override
  String get dark => 'Scuro';

  @override
  String get system => 'Sistema';

  @override
  String get about => 'Informazioni';

  @override
  String get version => 'Versione';

  @override
  String get aboutApp => 'Informazioni sull\'app';

  @override
  String get appDescription =>
      'Un\'applicazione Flutter per catalogare e visualizzare tablature di chitarra classica da ClassTab.org';

  @override
  String get loading => 'Caricamento...';

  @override
  String get error => 'Errore';

  @override
  String get ok => 'OK';

  @override
  String get close => 'Chiudi';

  @override
  String get save => 'Salva';

  @override
  String get delete => 'Elimina';

  @override
  String get confirm => 'Conferma';

  @override
  String get yes => 'Sì';

  @override
  String get no => 'No';

  @override
  String get filters => 'Filtri';

  @override
  String get startSearching => 'Inizia a cercare le tablature';

  @override
  String get tryDifferentTerms => 'Prova con termini di ricerca diversi';

  @override
  String resultsCount(int count) {
    return '$count risultati';
  }

  @override
  String get clearAllFilters => 'Pulisci filtri';

  @override
  String get allComposers => 'Tutti i compositori';

  @override
  String get quickFilters => 'Filtri rapidi';

  @override
  String get withMidi => 'Con MIDI';

  @override
  String get withLhf => 'Con LHF';

  @override
  String get withVideo => 'Con Video';

  @override
  String get easyTablatures => 'Facili';

  @override
  String filterApplied(String filter) {
    return 'Filtro \"$filter\" applicato';
  }

  @override
  String get goToFavoritesTab =>
      'Vai alla scheda Preferiti per vedere i tuoi preferiti';

  @override
  String errorLoadingFavorites(String error) {
    return 'Errore nel caricamento dei preferiti: $error';
  }

  @override
  String favoritesCount(int count) {
    return '$count Preferiti';
  }

  @override
  String get clearAll => 'Pulisci tutto';

  @override
  String get removeAllFavorites => 'Rimuovi tutti i preferiti';

  @override
  String get removeAllFavoritesConfirm =>
      'Sei sicuro di voler rimuovere tutte le tablature dai preferiti? Questa azione non può essere annullata.';

  @override
  String get removeAll => 'Rimuovi tutto';

  @override
  String get allFavoritesRemoved => 'Tutti i preferiti sono stati rimossi';

  @override
  String errorRemovingFavorites(String error) {
    return 'Errore nella rimozione dei preferiti: $error';
  }

  @override
  String get appInfo => 'Informazioni App';

  @override
  String get appName => 'Nome App';

  @override
  String get developer => 'Sviluppatore';
}
