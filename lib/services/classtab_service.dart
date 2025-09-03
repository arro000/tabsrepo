import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart' as html_dom;
import 'package:archive/archive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:classtab_catalog/models/tablature.dart';

class ClassTabService {
  static const String baseUrl = 'https://www.classtab.org';
  static const String indexUrl = '$baseUrl/index_old.htm';
  static const String zipUrl = '$baseUrl/zip/classtab.zip';

  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 60),
    sendTimeout: const Duration(seconds: 30),
  ));

  /// Testa la connettività al server ClassTab
  Future<bool> testConnectivity() async {
    try {
      debugPrint('Testing connectivity to ClassTab server...');
      final response = await _dio.head(baseUrl);
      debugPrint('Connectivity test successful: ${response.statusCode}');
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Connectivity test failed: $e');
      return false;
    }
  }

  /// Verifica se il file ZIP è disponibile
  Future<Map<String, dynamic>> checkZipAvailability() async {
    try {
      debugPrint('Checking ZIP file availability...');
      final response = await _dio.head(zipUrl);
      final lastModified = response.headers.value('last-modified');
      final contentLength = response.headers.value('content-length');

      debugPrint('ZIP file check successful:');
      debugPrint('  Status: ${response.statusCode}');
      debugPrint('  Last Modified: $lastModified');
      debugPrint('  Content Length: $contentLength bytes');

      return {
        'available': response.statusCode == 200,
        'lastModified': lastModified,
        'contentLength': contentLength,
        'statusCode': response.statusCode,
      };
    } catch (e) {
      debugPrint('ZIP file check failed: $e');
      return {
        'available': false,
        'error': e.toString(),
      };
    }
  }

  Future<List<Tablature>> fetchTablaturesList() async {
    try {
      final response = await _dio.get(indexUrl);
      return _parseIndexPage(response.data);
    } catch (e) {
      throw Exception('Errore nel caricamento delle tablature: $e');
    }
  }

  List<Tablature> _parseIndexPage(String htmlContent) {
    final document = html_parser.parse(htmlContent);
    final List<Tablature> tablatures = [];

    String currentComposer = '';

    // Trova tutti gli elementi <b> (compositori) e <a> (tablature) in ordine
    final allElements = document.querySelectorAll('b, a[href\$=".txt"]');

    for (final element in allElements) {
      if (element.localName == 'b' && _isComposerText(element.text)) {
        // Questo è un compositore
        currentComposer = _extractComposerName(element.text);
        debugPrint('Trovato compositore: $currentComposer');
      } else if (element.localName == 'a') {
        // Questo è un link a una tablatura
        final href = element.attributes['href'];
        if (href != null && href.endsWith('.txt') && !_isIndexFile(href)) {
          final tablature = _parseTablatureLink(element, currentComposer, href);
          if (tablature != null) {
            tablatures.add(tablature);
            debugPrint(
                'Trovata tablatura: ${tablature.title} - ${tablature.composer}');
          }
        }
      }
    }

    return tablatures;
  }

  bool _isComposerText(String text) {
    final cleanText = text.trim();
    if (cleanText.isEmpty || cleanText.length < 5) return false;

    // Lista di parole che NON sono compositori
    final excludeWords = [
      'LHF',
      'easy',
      'plain text',
      'more are welcome',
      'zip file',
      'recent additions',
      'Facebook Group',
      'NEW HOME PAGE',
      'upgrade',
      'SCROLLING APP',
      'tab info',
      'classical music',
      'self-composed',
      'unpublished',
      'TIP-UOUCG',
      'download the zip file'
    ];

    for (final word in excludeWords) {
      if (cleanText.toLowerCase().contains(word.toLowerCase())) {
        return false;
      }
    }

    // I compositori iniziano con una lettera maiuscola e contengono nomi propri
    // Spesso hanno nomi e cognomi separati da spazi
    final namePattern = RegExp(r'^[A-Z][a-z]+ [A-Z]');
    final hasProperName = namePattern.hasMatch(cleanText);

    // Oppure contengono date in parentesi
    final datePattern = RegExp(
        r'\(\d{4}[-/]\d{4}\)|\(\d{4}-\d{4}\)|\(c\d{4}-\d{4}\)|\(\d{4}-\)');
    final hasDates = datePattern.hasMatch(cleanText);

    return hasProperName || hasDates;
  }

  bool _hasNextSiblingWithText(html_dom.Element element, String searchText) {
    // Cerca nei fratelli successivi per trovare link MIDI
    var sibling = element.nextElementSibling;
    while (sibling != null) {
      if (sibling.localName == 'a' && sibling.text.contains(searchText)) {
        return true;
      }
      if (sibling.localName == 'br') break; // Fine della riga
      sibling = sibling.nextElementSibling;
    }
    return false;
  }

  bool _isIndexFile(String href) {
    // Filtra i file index che non sono tablature
    final fileName = href.toLowerCase();
    return fileName.contains('index') ||
        fileName.contains('readme') ||
        fileName.contains('credits') ||
        fileName.contains('tabbing') ||
        fileName.contains('upgrade');
  }

  String _extractComposerName(String text) {
    // Estrae il nome del compositore dal testo
    final match = RegExp(r'^([^(]+)').firstMatch(text);
    return match?.group(1)?.trim() ?? text;
  }

  Tablature? _parseTablatureLink(
      html_dom.Element link, String composer, String href) {
    final text = link.text.trim();
    if (text.isEmpty) return null;

    // Analizza il contesto della riga per estrarre informazioni
    final parentText = link.parent?.text ?? '';
    final fullLineText = parentText.isNotEmpty ? parentText : text;

    // Cerca informazioni aggiuntive nella riga
    final hasMidi =
        _hasNextSiblingWithText(link, 'MIDI') || fullLineText.contains('MIDI');
    final hasLhf = fullLineText.contains('LHF');
    final hasVideo =
        fullLineText.contains('vid:') || fullLineText.contains('[vid:');
    final isEasy =
        fullLineText.contains('[easy]') || fullLineText.contains('easy');

    // Estrae il titolo
    String title = text;
    title = title.replaceAll(RegExp(r'\s*-\s*MIDI.*'), '');
    title = title.replaceAll(RegExp(r'\s*-\s*LHF.*'), '');
    title = title.replaceAll(RegExp(r'\[.*?\]'), '');
    title = title.trim();

    // Estrae opus se presente
    String? opus;
    final opusMatch =
        RegExp(r'^(Op\s*\d+[^-]*)', caseSensitive: false).firstMatch(title);
    if (opusMatch != null) {
      opus = opusMatch.group(1);
      title =
          title.substring(opusMatch.end).replaceFirst(RegExp(r'^[,\s-]+'), '');
    }

    // Estrae la tonalità
    String? key;
    final keyMatch = RegExp(r'in ([A-G][#b]?m?)').firstMatch(text);
    if (keyMatch != null) {
      key = keyMatch.group(1);
    }

    // Costruisce gli URL
    final tabUrl = href.startsWith('http') ? href : '$baseUrl/$href';
    String? midiUrl;
    if (hasMidi) {
      midiUrl = tabUrl.replaceAll('.txt', '.mid');
    }

    // Estrae URL video se presente
    String? videoUrl;
    final videoMatch = RegExp(r'\[vid:\s*([^\]]+)\]').firstMatch(text);
    if (videoMatch != null) {
      // Questo è solo il nome del canale/artista, non l'URL completo
      // In una implementazione reale potresti voler cercare su YouTube
    }

    return Tablature(
      title: title,
      composer: composer,
      opus: opus,
      key: key,
      difficulty: isEasy ? 'easy' : null,
      hasMidi: hasMidi,
      hasLhf: hasLhf,
      hasVideo: hasVideo,
      videoUrl: videoUrl,
      tabUrl: tabUrl,
      midiUrl: midiUrl,
      content: '', // Sarà caricato separatamente
      lastUpdated: DateTime.now(),
    );
  }

  Future<String> fetchTablatureContent(String url) async {
    try {
      final response = await _dio.get(url);
      return response.data as String;
    } catch (e) {
      throw Exception(
          'Errore nel caricamento del contenuto della tablatura: $e');
    }
  }

  Future<Uint8List> fetchMidiFile(String url) async {
    try {
      final response = await _dio.get(
        url,
        options: Options(responseType: ResponseType.bytes),
      );
      return Uint8List.fromList(response.data);
    } catch (e) {
      throw Exception('Errore nel caricamento del file MIDI: $e');
    }
  }

  Future<String> downloadAndExtractZip() async {
    try {
      debugPrint('Starting ZIP download from: $zipUrl');

      // Prima verifica la disponibilità del file
      final zipCheck = await checkZipAvailability();
      if (!zipCheck['available']) {
        throw Exception(
            'ZIP file not available: ${zipCheck['error'] ?? 'Unknown error'}');
      }

      // Scarica il file ZIP
      final response = await _dio.get(
        zipUrl,
        options: Options(responseType: ResponseType.bytes),
        onReceiveProgress: (received, total) {
          if (total != -1) {
            final progress = (received / total * 100).toStringAsFixed(1);
            debugPrint(
                'Download progress: $progress% ($received/$total bytes)');
          } else {
            debugPrint('Download progress: $received bytes received');
          }
        },
      );

      debugPrint(
          'Download completed. Response size: ${response.data.length} bytes');

      // Ottieni la directory dei documenti
      final directory = await getApplicationDocumentsDirectory();
      final extractPath = path.join(directory.path, 'classtab_data');
      debugPrint('Extract path: $extractPath');

      // Crea la directory se non esiste
      final extractDir = Directory(extractPath);
      if (await extractDir.exists()) {
        debugPrint('Removing existing extract directory...');
        await extractDir.delete(recursive: true);
      }
      await extractDir.create(recursive: true);
      debugPrint('Extract directory created');

      // Estrai il file ZIP
      debugPrint('Starting ZIP extraction...');
      final archive = ZipDecoder().decodeBytes(response.data);
      debugPrint('ZIP archive contains ${archive.length} files');

      int extractedFiles = 0;
      for (final file in archive) {
        final filename = path.join(extractPath, file.name);

        if (file.isFile) {
          final data = file.content as List<int>;
          final fileToWrite = File(filename);
          await fileToWrite.create(recursive: true);
          await fileToWrite.writeAsBytes(data);
          extractedFiles++;

          if (extractedFiles % 100 == 0) {
            debugPrint('Extracted $extractedFiles files...');
          }
        } else {
          await Directory(filename).create(recursive: true);
        }
      }

      debugPrint('ZIP extraction completed. Extracted $extractedFiles files');
      return extractPath;
    } catch (e) {
      debugPrint('Error in downloadAndExtractZip: $e');
      throw Exception('Errore nel download e estrazione del file ZIP: $e');
    }
  }

  Future<List<Tablature>> parseLocalFiles(String extractPath) async {
    final List<Tablature> tablatures = [];

    try {
      debugPrint('Starting to parse local files from: $extractPath');

      // Verifica che la directory esista
      final extractDir = Directory(extractPath);
      if (!await extractDir.exists()) {
        throw Exception('Extract directory does not exist: $extractPath');
      }

      // Cerca il file index.htm in diverse posizioni possibili
      File? indexFile;
      final possibleIndexFiles = [
        'index_old.htm', // Prova prima questo che è quello principale
        'index.htm',
        'index.html',
        'classtab/index_old.htm',
        'classtab/index.htm',
        'classtab/index.html'
      ];

      debugPrint('Searching for index file in possible locations...');
      for (final fileName in possibleIndexFiles) {
        final file = File(path.join(extractPath, fileName));
        debugPrint('Checking: ${file.path}');
        if (await file.exists()) {
          indexFile = file;
          debugPrint('Found index file: ${file.path}');
          break;
        }
      }

      if (indexFile == null) {
        debugPrint(
            'Index file not found in standard locations, searching recursively...');
        // Cerca ricorsivamente nella directory
        final dir = Directory(extractPath);
        await for (final entity in dir.list(recursive: true)) {
          if (entity is File) {
            final fileName = path.basename(entity.path);
            if (fileName == 'index_old.htm' ||
                fileName == 'index.htm' ||
                fileName == 'index.html') {
              indexFile = entity;
              debugPrint('Found index file recursively: ${entity.path}');
              break;
            }
          }
        }

        if (indexFile == null) {
          // Lista tutti i file per debug
          debugPrint('Available files in extract directory:');
          await for (final entity in dir.list(recursive: false)) {
            debugPrint('  ${path.basename(entity.path)}');
          }
          throw Exception(
              'File index non trovato in nessuna delle posizioni previste');
        }
      }

      debugPrint('Reading index file content...');
      final htmlContent = await indexFile.readAsString();
      debugPrint('Index file size: ${htmlContent.length} characters');

      debugPrint('Parsing index page...');
      final parsedTablatures = _parseIndexPage(htmlContent);
      debugPrint('Parsed ${parsedTablatures.length} tablatures from index');

      // Determina il percorso base per i file delle tablature
      final indexDir = path.dirname(indexFile.path);
      debugPrint('Index directory: $indexDir');

      // Carica il contenuto delle tablature dai file locali
      int loadedCount = 0;
      for (int i = 0; i < parsedTablatures.length; i++) {
        final tab = parsedTablatures[i];
        try {
          // Estrai il percorso relativo dal URL
          final relativePath = tab.tabUrl.replaceAll('$baseUrl/', '');

          // Lista di possibili percorsi dove cercare il file
          final possiblePaths = [
            path.join(indexDir, relativePath), // Stessa directory dell'index
            path.join(
                extractPath, relativePath), // Directory principale estratta
            path.join(extractPath, 'classtab',
                relativePath), // Sottodirectory classtab
            path.join(
                indexDir, '..', relativePath), // Directory padre dell'index
          ];

          File? tabFile;
          String? foundPath;

          for (final testPath in possiblePaths) {
            final file = File(testPath);
            if (await file.exists()) {
              tabFile = file;
              foundPath = testPath;
              break;
            }
          }

          if (tabFile != null) {
            final content = await tabFile.readAsString();
            tablatures.add(tab.copyWith(content: content));
            loadedCount++;

            // Debug per i primi file trovati
            if (loadedCount <= 5) {
              debugPrint('Found tablature file: $foundPath');
            }
          } else {
            // Debug per i primi file non trovati
            if (i < 5) {
              debugPrint('Tablature file not found: $relativePath');
              debugPrint('  Tried paths:');
              for (final testPath in possiblePaths) {
                debugPrint('    $testPath');
              }
            }
            // Aggiungi comunque la tablatura senza contenuto
            tablatures.add(tab);
          }

          if ((i + 1) % 100 == 0) {
            debugPrint(
                'Processed ${i + 1}/${parsedTablatures.length} tablatures (loaded: $loadedCount)...');
          }
        } catch (e) {
          debugPrint('Error loading file ${tab.tabUrl}: $e');
          // Aggiungi comunque la tablatura senza contenuto
          tablatures.add(tab);
        }
      }

      debugPrint(
          'Parsing completed. Total tablatures: ${tablatures.length}, with content: $loadedCount');
      return tablatures;
    } catch (e) {
      debugPrint('Error in parseLocalFiles: $e');
      throw Exception('Errore nell\'analisi dei file locali: $e');
    }
  }

  Future<bool> checkForUpdates() async {
    try {
      final response = await _dio.head(zipUrl);
      final lastModified = response.headers.value('last-modified');

      if (lastModified != null) {
        // Confronta con l'ultima data di aggiornamento salvata
        // Implementazione semplificata
        return true;
      }

      return false;
    } catch (e) {
      debugPrint('Errore nel controllo degli aggiornamenti: $e');
      return false;
    }
  }
}
