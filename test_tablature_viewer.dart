import 'package:flutter/material.dart';
import 'package:classtab_catalog/models/tablature_content.dart';
import 'package:classtab_catalog/widgets/enhanced_tablature_viewer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test Tablature Viewer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TestScreen(),
    );
  }
}

class TestScreen extends StatelessWidget {
  final String sampleContent = '''
Questo è un esempio di tablatura per chitarra classica.
Compositore: Johann Sebastian Bach
Opus: BWV 999 - Preludio in Do minore

Istruzioni per l'esecuzione:
- Tempo moderato
- Attenzione alle dinamiche
- Curare la legatura delle voci

E|--0-----3-----0-----3-----|--0-----3-----0-----3-----|
B|----1-----1-----1-----1---|----1-----1-----1-----1---|
G|------0-----0-----0-----0-|------0-----0-----0-----0-|
D|--------------------------|--------------------------|
A|--------------------------|--------------------------|
E|--------------------------|--------------------------|

E|--3-----0-----3-----0-----|--3-----0-----3-----0-----|
B|----1-----1-----1-----1---|----1-----1-----1-----1---|
G|------0-----0-----0-----0-|------0-----0-----0-----0-|
D|--------------------------|--------------------------|
A|--------------------------|--------------------------|
E|--------------------------|--------------------------|

E|--0-----3-----0-----3-----|--0-----3-----0-----3-----|
B|----1-----1-----1-----1---|----1-----1-----1-----1---|
G|------0-----0-----0-----0-|------0-----0-----0-----0-|
D|--------------------------|--------------------------|
A|--------------------------|--------------------------|
E|--------------------------|--------------------------|

Note finali:
- Questa è una trascrizione semplificata
- Per la versione completa consultare l'edizione Urtext
- Durata approssimativa: 2 minuti
- Font monospace garantisce allineamento perfetto
''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Enhanced Tablature Viewer'),
      ),
      body: EnhancedTablatureViewer(
        content: sampleContent,
        initialFontSize: 14.0,
        showLineNumbers: false,
      ),
    );
  }
}
