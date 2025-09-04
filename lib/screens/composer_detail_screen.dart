import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:classtab_catalog/providers/tablature_provider.dart';
import 'package:classtab_catalog/widgets/tablature_card.dart';
import 'package:classtab_catalog/models/tablature.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ComposerDetailScreen extends StatefulWidget {
  final String composer;

  const ComposerDetailScreen({
    super.key,
    required this.composer,
  });

  @override
  State<ComposerDetailScreen> createState() => _ComposerDetailScreenState();
}

class _ComposerDetailScreenState extends State<ComposerDetailScreen> {
  List<Tablature> _composerTablatures = [];
  bool _isLoading = false;
  String _sortBy = 'title'; // 'title', 'opus', 'difficulty'
  bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
    _loadComposerTablatures();
  }

  Future<void> _loadComposerTablatures() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final provider = context.read<TablatureProvider>();
      final tablatures = provider.tablatures
          .where((t) => t.composer == widget.composer)
          .toList();

      setState(() {
        _composerTablatures = tablatures;
        _isLoading = false;
      });

      _sortTablatures();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Errore nel caricamento: $e')),
        );
      }
    }
  }

  void _sortTablatures() {
    setState(() {
      _composerTablatures.sort((a, b) {
        int comparison = 0;

        switch (_sortBy) {
          case 'title':
            comparison = a.title.compareTo(b.title);
            break;
          case 'opus':
            final aOpus = a.opus ?? '';
            final bOpus = b.opus ?? '';
            comparison = aOpus.compareTo(bOpus);
            if (comparison == 0) {
              comparison = a.title.compareTo(b.title);
            }
            break;
          case 'difficulty':
            final aDiff = _getDifficultyOrder(a.difficulty);
            final bDiff = _getDifficultyOrder(b.difficulty);
            comparison = aDiff.compareTo(bDiff);
            if (comparison == 0) {
              comparison = a.title.compareTo(b.title);
            }
            break;
        }

        return _sortAscending ? comparison : -comparison;
      });
    });
  }

  int _getDifficultyOrder(String? difficulty) {
    switch (difficulty?.toLowerCase()) {
      case 'easy':
        return 1;
      case 'intermediate':
        return 2;
      case 'advanced':
        return 3;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.composer,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: _handleSortOption,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'title',
                child: Row(
                  children: [
                    Icon(
                        _sortBy == 'title' ? Icons.check : Icons.sort_by_alpha),
                    const SizedBox(width: 8),
                    const Text('Ordina per titolo'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'opus',
                child: Row(
                  children: [
                    Icon(_sortBy == 'opus'
                        ? Icons.check
                        : Icons.format_list_numbered),
                    const SizedBox(width: 8),
                    const Text('Ordina per opus'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'difficulty',
                child: Row(
                  children: [
                    Icon(_sortBy == 'difficulty'
                        ? Icons.check
                        : Icons.star_outline),
                    const SizedBox(width: 8),
                    const Text('Ordina per difficoltà'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                value: 'toggle_order',
                child: Row(
                  children: [
                    Icon(_sortAscending
                        ? Icons.arrow_upward
                        : Icons.arrow_downward),
                    const SizedBox(width: 8),
                    Text(_sortAscending ? 'Crescente' : 'Decrescente'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_composerTablatures.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              MdiIcons.musicNote,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            const Text(
              'Nessuna tablatura trovata',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'per ${widget.composer}',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Header con statistiche
        _buildStatsHeader(),

        // Lista delle tablature
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _composerTablatures.length,
            itemBuilder: (context, index) {
              final tablature = _composerTablatures[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: TablatureCard(tablature: tablature),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStatsHeader() {
    final stats = _calculateStats();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titolo e conteggio
          Row(
            children: [
              Icon(
                MdiIcons.accountMusic,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${_composerTablatures.length} tablature',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                'Ordinate per $_sortBy',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Statistiche rapide
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              if (stats['withMidi']! > 0)
                _buildStatChip(
                  icon: MdiIcons.musicNote,
                  label: '${stats['withMidi']} MIDI',
                  color: Colors.green,
                ),
              if (stats['withLhf']! > 0)
                _buildStatChip(
                  icon: MdiIcons.handPointingLeft,
                  label: '${stats['withLhf']} LHF',
                  color: Colors.orange,
                ),
              if (stats['withVideo']! > 0)
                _buildStatChip(
                  icon: Icons.play_circle_outline,
                  label: '${stats['withVideo']} Video',
                  color: Colors.red,
                ),
              if (stats['easy']! > 0)
                _buildStatChip(
                  icon: Icons.star_outline,
                  label: '${stats['easy']} Facili',
                  color: Colors.blue,
                ),
              if (stats['favorites']! > 0)
                _buildStatChip(
                  icon: Icons.favorite,
                  label: '${stats['favorites']} Preferiti',
                  color: Colors.pink,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip({
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

  Map<String, int> _calculateStats() {
    return {
      'total': _composerTablatures.length,
      'withMidi': _composerTablatures.where((t) => t.hasMidi).length,
      'withLhf': _composerTablatures.where((t) => t.hasLhf).length,
      'withVideo': _composerTablatures.where((t) => t.hasVideo).length,
      'easy': _composerTablatures.where((t) => t.difficulty == 'easy').length,
      'favorites': _composerTablatures.where((t) => t.isFavorite).length,
    };
  }

  void _handleSortOption(String option) {
    setState(() {
      if (option == 'toggle_order') {
        _sortAscending = !_sortAscending;
      } else {
        if (_sortBy == option) {
          _sortAscending = !_sortAscending;
        } else {
          _sortBy = option;
          _sortAscending = true;
        }
      }
      _sortTablatures();
    });
  }
}
