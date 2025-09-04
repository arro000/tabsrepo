import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:classtab_catalog/models/tablature.dart';
import 'package:classtab_catalog/providers/tablature_provider.dart';
import 'package:classtab_catalog/providers/youtube_provider.dart';

import 'package:classtab_catalog/widgets/midi_player_widget.dart';
import 'package:classtab_catalog/widgets/enhanced_tablature_viewer.dart';
import 'package:classtab_catalog/widgets/floating_youtube_player.dart';
import 'package:classtab_catalog/widgets/youtube_button.dart';
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
  double _fontSize = 8.0;
  bool _showLineNumbers = false;

  // Controlli per la visibilità dei widget fluttuanti
  bool _showFloatingControls = true;
  final ScrollController _scrollController = ScrollController();
  double _lastScrollOffset = 0.0;

  // Stati per i widget modali
  bool _showMidiPlayer = false;
  bool _showYouTubePlayer = false;
  bool _isFullscreen = false;
  bool _showAutoScrollControls = false;

  // Controllo auto-scroll
  final GlobalKey<EnhancedTablatureViewerState> _tablatureViewerKey =
      GlobalKey();
  bool _isAutoScrolling = false;
  double _autoScrollSpeed = 1.0;

  @override
  void initState() {
    super.initState();
    _loadTablatureContent();
    _setupScrollListener();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      final currentOffset = _scrollController.offset;
      final isScrollingDown = currentOffset > _lastScrollOffset;
      final scrollDelta = (currentOffset - _lastScrollOffset).abs();

      // Solo reagire a scroll significativi per evitare flickering
      if (scrollDelta < 5) return;

      // Nascondi i controlli quando si scrolla verso il basso
      // Mostrali quando si scrolla verso l'alto o si è in cima
      final shouldShowControls = !isScrollingDown || currentOffset <= 100;

      if (shouldShowControls != _showFloatingControls) {
        setState(() {
          _showFloatingControls = shouldShowControls;
        });
      }

      _lastScrollOffset = currentOffset;
    });
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
      appBar: _isFullscreen
          ? null
          : AppBar(
              title: Text(
                widget.tablature.displayTitle,
                overflow: TextOverflow.ellipsis,
              ),
              actions: [
                // Pulsante YouTube compatto
                YouTubeButton(
                  tablature: widget.tablature,
                  isCompact: true,
                  showLabel: false,
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
                          Text(_showLineNumbers
                              ? 'Nascondi numeri'
                              : 'Mostra numeri'),
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
              // Informazioni sulla tablatura (nascoste in fullscreen)
              if (!_isFullscreen) _buildTablatureInfo(),

              // Contenuto della tablatura
              Expanded(
                child: _buildTablatureContent(),
              ),
            ],
          ),

          // Controlli fluttuanti compatti
          if (_showFloatingControls) _buildFloatingControls(),

          // Widget modali
          if (_showMidiPlayer) _buildMidiPlayerModal(),
          if (_showYouTubePlayer) _buildYouTubeModal(),
          if (_showAutoScrollControls) _buildAutoScrollModal(),

          // Player YouTube fluttuante (esistente)
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
            color: Colors.black.withValues(alpha: 0.1),
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
      key: _tablatureViewerKey,
      content: _tablatureContent!,
      initialFontSize: _fontSize,
      showLineNumbers: _showLineNumbers,
      scrollController: _scrollController,
      onFontSizeChanged: (newSize) {
        setState(() {
          _fontSize = newSize;
        });
      },
      onAutoScrollStateChanged: (isScrolling) {
        setState(() {
          _isAutoScrolling = isScrolling;
        });
      },
      onAutoScrollSpeedChanged: (speed) {
        setState(() {
          _autoScrollSpeed = speed;
        });
      },
    );
  }

  Widget _buildFloatingControls() {
    return Positioned(
      bottom: 20,
      left: 20,
      right: 20,
      child: AnimatedSlide(
        offset: _showFloatingControls ? Offset.zero : const Offset(0, 1),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: AnimatedOpacity(
          opacity: _showFloatingControls ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Pulsante MIDI Player
                if (widget.tablature.hasMidi &&
                    widget.tablature.midiUrl != null)
                  _buildControlButton(
                    icon: Icons.music_note,
                    isActive: _showMidiPlayer,
                    onTap: () =>
                        setState(() => _showMidiPlayer = !_showMidiPlayer),
                    tooltip: 'Player MIDI',
                  ),

                // Pulsante YouTube
                _buildControlButton(
                  icon: Icons.play_circle_outline,
                  isActive: _showYouTubePlayer,
                  onTap: () =>
                      setState(() => _showYouTubePlayer = !_showYouTubePlayer),
                  tooltip: 'YouTube',
                ),

                // Pulsante Fullscreen
                _buildControlButton(
                  icon:
                      _isFullscreen ? Icons.fullscreen_exit : Icons.fullscreen,
                  isActive: _isFullscreen,
                  onTap: () => setState(() => _isFullscreen = !_isFullscreen),
                  tooltip: _isFullscreen
                      ? 'Esci da schermo intero'
                      : 'Schermo intero',
                ),

                // Pulsante Auto-scroll
                _buildControlButton(
                  icon: Icons.speed,
                  isActive: _showAutoScrollControls,
                  onTap: () => setState(
                      () => _showAutoScrollControls = !_showAutoScrollControls),
                  tooltip: 'Auto-scroll',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isActive
                ? Theme.of(context).primaryColor.withValues(alpha: 0.2)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            icon,
            color: isActive
                ? Theme.of(context).primaryColor
                : Theme.of(context).iconTheme.color,
            size: 20,
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
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
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

  Widget _buildMidiPlayerModal() {
    if (!widget.tablature.hasMidi || widget.tablature.midiUrl == null) {
      return const SizedBox.shrink();
    }

    return Positioned(
      bottom: 90,
      left: 16,
      right: 16,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: MidiPlayerWidget(
          midiUrl: widget.tablature.midiUrl!,
          tablature: widget.tablature,
        ),
      ),
    );
  }

  Widget _buildYouTubeModal() {
    return Positioned(
      bottom: 90,
      left: 16,
      right: 16,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: YouTubeButton(
          tablature: widget.tablature,
          isCompact: false,
          showLabel: true,
        ),
      ),
    );
  }

  Widget _buildAutoScrollModal() {
    return Positioned(
      bottom: 90,
      left: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(
                  Icons.speed,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Controlli Auto-scroll',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Pulsante Start/Stop
                ElevatedButton.icon(
                  onPressed: () {
                    if (_isAutoScrolling) {
                      _tablatureViewerKey.currentState?.stopAutoScroll();
                    } else {
                      _tablatureViewerKey.currentState?.startAutoScroll();
                    }
                  },
                  icon: Icon(_isAutoScrolling ? Icons.pause : Icons.play_arrow),
                  label: Text(_isAutoScrolling ? 'Pausa' : 'Avvia'),
                ),

                // Pulsante velocità lenta
                IconButton(
                  onPressed: () {
                    _tablatureViewerKey.currentState?.decreaseAutoScrollSpeed();
                  },
                  icon: const Icon(Icons.remove),
                  tooltip: 'Rallenta',
                ),

                // Indicatore velocità
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${(_autoScrollSpeed * 100).toInt()}%',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),

                // Pulsante velocità veloce
                IconButton(
                  onPressed: () {
                    _tablatureViewerKey.currentState?.increaseAutoScrollSpeed();
                  },
                  icon: const Icon(Icons.add),
                  tooltip: 'Accelera',
                ),

                // Pulsante stop
                IconButton(
                  onPressed: () {
                    _tablatureViewerKey.currentState?.stopAutoScroll();
                  },
                  icon: const Icon(Icons.stop),
                  tooltip: 'Stop',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
