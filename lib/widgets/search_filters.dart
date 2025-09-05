import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:classtab_catalog/providers/tablature_provider.dart';
import 'package:classtab_catalog/generated/l10n/app_localizations.dart';

class SearchFilters extends StatelessWidget {
  const SearchFilters({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Consumer<TablatureProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Composer filter
            Text(
              l10n.composer,
              style: const TextStyle(
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
                  hint: Text(l10n.allComposers),
                  isExpanded: true,
                  items: [
                    DropdownMenuItem<String>(
                      value: '',
                      child: Text(l10n.allComposers),
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

            // Quick filters
            Text(
              l10n.quickFilters,
              style: const TextStyle(
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
                  label: l10n.withMidi,
                  icon: Icons.music_note,
                  onTap: () => _showFilteredResults(context, 'midi'),
                ),
                _buildFilterChip(
                  context,
                  label: l10n.withLhf,
                  icon: Icons.pan_tool,
                  onTap: () => _showFilteredResults(context, 'lhf'),
                ),
                _buildFilterChip(
                  context,
                  label: l10n.withVideo,
                  icon: Icons.play_circle_outline,
                  onTap: () => _showFilteredResults(context, 'video'),
                ),
                _buildFilterChip(
                  context,
                  label: l10n.easyTablatures,
                  icon: Icons.star_outline,
                  onTap: () => _showFilteredResults(context, 'easy'),
                ),
                _buildFilterChip(
                  context,
                  label: l10n.favorites,
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
    final l10n = AppLocalizations.of(context)!;

    // Implement specific filter logic
    switch (filter) {
      case 'midi':
        // Filter for tablatures with MIDI
        provider.search(''); // Reset search
        // Here you should implement a specific filter for MIDI
        break;
      case 'lhf':
        // Filter for tablatures with LHF
        provider.search(''); // Reset search
        // Here you should implement a specific filter for LHF
        break;
      case 'video':
        // Filter for tablatures with video
        provider.search(''); // Reset search
        // Here you should implement a specific filter for video
        break;
      case 'easy':
        // Filter for easy tablatures
        provider.search(''); // Reset search
        // Here you should implement a specific filter for difficulty
        break;
    }

    // Show a message or navigate to a filtered screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.filterApplied(filter)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showFavorites(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Navigate to favorites screen
    // This should be handled by the main navigation controller
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.goToFavoritesTab),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
