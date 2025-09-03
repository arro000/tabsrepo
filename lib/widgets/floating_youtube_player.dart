import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class FloatingYouTubePlayer extends StatefulWidget {
  final String videoId;
  final String title;
  final VoidCallback onClose;

  const FloatingYouTubePlayer({
    super.key,
    required this.videoId,
    required this.title,
    required this.onClose,
  });

  @override
  State<FloatingYouTubePlayer> createState() => _FloatingYouTubePlayerState();
}

class _FloatingYouTubePlayerState extends State<FloatingYouTubePlayer> {
  late YoutubePlayerController _controller;
  bool _isMinimized = false;
  bool _isAudioOnly = false;
  Offset _position = const Offset(20, 100);

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        enableCaption: false,
        loop: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _position.dx,
      top: _position.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _position = Offset(
              (_position.dx + details.delta.dx).clamp(
                0.0,
                MediaQuery.of(context).size.width - (_isMinimized ? 120 : 320),
              ),
              (_position.dy + details.delta.dy).clamp(
                0.0,
                MediaQuery.of(context).size.height - (_isMinimized ? 80 : 240),
              ),
            );
          });
        },
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: _isMinimized ? 120 : 320,
            height: _isMinimized ? 80 : 240,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(12),
            ),
            child: _isMinimized ? _buildMinimizedPlayer() : _buildFullPlayer(),
          ),
        ),
      ),
    );
  }

  Widget _buildFullPlayer() {
    return Column(
      children: [
        // Header con titolo e controlli
        Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: const BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          child: Row(
            children: [
              // Icona drag
              const Icon(
                Icons.drag_indicator,
                color: Colors.white54,
                size: 16,
              ),
              const SizedBox(width: 8),

              // Titolo
              Expanded(
                child: Text(
                  widget.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Pulsante audio only
              IconButton(
                icon: Icon(
                  _isAudioOnly ? Icons.videocam_off : Icons.videocam,
                  color: _isAudioOnly ? Colors.orange : Colors.white54,
                  size: 16,
                ),
                onPressed: () {
                  setState(() {
                    _isAudioOnly = !_isAudioOnly;
                  });
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 24,
                  minHeight: 24,
                ),
              ),

              // Pulsante minimizza
              IconButton(
                icon: const Icon(
                  Icons.minimize,
                  color: Colors.white54,
                  size: 16,
                ),
                onPressed: () {
                  setState(() {
                    _isMinimized = true;
                  });
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 24,
                  minHeight: 24,
                ),
              ),

              // Pulsante chiudi
              IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.white54,
                  size: 16,
                ),
                onPressed: widget.onClose,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 24,
                  minHeight: 24,
                ),
              ),
            ],
          ),
        ),

        // Player video
        Expanded(
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
            child: _isAudioOnly
                ? _buildAudioOnlyView()
                : YoutubePlayer(
                    controller: _controller,
                    showVideoProgressIndicator: true,
                    progressIndicatorColor: Colors.red,
                    progressColors: const ProgressBarColors(
                      playedColor: Colors.red,
                      handleColor: Colors.redAccent,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildMinimizedPlayer() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Drag handle
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(
              Icons.drag_indicator,
              color: Colors.white54,
              size: 16,
            ),
          ),

          // Play/Pause button
          Expanded(
            child: Center(
              child: IconButton(
                icon: Icon(
                  _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                  size: 24,
                ),
                onPressed: () {
                  if (_controller.value.isPlaying) {
                    _controller.pause();
                  } else {
                    _controller.play();
                  }
                },
              ),
            ),
          ),

          // Expand button
          IconButton(
            icon: const Icon(
              Icons.open_in_full,
              color: Colors.white54,
              size: 16,
            ),
            onPressed: () {
              setState(() {
                _isMinimized = false;
              });
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(
              minWidth: 24,
              minHeight: 24,
            ),
          ),

          // Close button
          IconButton(
            icon: const Icon(
              Icons.close,
              color: Colors.white54,
              size: 16,
            ),
            onPressed: widget.onClose,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(
              minWidth: 24,
              minHeight: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAudioOnlyView() {
    return Container(
      color: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.music_note,
            color: Colors.white54,
            size: 48,
          ),
          const SizedBox(height: 8),
          const Text(
            'Solo Audio',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.skip_previous,
                  color: Colors.white,
                ),
                onPressed: () {
                  _controller.seekTo(Duration.zero);
                },
              ),
              IconButton(
                icon: Icon(
                  _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                  size: 32,
                ),
                onPressed: () {
                  if (_controller.value.isPlaying) {
                    _controller.pause();
                  } else {
                    _controller.play();
                  }
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.skip_next,
                  color: Colors.white,
                ),
                onPressed: () {
                  // Implementa skip se necessario
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
