import 'package:flutter/foundation.dart';
import 'package:classtab_catalog/models/tablature.dart';
import 'package:classtab_catalog/services/database_service.dart';
import 'package:classtab_catalog/services/classtab_service.dart';

class TablatureProvider with ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService.instance;
  final ClassTabService _classTabService = ClassTabService();

  // Getter per accedere al servizio ClassTab
  ClassTabService get classTabService => _classTabService;

  List<Tablature> _tablatures = [];
  List<Tablature> _filteredTablatures = [];
  List<String> _composers = [];
  bool _isLoading = false;
  String _searchQuery = '';
  String _selectedComposer = '';
  String _errorMessage = '';

  // Getters
  List<Tablature> get tablatures => _filteredTablatures;
  List<String> get composers => _composers;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  String get selectedComposer => _selectedComposer;
  String get errorMessage => _errorMessage;
  int get totalCount => _tablatures.length;

  Future<void> loadTablatures() async {
    _setLoading(true);
    try {
      _tablatures = await _databaseService.getAllTablatures();
      _composers = await _databaseService.getAllComposers();
      _applyFilters();
      _clearError();
    } catch (e) {
      _setError('Errore nel caricamento delle tablature: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> syncWithClassTab() async {
    _setLoading(true);
    try {
      debugPrint('Starting ClassTab synchronization...');

      // Prima testa la connettività
      debugPrint('Testing connectivity...');
      final isConnected = await _classTabService.testConnectivity();
      if (!isConnected) {
        throw Exception(
            'Impossibile connettersi al server ClassTab. Verifica la connessione internet.');
      }

      // Verifica la disponibilità del file ZIP
      debugPrint('Checking ZIP availability...');
      final zipInfo = await _classTabService.checkZipAvailability();
      if (!zipInfo['available']) {
        throw Exception(
            'File ZIP non disponibile: ${zipInfo['error'] ?? 'Errore sconosciuto'}');
      }

      debugPrint(
          'ZIP file info: ${zipInfo['contentLength']} bytes, last modified: ${zipInfo['lastModified']}');

      // Scarica e estrai il file ZIP
      debugPrint('Downloading and extracting ZIP...');
      final extractPath = await _classTabService.downloadAndExtractZip();

      // Analizza i file locali
      debugPrint('Parsing local files...');
      final newTablatures = await _classTabService.parseLocalFiles(extractPath);

      if (newTablatures.isEmpty) {
        throw Exception('Nessuna tablatura trovata nei file scaricati');
      }

      debugPrint(
          'Found ${newTablatures.length} tablatures, updating database...');

      // Pulisci il database e inserisci le nuove tablature
      await _databaseService.clearAllTablatures();

      int insertedCount = 0;
      for (final tablature in newTablatures) {
        await _databaseService.insertTablature(tablature);
        insertedCount++;

        if (insertedCount % 100 == 0) {
          debugPrint(
              'Inserted $insertedCount/${newTablatures.length} tablatures...');
        }
      }

      debugPrint(
          'Database update completed. Inserted $insertedCount tablatures');

      // Ricarica i dati
      debugPrint('Reloading tablatures...');
      await loadTablatures();

      debugPrint('Synchronization completed successfully!');
      _clearError();
    } catch (e) {
      debugPrint('Synchronization failed: $e');
      _setError('Errore nella sincronizzazione: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> checkForUpdates() async {
    try {
      final hasUpdates = await _classTabService.checkForUpdates();
      if (hasUpdates) {
        // Notifica all'utente che ci sono aggiornamenti disponibili
        // Questo potrebbe essere gestito tramite un callback o un evento
      }
    } catch (e) {
      debugPrint('Errore nel controllo degli aggiornamenti: $e');
    }
  }

  void search(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  void filterByComposer(String composer) {
    _selectedComposer = composer;
    _applyFilters();
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = '';
    _selectedComposer = '';
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    _filteredTablatures = _tablatures.where((tablature) {
      bool matchesSearch = true;
      bool matchesComposer = true;

      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        matchesSearch = tablature.title.toLowerCase().contains(query) ||
            tablature.composer.toLowerCase().contains(query) ||
            (tablature.opus?.toLowerCase().contains(query) ?? false);
      }

      if (_selectedComposer.isNotEmpty) {
        matchesComposer = tablature.composer == _selectedComposer;
      }

      return matchesSearch && matchesComposer;
    }).toList();

    // Ordina per compositore e poi per titolo
    _filteredTablatures.sort((a, b) {
      final composerComparison = a.composer.compareTo(b.composer);
      if (composerComparison != 0) return composerComparison;
      return a.title.compareTo(b.title);
    });
  }

  Future<void> toggleFavorite(Tablature tablature) async {
    try {
      final newFavoriteStatus = !tablature.isFavorite;
      await _databaseService.toggleFavorite(tablature.id!, newFavoriteStatus);

      // Aggiorna la tablatura nella lista locale
      final index = _tablatures.indexWhere((t) => t.id == tablature.id);
      if (index != -1) {
        _tablatures[index] = tablature.copyWith(isFavorite: newFavoriteStatus);
        _applyFilters();
        notifyListeners();
      }
    } catch (e) {
      _setError('Errore nell\'aggiornamento dei preferiti: $e');
    }
  }

  Future<List<Tablature>> getFavorites() async {
    try {
      return await _databaseService.getFavoriteTablatures();
    } catch (e) {
      _setError('Errore nel caricamento dei preferiti: $e');
      return [];
    }
  }

  Future<String> getTablatureContent(Tablature tablature) async {
    if (tablature.content.isNotEmpty) {
      return tablature.content;
    }

    try {
      final content =
          await _classTabService.fetchTablatureContent(tablature.tabUrl);

      // Aggiorna il contenuto nel database
      final updatedTablature = tablature.copyWith(content: content);
      await _databaseService.updateTablature(updatedTablature);

      // Aggiorna la lista locale
      final index = _tablatures.indexWhere((t) => t.id == tablature.id);
      if (index != -1) {
        _tablatures[index] = updatedTablature;
        _applyFilters();
        notifyListeners();
      }

      return content;
    } catch (e) {
      throw Exception('Errore nel caricamento del contenuto: $e');
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = '';
    notifyListeners();
  }

  List<Tablature> getTablaturesByDifficulty(String difficulty) {
    return _tablatures.where((t) => t.difficulty == difficulty).toList();
  }

  List<Tablature> getTablaturesByFeature(String feature) {
    switch (feature.toLowerCase()) {
      case 'midi':
        return _tablatures.where((t) => t.hasMidi).toList();
      case 'lhf':
        return _tablatures.where((t) => t.hasLhf).toList();
      case 'video':
        return _tablatures.where((t) => t.hasVideo).toList();
      default:
        return [];
    }
  }

  Map<String, int> getStatistics() {
    return {
      'total': _tablatures.length,
      'withMidi': _tablatures.where((t) => t.hasMidi).length,
      'withLhf': _tablatures.where((t) => t.hasLhf).length,
      'withVideo': _tablatures.where((t) => t.hasVideo).length,
      'favorites': _tablatures.where((t) => t.isFavorite).length,
      'easy': _tablatures.where((t) => t.difficulty == 'easy').length,
    };
  }
}
