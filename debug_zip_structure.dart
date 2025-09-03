#!/usr/bin/env dart

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:archive/archive.dart';
import 'package:html/parser.dart' as html_parser;

/// Script per analizzare la struttura del file ZIP e trovare i file delle tablature
void main() async {
  print('=== Analisi Struttura ZIP ClassTab ===\n');

  final dio = Dio();

  try {
    // Download del file ZIP
    print('Downloading ZIP file...');
    final response = await dio.get(
      'https://www.classtab.org/zip/classtab.zip',
      options: Options(responseType: ResponseType.bytes),
    );

    // Estrazione in directory temporanea
    final tempDir = Directory.systemTemp.createTempSync('classtab_debug_');
    final archive = ZipDecoder().decodeBytes(response.data);

    print('Extracting to: ${tempDir.path}');

    // Mappa per tenere traccia della struttura
    Map<String, List<String>> directoryStructure = {};
    List<String> txtFiles = [];
    List<String> indexFiles = [];

    for (final file in archive) {
      final filename = file.name;

      if (file.isFile) {
        // Salva il file
        final filePath = '${tempDir.path}/$filename';
        final fileToWrite = File(filePath);
        await fileToWrite.create(recursive: true);
        await fileToWrite.writeAsBytes(file.content as List<int>);

        // Analizza la struttura
        final dir = filename.contains('/')
            ? filename.substring(0, filename.lastIndexOf('/'))
            : '.';
        directoryStructure.putIfAbsent(dir, () => []).add(filename);

        // Categorizza i file
        if (filename.toLowerCase().endsWith('.txt')) {
          txtFiles.add(filename);
        }
        if (filename.toLowerCase().contains('index')) {
          indexFiles.add(filename);
        }
      } else {
        await Directory('${tempDir.path}/$filename').create(recursive: true);
      }
    }

    print('\n=== STRUTTURA DIRECTORY ===');
    final sortedDirs = directoryStructure.keys.toList()..sort();
    for (final dir in sortedDirs) {
      final files = directoryStructure[dir]!;
      print('$dir/ (${files.length} files)');

      // Mostra alcuni file di esempio
      final examples = files.take(3).toList();
      for (final example in examples) {
        print('  - $example');
      }
      if (files.length > 3) {
        print('  ... and ${files.length - 3} more files');
      }
    }

    print('\n=== FILE INDEX TROVATI ===');
    for (final indexFile in indexFiles) {
      print('- $indexFile');
    }

    print('\n=== ANALISI FILE TXT ===');
    print('Total .txt files: ${txtFiles.length}');

    // Raggruppa per directory
    Map<String, int> txtByDir = {};
    for (final txtFile in txtFiles) {
      final dir = txtFile.contains('/')
          ? txtFile.substring(0, txtFile.lastIndexOf('/'))
          : '.';
      txtByDir[dir] = (txtByDir[dir] ?? 0) + 1;
    }

    print('Distribution by directory:');
    for (final entry in txtByDir.entries) {
      print('  ${entry.key}/: ${entry.value} files');
    }

    // Mostra alcuni esempi di file .txt
    print('\nExamples of .txt files:');
    for (final txtFile in txtFiles.take(10)) {
      print('  - $txtFile');
    }

    // Trova e analizza il file index principale
    print('\n=== ANALISI FILE INDEX ===');
    String? mainIndexFile;
    for (final indexFile in indexFiles) {
      if (indexFile.toLowerCase().contains('index_old.htm')) {
        mainIndexFile = indexFile;
        break;
      }
    }

    if (mainIndexFile == null) {
      for (final indexFile in indexFiles) {
        if (indexFile.toLowerCase().contains('index.htm')) {
          mainIndexFile = indexFile;
          break;
        }
      }
    }

    if (mainIndexFile != null) {
      print('Using index file: $mainIndexFile');

      final indexContent =
          await File('${tempDir.path}/$mainIndexFile').readAsString();
      final document = html_parser.parse(indexContent);
      final links = document.querySelectorAll('a[href\$=".txt"]');

      print('Links to .txt files found in index: ${links.length}');

      // Analizza alcuni link
      print('\nFirst 10 links from index:');
      for (int i = 0; i < links.length && i < 10; i++) {
        final href = links[i].attributes['href'];
        final text = links[i].text.trim();
        print('  $i: $href -> "$text"');

        // Verifica se il file esiste
        final possiblePaths = [
          '${tempDir.path}/$href',
          '${tempDir.path}/classtab/$href',
          '${tempDir.path}/${mainIndexFile.substring(0, mainIndexFile.lastIndexOf('/'))}/$href',
        ];

        bool found = false;
        for (final testPath in possiblePaths) {
          if (await File(testPath).exists()) {
            print('    ✓ Found at: $testPath');
            found = true;
            break;
          }
        }

        if (!found) {
          print('    ❌ File not found, tried:');
          for (final testPath in possiblePaths) {
            print('      - $testPath');
          }
        }
      }
    }

    // Cleanup
    await tempDir.delete(recursive: true);
    print('\n=== Analisi completata ===');
  } catch (e) {
    print('Errore: $e');
  }
}
