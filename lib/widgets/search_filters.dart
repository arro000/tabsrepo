import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:classtab_catalog/providers/tablature_provider.dart';

class SearchFilters extends StatelessWidget {
  const SearchFilters({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TablatureProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filtro per compositore
            const Text(
              'Compositore',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: provider.selectedComposer.isEmpty 
                      ? null 
                      : provider.selectedComposer,
                  hint: const Text('Tutti i compositori'),
                  isExpanded: true,
                  items: [
                    const DropdownMenuItem<String>(
                      value: '',
                      child: Text('Tutti i compositori'),
                    ),
                    ...provider.composers.map((composer) {
                      return DropdownMenuItem<String>(
                        value: composer,
                        child: Text(
                          composer,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }),
                  ],
                  onChanged: (value) {
                    provider.filterByComposer(value ?? '');
                  },
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Filtri rapidi
            const Text(
              'Filtri rapidi',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildFilterChip(
                  context,
                  label: 'Con MIDI',
                  icon: Icons.music_note,
                  onTap: () => _showFilteredResults(context, 'midi'),
                ),
                _buildFilterChip(
                  context,
                  label: 'Con LHF',
                  icon: Icons.pan_tool,
                  onTap: () => _showFilteredResults(context, 'lhf'),
                ),
                _buildFilterChip(
                  context,
                  label: 'Con Video',
                  icon: Icons.play_circle_outline,
                  onTap: () => _showFilteredResults(context, 'video'),
                ),
                _buildFilterChip(
                  context,
                  label: 'Facili',
                  icon: Icons.star_outline,
                  onTap: () => _showFilteredResults(context, 'easy'),
                ),
                _buildFilterChip(
                  context,
                  label: 'Preferiti',
                  icon: Icons.favorite,
                  onTap: () => _showFavorites(context),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildFilterChip(
    BuildContext context, {
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilteredResults(BuildContext context, String filter) {
    final provider = context.read<TablatureProvider>();
    
    // Implementa la logica di filtro specifica
    switch (filter) {
      case 'midi':
        // Filtra per tablature con MIDI
        provider.search(''); // Reset search
        // Qui dovresti implementare un filtro specifico per MIDI
        break;
      case 'lhf':
        // Filtra per tablature con LHF
        provider.search(''); // Reset search
        // Qui dovresti implementare un filtro specifico per LHF
        break;
      case 'video':
        // Filtra per tablature con video
        provider.search(''); // Reset search
        // Qui dovresti implementare un filtro specifico per video
        break;
      case 'easy':
        // Filtra per tablature facili
        provider.search(''); // Reset search
        // Qui dovresti implementare un filtro specifico per difficoltà
        break;
    }
    
    // Mostra un messaggio o naviga a una schermata filtrata
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Filtro "$filter" applicato'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showFavorites(BuildContext context) {
    // Naviga alla schermata dei preferiti
    // Questo dovrebbe essere gestito dal controller della navigazione principale
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Vai alla scheda Preferiti per vedere i tuoi preferiti'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}