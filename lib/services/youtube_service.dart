import 'package:dio/dio.dart';
import 'package:classtab_catalog/models/tablature.dart';
import 'package:html/parser.dart' as html_parser;

class YouTubeService {
  final Dio _dio = Dio();

  /// Cerca un video YouTube per una tablatura
  Future<String?> searchVideoForTablature(Tablature tablature) async {
    try {
      // Se la tablatura ha già un URL video, lo restituisce
      if (tablature.videoUrl != null && tablature.videoUrl!.isNotEmpty) {
        return _extractVideoId(tablature.videoUrl!);
      }

      // Costruisce la query di ricerca
      String query =
          '${tablature.composer} ${tablature.title} classical guitar';
      if (tablature.opus != null && tablature.opus!.isNotEmpty) {
        query = '${tablature.composer} ${tablature.opus} classical guitar';
      }

      // Effettua la ricerca tramite scraping (metodo alternativo senza API key)
      final searchUrl =
          'https://www.youtube.com/results?search_query=${Uri.encodeComponent(query)}';

      final response = await _dio.get(
        searchUrl,
        options: Options(
          headers: {
            'User-Agent':
                'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
          },
        ),
      );

      if (response.statusCode == 200) {
        final document = html_parser.parse(response.data);

        // Cerca il primo video ID nella pagina
        final scriptTags = document.querySelectorAll('script');
        for (final script in scriptTags) {
          final content = script.text;
          if (content.contains('var ytInitialData')) {
            final videoIdMatch =
                RegExp(r'"videoId":"([^"]{11})"').firstMatch(content);
            if (videoIdMatch != null) {
              return videoIdMatch.group(1);
            }
          }
        }

        // Metodo alternativo: cerca nei link
        final links = document.querySelectorAll('a[href*="/watch?v="]');
        for (final link in links) {
          final href = link.attributes['href'];
          if (href != null) {
            final videoId = _extractVideoId('https://youtube.com$href');
            if (videoId != null) {
              return videoId;
            }
          }
        }
      }
    } catch (e) {
      print('Errore nella ricerca YouTube: $e');
      // Fallback: restituisce un video ID di esempio per test
      return _getFallbackVideoId(tablature);
    }

    return null;
  }

  /// Restituisce un video ID di fallback per test
  String? _getFallbackVideoId(Tablature tablature) {
    // Video ID di esempio per test (un video di chitarra classica generico)
    // In produzione, questo dovrebbe essere rimosso o sostituito con una logica più sofisticata

    // Alcuni video ID di chitarra classica per test
    final fallbackVideos = [
      'LFXYBUdIIKM', // Classical Guitar Music
      'voUiWOGv8ec', // Spanish Guitar
      'KBCQQyKzfKs', // Classical Guitar Pieces
    ];

    // Restituisce un video basato sull'hash del titolo per consistenza
    final hash = (tablature.title + tablature.composer).hashCode.abs();
    return fallbackVideos[hash % fallbackVideos.length];
  }

  /// Estrae l'ID del video da un URL YouTube
  String? _extractVideoId(String url) {
    final RegExp regExp = RegExp(
      r'(?:youtube\.com\/(?:[^\/]+\/.+\/|(?:v|e(?:mbed)?)\/|.*[?&]v=)|youtu\.be\/)([^"&?\/\s]{11})',
      caseSensitive: false,
    );

    final match = regExp.firstMatch(url);
    return match?.group(1);
  }

  /// Costruisce l'URL completo del video YouTube
  String buildVideoUrl(String videoId) {
    return 'https://www.youtube.com/watch?v=$videoId';
  }

  /// Costruisce l'URL della thumbnail del video
  String buildThumbnailUrl(String videoId) {
    return 'https://img.youtube.com/vi/$videoId/mqdefault.jpg';
  }
}
