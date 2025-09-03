import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:classtab_catalog/models/tablature.dart';
import 'package:classtab_catalog/providers/tablature_provider.dart';
import 'package:classtab_catalog/providers/midi_provider.dart';
import 'package:classtab_catalog/screens/tablature_detail_screen.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class TablatureCard extends StatelessWidget {
  final Tablature tablature;
  final String? highlightQuery;

  const TablatureCard({
    super.key,
    required this.tablature,
    this.highlightQuery,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TablatureDetailScreen(tablature: tablature),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con titolo e azioni
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Titolo
                        Text(
                          _highlightText(tablature.displayTitle, highlightQuery),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        
                        // Compositore
                        Text(
                          _highlightText(tablature.composer, highlightQuery),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Azioni
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Pulsante MIDI
                      if (tablature.hasMidi)
                        Consumer<MidiProvider>(
                          builder: (context, midiProvider, child) {
                            final isCurrentlyPlaying = 
                                midiProvider.currentMidiUrl == tablature.midiUrl &&
                                midiProvider.isPlaying;
                            
                            return IconButton(
                              icon: Icon(
                                isCurrentlyPlaying 
                                    ? Icons.pause_circle_filled
                                    : Icons.play_circle_filled,
                                color: Theme.of(context).primaryColor,
                              ),
                              onPressed: tablature.midiUrl != null
                                  ? () {
                                      if (isCurrentlyPlaying) {
                                        midiProvider.pauseMidi();
                                      } else {
                                        midiProvider.playMidi(tablature.midiUrl!);
                                      }
                                    }
                                  : null,
                              tooltip: isCurrentlyPlaying ? 'Pausa' : 'Riproduci MIDI',
                            );
                          },
                        ),
                      
                      // Pulsante preferiti
                      Consumer<TablatureProvider>(
                        builder: (context, provider, child) {
                          return IconButton(
                            icon: Icon(
                              tablature.isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: tablature.isFavorite
                                  ? Colors.red
                                  : Colors.grey,
                            ),
                            onPressed: () {
                              provider.toggleFavorite(tablature);
                            },
                            tooltip: tablature.isFavorite
                                ? 'Rimuovi dai preferiti'
                                : 'Aggiungi ai preferiti',
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Informazioni aggiuntive
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  // Tonalità
                  if (tablature.key != null)
                    _buildInfoChip(
                      icon: MdiIcons.musicClefTreble,
                      label: tablature.key!,
                      color: Colors.blue,
                    ),
                  
                  // Difficoltà
                  if (tablature.difficulty != null)
                    _buildInfoChip(
                      icon: _getDifficultyIcon(tablature.difficulty!),
                      label: tablature.difficultyDisplay,
                      color: _getDifficultyColor(tablature.difficulty!),
                    ),
                  
                  // Features
                  ...tablature.features.map((feature) => _buildFeatureChip(feature)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureChip(String feature) {
    IconData icon;
    Color color;
    
    switch (feature) {
      case 'MIDI':
        icon = MdiIcons.musicNote;
        color = Colors.green;
        break;
      case 'LHF':
        icon = MdiIcons.handPointingLeft;
        color = Colors.orange;
        break;
      case 'Video':
        icon = Icons.play_circle_outline;
        color = Colors.red;
        break;
      default:
        icon = Icons.info_outline;
        color = Colors.grey;
    }
    
    return _buildInfoChip(icon: icon, label: feature, color: color);
  }

  IconData _getDifficultyIcon(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Icons.star_outline;
      case 'intermediate':
        return Icons.star_half;
      case 'advanced':
        return Icons.star;
      default:
        return Icons.help_outline;
    }
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Colors.green;
      case 'intermediate':
        return Colors.orange;
      case 'advanced':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _highlightText(String text, String? query) {
    // Per ora restituisce il testo normale
    // In una implementazione completa, potresti usare RichText
    // per evidenziare i termini di ricerca
    return text;
  }
}