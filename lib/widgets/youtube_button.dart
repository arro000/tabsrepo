import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:classtab_catalog/providers/youtube_provider.dart';
import 'package:classtab_catalog/models/tablature.dart';

class YouTubeButton extends StatelessWidget {
  final Tablature tablature;
  final bool isCompact;
  final bool showLabel;

  const YouTubeButton({
    super.key,
    required this.tablature,
    this.isCompact = false,
    this.showLabel = true,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<YouTubeProvider>(
      builder: (context, youtubeProvider, child) {
        final hasVideo = youtubeProvider.hasVideo(tablature);
        final isLoading = youtubeProvider.isLoading;

        if (isCompact) {
          // Versione compatta per le card
          return IconButton(
            icon: Icon(
              Icons.play_circle_outline,
              color: hasVideo ? Colors.red : Colors.grey[400],
            ),
            onPressed: isLoading
                ? null
                : () => youtubeProvider.openYouTubePlayer(tablature),
            tooltip: 'Apri video YouTube',
          );
        }

        // Versione estesa e isolata
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Material(
            elevation: 2,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: isLoading
                  ? null
                  : () => youtubeProvider.openYouTubePlayer(tablature),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: hasVideo
                        ? [Colors.red.shade400, Colors.red.shade600]
                        : [Colors.grey.shade300, Colors.grey.shade400],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      hasVideo ? Icons.play_circle_filled : Icons.search,
                      color: Colors.white,
                      size: 28,
                    ),
                    if (showLabel) ...[
                      const SizedBox(width: 12),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              hasVideo
                                  ? 'Guarda su YouTube'
                                  : 'Cerca su YouTube',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              hasVideo
                                  ? 'Video disponibile'
                                  : 'Cerca video per questa tablatura',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.9),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    if (isLoading) ...[
                      const SizedBox(width: 12),
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
