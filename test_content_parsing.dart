import 'package:classtab_catalog/models/tablature_content.dart';

void main() {
  final String sampleContent = '''
Questo è un esempio di tablatura per chitarra classica.
Compositore: Johann Sebastian Bach
Opus: BWV 999 - Preludio in Do minore

Istruzioni per l'esecuzione:
- Tempo moderato
- Attenzione alle dinamiche

E|--0-----3-----0-----3-----|
B|----1-----1-----1-----1---|
G|------0-----0-----0-----0-|
D|--------------------------|
A|--------------------------|
E|--------------------------|

E|--3-----0-----3-----0-----|
B|----1-----1-----1-----1---|
G|------0-----0-----0-----0-|
D|--------------------------|
A|--------------------------|
E|--------------------------|

Note finali:
- Questa è una trascrizione semplificata
- Per la versione completa consultare l'edizione Urtext
''';

  print('=== TEST PARSING CONTENUTO TABLATURA ===\n');

  final parsed = TablatureContent.parse(sampleContent);

  print('Ha introduzione: ${parsed.hasIntroduction}');
  print('Ha tablatura: ${parsed.hasTablature}');
  print('Ha footer: ${parsed.hasFooter}');

  print('\n--- INTRODUZIONE ---');
  print(parsed.introduction);

  print('\n--- TABLATURA ---');
  print(parsed.tablature);

  print('\n--- FOOTER ---');
  print(parsed.footer);

  print('\n=== FINE TEST ===');
}
