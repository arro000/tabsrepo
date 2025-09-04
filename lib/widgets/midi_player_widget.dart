import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:classtab_catalog/providers/midi_provider.dart';
import 'package:classtab_catalog/models/tablature.dart';
import 'package:classtab_catalog/widgets/youtube_button.dart';

class MidiPlayerWidget extends StatelessWidget {
  final String midiUrl;
  final Tablature? tablature;

  const MidiPlayerWidget({
    super.key,
    required this.midiUrl,
    this.tablature,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<MidiProvider>(
      builder: (context, midiProvider, child) {
        final isCurrentTrack = midiProvider.currentMidiUrl == midiUrl;

        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              // Titolo del player
              Row(
                children: [
                  Icon(
                    Icons.music_note,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Player MIDI',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),

                  // Bottone YouTube (se tablatura disponibile)
                  if (tablature != null)
                    YouTubeButton(
                      tablature: tablature!,
                      isCompact: true,
                      showLabel: false,
                    ),

                  if (midiProvider.isLoading && isCurrentTrack)
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                ],
              ),

              const SizedBox(height: 16),

              // Controlli di riproduzione
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Pulsante play/pause
                  IconButton(
                    iconSize: 48,
                    onPressed: midiProvider.isLoading
                        ? null
                        : () => _handlePlayPause(
                            context, midiProvider, isCurrentTrack),
                    icon: Icon(
                      _getPlayButtonIcon(midiProvider, isCurrentTrack),
                      color: Theme.of(context).primaryColor,
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Pulsante stop
                  IconButton(
                    onPressed: (isCurrentTrack &&
                            !midiProvider.state.name.contains('stopped'))
                        ? () => midiProvider.stopMidi()
                        : null,
                    icon: const Icon(Icons.stop),
                  ),

                  const SizedBox(width: 16),

                  // Pulsante loop
                  IconButton(
                    onPressed: () => midiProvider.toggleLoop(),
                    icon: Icon(
                      Icons.repeat,
                      color: midiProvider.isLooping
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                    ),
                  ),
                ],
              ),

              // Barra di progresso
              if (isCurrentTrack && midiProvider.duration > 0) ...[
                const SizedBox(height: 16),
                _buildProgressBar(midiProvider),
              ],

              // Controlli volume e tempo
              if (isCurrentTrack) ...[
                const SizedBox(height: 16),
                _buildVolumeAndTempoControls(midiProvider),
              ],

              // Messaggio di errore
              if (midiProvider.errorMessage.isNotEmpty && isCurrentTrack) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline,
                          color: Colors.red, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          midiProvider.errorMessage,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  IconData _getPlayButtonIcon(MidiProvider midiProvider, bool isCurrentTrack) {
    if (!isCurrentTrack || midiProvider.state == MidiPlayerState.stopped) {
      return Icons.play_circle_filled;
    }

    switch (midiProvider.state) {
      case MidiPlayerState.playing:
        return Icons.pause_circle_filled;
      case MidiPlayerState.paused:
        return Icons.play_circle_filled;
      case MidiPlayerState.loading:
        return Icons.hourglass_empty;
      case MidiPlayerState.error:
        return Icons.error;
      default:
        return Icons.play_circle_filled;
    }
  }

  void _handlePlayPause(
      BuildContext context, MidiProvider midiProvider, bool isCurrentTrack) {
    if (!isCurrentTrack || midiProvider.state == MidiPlayerState.stopped) {
      midiProvider.playMidi(midiUrl);
    } else if (midiProvider.state == MidiPlayerState.playing) {
      midiProvider.pauseMidi();
    } else if (midiProvider.state == MidiPlayerState.paused) {
      midiProvider.resumeMidi();
    }
  }

  Widget _buildProgressBar(MidiProvider midiProvider) {
    return Column(
      children: [
        // Barra di progresso
        Builder(
          builder: (context) => SliderTheme(
            data: SliderTheme.of(context).copyWith(
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              trackHeight: 4,
            ),
            child: Slider(
              value: midiProvider.position.clamp(0.0, midiProvider.duration),
              max: midiProvider.duration,
              onChanged: (value) {
                midiProvider.seekTo(value);
              },
            ),
          ),
        ),

        // Tempi
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatTime(midiProvider.position),
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                _formatTime(midiProvider.duration),
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVolumeAndTempoControls(MidiProvider midiProvider) {
    return Row(
      children: [
        // Controllo volume
        Expanded(
          child: Row(
            children: [
              const Icon(Icons.volume_up, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Builder(
                  builder: (context) => SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      thumbShape:
                          const RoundSliderThumbShape(enabledThumbRadius: 4),
                      trackHeight: 2,
                    ),
                    child: Slider(
                      value: midiProvider.volume,
                      onChanged: (value) {
                        midiProvider.setVolume(value);
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 16),

        // Controllo tempo
        Expanded(
          child: Row(
            children: [
              const Icon(Icons.speed, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Builder(
                  builder: (context) => SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      thumbShape:
                          const RoundSliderThumbShape(enabledThumbRadius: 4),
                      trackHeight: 2,
                    ),
                    child: Slider(
                      value: midiProvider.tempo,
                      min: 0.5,
                      max: 2.0,
                      divisions: 15,
                      onChanged: (value) {
                        midiProvider.setTempo(value);
                      },
                    ),
                  ),
                ),
              ),
              Text(
                '${(midiProvider.tempo * 100).toInt()}%',
                style: const TextStyle(fontSize: 10),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatTime(double seconds) {
    final minutes = (seconds / 60).floor();
    final remainingSeconds = (seconds % 60).floor();
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
