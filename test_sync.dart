#!/usr/bin/env dart

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:archive/archive.dart';
import 'package:html/parser.dart' as html_parser;

/// Script per testare manualmente la sincronizzazione delle tablature
void main() async {
  print('=== Test di Sincronizzazione ClassTab ===\n');

  final dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 60),
    sendTimeout: const Duration(seconds: 30),
  ));

  try {
    // Test 1: Connettività al server
    print('1. Testing connectivity to ClassTab server...');
    final connectivityResponse = await dio.head('https://www.classtab.org');
    print('   ✓ Server reachable (Status: ${connectivityResponse.statusCode})');

    // Test 2: Disponibilità del file ZIP
    print('\n2. Checking ZIP file availability...');
    final zipResponse =
        await dio.head('https://www.classtab.org/zip/classtab.zip');
    final lastModified = zipResponse.headers.value('last-modified');
    final contentLength = zipResponse.headers.value('content-length');
    print('   ✓ ZIP file available (Status: ${zipResponse.statusCode})');
    print('   ✓ Size: $contentLength bytes');
    print('   ✓ Last Modified: $lastModified');

    // Test 3: Download del file ZIP
    print('\n3. Downloading ZIP file...');
    final downloadResponse = await dio.get(
      'https://www.classtab.org/zip/classtab.zip',
      options: Options(responseType: ResponseType.bytes),
      onReceiveProgress: (received, total) {
        if (total != -1) {
          final progress = (received / total * 100).toStringAsFixed(1);
          stdout.write('\r   Progress: $progress% ($received/$total bytes)');
        }
      },
    );
    print('\n   ✓ Download completed (${downloadResponse.data.length} bytes)');

    // Test 4: Estrazione del file ZIP
    print('\n4. Extracting ZIP file...');
    final tempDir = Directory.systemTemp.createTempSync('classtab_test_');
    final archive = ZipDecoder().decodeBytes(downloadResponse.data);

    int extractedFiles = 0;
    for (final file in archive) {
      final filename = '${tempDir.path}/${file.name}';

      if (file.isFile) {
        final data = file.content as List<int>;
        final fileToWrite = File(filename);
        await fileToWrite.create(recursive: true);
        await fileToWrite.writeAsBytes(data);
        extractedFiles++;
      } else {
        await Directory(filename).create(recursive: true);
      }
    }
    print('   ✓ Extracted $extractedFiles files to ${tempDir.path}');

    // Test 5: Ricerca del file index
    print('\n5. Looking for index file...');
    final possibleIndexFiles = [
      'index_old.htm',
      'index.htm',
      'index.html',
      'classtab/index_old.htm',
      'classtab/index.htm',
      'classtab/index.html'
    ];

    File? indexFile;
    for (final fileName in possibleIndexFiles) {
      final file = File('${tempDir.path}/$fileName');
      if (await file.exists()) {
        indexFile = file;
        print('   ✓ Found index file: $fileName');
        break;
      }
    }

    if (indexFile == null) {
      print(
          '   ⚠ Index file not found in standard locations, searching recursively...');
      await for (final entity in tempDir.list(recursive: true)) {
        if (entity is File) {
          final fileName = entity.path.split('/').last;
          if (fileName == 'index_old.htm' ||
              fileName == 'index.htm' ||
              fileName == 'index.html') {
            indexFile = entity;
            print('   ✓ Found index file recursively: ${entity.path}');
            break;
          }
        }
      }
    }

    if (indexFile == null) {
      throw Exception('Index file not found');
    }

    // Test 6: Parsing del file index
    print('\n6. Parsing index file...');
    final htmlContent = await indexFile.readAsString();
    print('   ✓ Index file size: ${htmlContent.length} characters');

    final document = html_parser.parse(htmlContent);
    final allElements = document.querySelectorAll('b, a[href\$=".txt"]');

    int composerCount = 0;
    int tablatureCount = 0;
    String currentComposer = '';

    for (final element in allElements) {
      if (element.localName == 'b' && _isComposerText(element.text)) {
        currentComposer = _extractComposerName(element.text);
        composerCount++;
      } else if (element.localName == 'a') {
        final href = element.attributes['href'];
        if (href != null && href.endsWith('.txt') && !_isIndexFile(href)) {
          tablatureCount++;
        }
      }
    }

    print('   ✓ Found $composerCount composers');
    print('   ✓ Found $tablatureCount tablatures');

    // Test 7: Verifica di alcuni file di tablature
    print('\n7. Checking tablature files...');
    int foundFiles = 0;
    int checkedFiles = 0;

    for (final element in allElements.take(50)) {
      // Controlla solo i primi 50
      if (element.localName == 'a') {
        final href = element.attributes['href'];
        if (href != null && href.endsWith('.txt') && !_isIndexFile(href)) {
          checkedFiles++;
          final tabFile = File('${tempDir.path}/$href');
          if (await tabFile.exists()) {
            foundFiles++;
          }

          if (checkedFiles >= 10) break; // Controlla solo i primi 10 file
        }
      }
    }

    print('   ✓ Found $foundFiles/$checkedFiles tablature files');

    // Cleanup
    print('\n8. Cleaning up...');
    await tempDir.delete(recursive: true);
    print('   ✓ Temporary files removed');

    print('\n=== Test Completato con Successo! ===');
    print('La sincronizzazione dovrebbe funzionare correttamente.');
  } catch (e) {
    print('\n❌ Test fallito: $e');
    exit(1);
  }
}

bool _isComposerText(String text) {
  final cleanText = text.trim();
  if (cleanText.isEmpty || cleanText.length < 5) return false;

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

  final namePattern = RegExp(r'^[A-Z][a-z]+ [A-Z]');
  final hasProperName = namePattern.hasMatch(cleanText);

  final datePattern =
      RegExp(r'\(\d{4}[-/]\d{4}\)|\(\d{4}-\d{4}\)|\(c\d{4}-\d{4}\)|\(\d{4}-\)');
  final hasDates = datePattern.hasMatch(cleanText);

  return hasProperName || hasDates;
}

bool _isIndexFile(String href) {
  final fileName = href.toLowerCase();
  return fileName.contains('index') ||
      fileName.contains('readme') ||
      fileName.contains('credits') ||
      fileName.contains('tabbing') ||
      fileName.contains('upgrade');
}

String _extractComposerName(String text) {
  final match = RegExp(r'^([^(]+)').firstMatch(text);
  return match?.group(1)?.trim() ?? text;
}
