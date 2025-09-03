import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class StatisticsCard extends StatelessWidget {
  final Map<String, int> statistics;

  const StatisticsCard({
    super.key,
    required this.statistics,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.analytics,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Statistiche',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Griglia delle statistiche
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 2.5,
              crossAxisSpacing: 16,
              mainAxisSpacing: 12,
              children: [
                _buildStatItem(
                  icon: MdiIcons.musicNote,
                  label: 'Totale',
                  value: statistics['total'] ?? 0,
                  color: Colors.blue,
                ),
                _buildStatItem(
                  icon: Icons.favorite,
                  label: 'Preferiti',
                  value: statistics['favorites'] ?? 0,
                  color: Colors.red,
                ),
                _buildStatItem(
                  icon: MdiIcons.musicNoteEighth,
                  label: 'Con MIDI',
                  value: statistics['withMidi'] ?? 0,
                  color: Colors.green,
                ),
                _buildStatItem(
                  icon: MdiIcons.handPointingLeft,
                  label: 'Con LHF',
                  value: statistics['withLhf'] ?? 0,
                  color: Colors.orange,
                ),
                _buildStatItem(
                  icon: Icons.play_circle_outline,
                  label: 'Con Video',
                  value: statistics['withVideo'] ?? 0,
                  color: Colors.purple,
                ),
                _buildStatItem(
                  icon: Icons.star_outline,
                  label: 'Facili',
                  value: statistics['easy'] ?? 0,
                  color: Colors.teal,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required int value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value.toString(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: color.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}