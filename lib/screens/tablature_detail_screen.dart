import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:classtab_catalog/models/tablature.dart';
import 'package:classtab_catalog/providers/tablature_provider.dart';
import 'package:classtab_catalog/providers/youtube_provider.dart';

import 'package:classtab_catalog/widgets/midi_player_widget.dart';
import 'package:classtab_catalog/widgets/enhanced_tablature_viewer.dart';
import 'package:classtab_catalog/widgets/floating_youtube_player.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class TablatureDetailScreen extends StatefulWidget {
  final Tablature tablature;

  const TablatureDetailScreen({
    super.key,
    required this.tablature,
  });

  @override
  State<TablatureDetailScreen> createState() => _TablatureDetailScreenState();
}

class _TablatureDetailScreenState extends State<TablatureDetailScreen> {
  String? _tablatureContent;
  bool _isLoading = false;
  String? _error;
  double _fontSize = 14.0;
  bool _showLineNumbers = false;

  @override
  void initState() {
    super.initState();
    _loadTablatureContent();
  }

  Future<void> _loadTablatureContent() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final content = await context
          .read<TablatureProvider>()
          .getTablatureContent(widget.tablature);

      setState(() {
        _tablatureContent = content;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.tablature.displayTitle,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          // Pulsante YouTube
          Consumer<YouTubeProvider>(
            builder: (context, youtubeProvider, child) {
              return IconButton(
                icon: Icon(
                  Icons.play_circle_outline,
                  color: youtubeProvider.hasVideo(widget.tablature)
                      ? Colors.red
                      : Colors.grey,
                ),
                onPressed: youtubeProvider.isLoading
                    ? null
                    : () => youtubeProvider.openYouTubePlayer(widget.tablature),
                tooltip: 'Apri video YouTube',
              );
            },
          ),

          // Pulsante preferiti
          Consumer<TablatureProvider>(
            builder: (context, provider, child) {
              return IconButton(
                icon: Icon(
                  widget.tablature.isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: widget.tablature.isFavorite ? Colors.red : null,
                ),
                onPressed: () {
                  provider.toggleFavorite(widget.tablature);
                },
              );
            },
          ),

          // Menu opzioni
          PopupMenuButton<String>(
            onSelected: _handleMenuAction,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'share',
                child: Row(
                  children: [
                    Icon(Icons.share),
                    SizedBox(width: 8),
                    Text('Condividi'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'open_web',
                child: Row(
                  children: [
                    Icon(Icons.open_in_browser),
                    SizedBox(width: 8),
                    Text('Apri nel browser'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'line_numbers',
                child: Row(
                  children: [
                    Icon(_showLineNumbers
                        ? Icons.format_list_numbered
                        : Icons.format_list_numbered_rtl),
                    const SizedBox(width: 8),
                    Text(
                        _showLineNumbers ? 'Nascondi numeri' : 'Mostra numeri'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          // Contenuto principale
          Column(
            children: [
              // Informazioni sulla tablatura
              _buildTablatureInfo(),

              // Player MIDI (se disponibile)
              if (widget.tablature.hasMidi && widget.tablature.midiUrl != null)
                MidiPlayerWidget(
                  midiUrl: widget.tablature.midiUrl!,
                  tablature: widget.tablature,
                ),

              // Contenuto della tablatura
              Expanded(
                child: _buildTablatureContent(),
              ),
            ],
          ),

          // Player YouTube fluttuante
          Consumer<YouTubeProvider>(
            builder: (context, youtubeProvider, child) {
              if (youtubeProvider.isPlayerVisible &&
                  youtubeProvider.currentVideoId != null) {
                return FloatingYouTubePlayer(
                  videoId: youtubeProvider.currentVideoId!,
                  title: youtubeProvider.currentVideoTitle ?? 'Video YouTube',
                  onClose: () => youtubeProvider.closeYouTubePlayer(),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTablatureInfo() {
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
          // Compositore
          Text(
            widget.tablature.composer,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),

          const SizedBox(height: 8),

          // Features e informazioni
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              if (widget.tablature.key != null)
                _buildInfoChip(
                  icon: MdiIcons.musicClefTreble,
                  label: 'Tonalità: ${widget.tablature.key}',
                  color: Colors.blue,
                ),
              if (widget.tablature.difficulty != null)
                _buildInfoChip(
                  icon: Icons.star_outline,
                  label: widget.tablature.difficultyDisplay,
                  color: _getDifficultyColor(widget.tablature.difficulty!),
                ),
              ...widget.tablature.features
                  .map((feature) => _buildFeatureChip(feature)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTablatureContent() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Caricamento tablatura...'),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[300],
            ),
            const SizedBox(height: 16),
            Text(
              'Errore nel caricamento',
              style: TextStyle(
                fontSize: 18,
                color: Colors.red[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadTablatureContent,
              child: const Text('Riprova'),
            ),
          ],
        ),
      );
    }

    if (_tablatureContent == null || _tablatureContent!.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.description,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'Contenuto non disponibile',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      );
    }

    return EnhancedTablatureViewer(
      content: _tablatureContent!,
      initialFontSize: _fontSize,
      showLineNumbers: _showLineNumbers,
      onFontSizeChanged: (newSize) {
        setState(() {
          _fontSize = newSize;
        });
      },
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

  void _handleMenuAction(String action) {
    switch (action) {
      case 'share':
        _shareTablature();
        break;
      case 'open_web':
        _openInBrowser();
        break;
      case 'line_numbers':
        setState(() {
          _showLineNumbers = !_showLineNumbers;
        });
        break;
    }
  }

  void _shareTablature() {
    // Implementa la condivisione
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Funzione di condivisione non ancora implementata')),
    );
  }

  void _openInBrowser() async {
    final url = Uri.parse(widget.tablature.tabUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Impossibile aprire il link')),
        );
      }
    }
  }
}
