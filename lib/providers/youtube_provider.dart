import 'package:flutter/foundation.dart';
import 'package:classtab_catalog/models/tablature.dart';
import 'package:classtab_catalog/services/youtube_service.dart';

class YouTubeProvider extends ChangeNotifier {
  final YouTubeService _youtubeService = YouTubeService();

  String? _currentVideoId;
  String? _currentVideoTitle;
  bool _isPlayerVisible = false;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  String? get currentVideoId => _currentVideoId;
  String? get currentVideoTitle => _currentVideoTitle;
  bool get isPlayerVisible => _isPlayerVisible;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Apre il player YouTube per una tablatura
  Future<void> openYouTubePlayer(Tablature tablature) async {
    _setLoading(true);
    _clearError();

    try {
      final videoId = await _youtubeService.searchVideoForTablature(tablature);

      if (videoId != null) {
        _currentVideoId = videoId;
        _currentVideoTitle =
            '${tablature.composer} - ${tablature.displayTitle}';
        _isPlayerVisible = true;
        notifyListeners();
      } else {
        _setError('Nessun video trovato per questa tablatura');
      }
    } catch (e) {
      _setError('Errore durante la ricerca del video: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Chiude il player YouTube
  void closeYouTubePlayer() {
    _currentVideoId = null;
    _currentVideoTitle = null;
    _isPlayerVisible = false;
    _clearError();
    notifyListeners();
  }

  /// Imposta lo stato di caricamento
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Imposta un messaggio di errore
  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  /// Pulisce il messaggio di errore
  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Verifica se una tablatura ha un video disponibile
  bool hasVideo(Tablature tablature) {
    return tablature.hasVideo ||
        (tablature.videoUrl != null && tablature.videoUrl!.isNotEmpty);
  }

  /// Ottiene l'URL della thumbnail per una tablatura
  Future<String?> getThumbnailUrl(Tablature tablature) async {
    try {
      final videoId = await _youtubeService.searchVideoForTablature(tablature);
      if (videoId != null) {
        return _youtubeService.buildThumbnailUrl(videoId);
      }
    } catch (e) {
      print('Errore nel recupero della thumbnail: $e');
    }
    return null;
  }
}
