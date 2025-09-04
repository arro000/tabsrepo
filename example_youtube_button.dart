import 'package:flutter/material.dart';
import 'package:classtab_catalog/widgets/youtube_button.dart';
import 'package:classtab_catalog/models/tablature.dart';

void main() {
  runApp(const YouTubeButtonExample());
}

class YouTubeButtonExample extends StatelessWidget {
  const YouTubeButtonExample({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YouTube Button Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const YouTubeButtonDemo(),
    );
  }
}

class YouTubeButtonDemo extends StatelessWidget {
  const YouTubeButtonDemo({super.key});

  @override
  Widget build(BuildContext context) {
    // Esempio di tablatura per il test
    final sampleTablature = Tablature(
      id: 1,
      title: 'Asturias',
      composer: 'Isaac Albéniz',
      difficulty: 'Avanzato',
      url: 'https://example.com/asturias.tab',
      midiUrl: 'https://example.com/asturias.mid',
      hasMidi: true,
      isFavorite: false,
      lastAccessed: DateTime.now(),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('YouTube Button Demo'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bottone YouTube Esteso:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Bottone YouTube esteso
            YouTubeButton(
              tablature: sampleTablature,
              isCompact: false,
              showLabel: true,
            ),

            const SizedBox(height: 32),

            const Text(
              'Bottone YouTube Compatto:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Bottone YouTube compatto
            Row(
              children: [
                YouTubeButton(
                  tablature: sampleTablature,
                  isCompact: true,
                  showLabel: false,
                ),
                const SizedBox(width: 16),
                const Text('Versione compatta per le card'),
              ],
            ),

            const SizedBox(height: 32),

            const Text(
              'Caratteristiche del nuovo bottone:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('• Design moderno con gradiente'),
                Text('• Versione estesa con testo descrittivo'),
                Text('• Versione compatta per spazi ridotti'),
                Text('• Indicatore di caricamento integrato'),
                Text('• Colori diversi per video disponibili/non disponibili'),
                Text('• Effetto Material Design con elevazione'),
                Text('• Tooltip informativi'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
