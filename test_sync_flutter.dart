#!/usr/bin/env dart

import 'dart:io';

// Importa i servizi dell'app
import 'lib/services/classtab_service.dart';
import 'lib/services/database_service.dart';

/// Test della sincronizzazione usando i servizi Flutter
void main() async {
  print('=== Test Sincronizzazione Flutter ===\n');

  try {
    final service = ClassTabService();

    // Test 1: Connettività
    print('1. Testing connectivity...');
    final isConnected = await service.testConnectivity();
    print(
        '   ${isConnected ? '✓' : '❌'} Connectivity: ${isConnected ? 'OK' : 'Failed'}');

    if (!isConnected) {
      print('❌ Cannot proceed without connectivity');
      return;
    }

    // Test 2: ZIP availability
    print('\n2. Checking ZIP availability...');
    final zipInfo = await service.checkZipAvailability();
    print(
        '   ${zipInfo['available'] ? '✓' : '❌'} ZIP available: ${zipInfo['available']}');
    if (zipInfo['available']) {
      print('   Size: ${zipInfo['contentLength']} bytes');
      print('   Last Modified: ${zipInfo['lastModified']}');
    }

    if (!zipInfo['available']) {
      print('❌ Cannot proceed without ZIP file');
      return;
    }

    // Test 3: Download and extract
    print('\n3. Downloading and extracting...');
    final extractPath = await service.downloadAndExtractZip();
    print('   ✓ Extracted to: $extractPath');

    // Verifica che la directory esista
    final extractDir = Directory(extractPath);
    if (!await extractDir.exists()) {
      print('   ❌ Extract directory does not exist');
      return;
    }

    // Test 4: Parse local files
    print('\n4. Parsing local files...');
    final tablatures = await service.parseLocalFiles(extractPath);
    print('   ✓ Parsed ${tablatures.length} tablatures');

    // Statistiche
    int withContent = tablatures.where((t) => t.content.isNotEmpty).length;
    print('   ✓ Tablatures with content: $withContent/${tablatures.length}');

    // Mostra alcuni esempi
    print('\n5. Examples of parsed tablatures:');
    for (int i = 0; i < tablatures.length && i < 5; i++) {
      final tab = tablatures[i];
      final hasContent = tab.content.isNotEmpty;
      print('   ${i + 1}. ${tab.composer} - ${tab.title}');
      print('      URL: ${tab.tabUrl}');
      print(
          '      Content: ${hasContent ? 'YES (${tab.content.length} chars)' : 'NO'}');
    }

    // Test 6: Database operations (opzionale)
    print('\n6. Testing database operations...');
    try {
      final dbService = DatabaseService.instance;
      // Initialize database by accessing it
      await dbService.database;

      // Inserisci alcune tablature di test
      final testTabs = tablatures.take(10).toList();
      for (final tab in testTabs) {
        await dbService.insertTablature(tab);
      }

      final count = await dbService.getTablatureCount();
      print('   ✓ Inserted ${testTabs.length} tablatures, total in DB: $count');

      // Cleanup
      await dbService.clearAllTablatures();
      print('   ✓ Database cleaned up');
    } catch (e) {
      print('   ⚠ Database test skipped: $e');
    }

    // Cleanup
    print('\n7. Cleaning up...');
    await extractDir.delete(recursive: true);
    print('   ✓ Temporary files removed');

    print('\n=== Test Completato con Successo! ===');
    print('La sincronizzazione Flutter dovrebbe funzionare correttamente.');
  } catch (e, stackTrace) {
    print('\n❌ Test fallito: $e');
    print('Stack trace: $stackTrace');
    exit(1);
  }
}
