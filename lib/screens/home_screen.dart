import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:classtab_catalog/providers/tablature_provider.dart';
import 'package:classtab_catalog/providers/youtube_provider.dart';
import 'package:classtab_catalog/screens/search_screen.dart';
import 'package:classtab_catalog/screens/favorites_screen.dart';
import 'package:classtab_catalog/screens/composers_screen.dart';
import 'package:classtab_catalog/screens/settings_screen.dart';
import 'package:classtab_catalog/widgets/tablature_card.dart';
import 'package:classtab_catalog/widgets/statistics_card.dart';
import 'package:classtab_catalog/widgets/floating_youtube_player.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:classtab_catalog/generated/l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TablatureProvider>().loadTablatures();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          Consumer<TablatureProvider>(
            builder: (context, provider, child) {
              return IconButton(
                icon: provider.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Icon(Icons.sync),
                onPressed:
                    provider.isLoading ? null : () => _showSyncDialog(context),
                tooltip: l10n.syncWithClassTab,
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Contenuto principale
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            children: const [
              _HomeTab(),
              SearchScreen(),
              ComposersScreen(),
              FavoritesScreen(),
              SettingsScreen(),
            ],
          ),

          // Player YouTube fluttuante
          Consumer<YouTubeProvider>(
            builder: (context, youtubeProvider, child) {
              if (youtubeProvider.isPlayerVisible &&
                  youtubeProvider.currentVideoId != null) {
                return FloatingYouTubePlayer(
                  videoId: youtubeProvider.currentVideoId!,
                  title: youtubeProvider.currentVideoTitle ?? l10n.youTubeVideo,
                  onClose: () => youtubeProvider.closeYouTubePlayer(),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: l10n.home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.search),
            label: l10n.search,
          ),
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.accountMusic),
            label: l10n.composers,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.favorite),
            label: l10n.favorites,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: l10n.settings,
          ),
        ],
      ),
    );
  }

  void _showSyncDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l10n.synchronization),
          content: Text(l10n.syncDialogContent),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<TablatureProvider>().syncWithClassTab();
              },
              child: Text(l10n.sync),
            ),
          ],
        );
      },
    );
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Consumer<TablatureProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SpinKitWave(
                  color: Color(0xFF8D6E63),
                  size: 50.0,
                ),
                const SizedBox(height: 16),
                Text(l10n.loadingTablatures),
              ],
            ),
          );
        }

        if (provider.errorMessage.isNotEmpty) {
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
                  provider.errorMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => provider.loadTablatures(),
                  child: Text(l10n.retry),
                ),
              ],
            ),
          );
        }

        if (provider.tablatures.isEmpty) {
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
                Text(
                  l10n.noTablaturesFound,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.syncToDownloadTablatures,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => provider.syncWithClassTab(),
                  icon: const Icon(Icons.sync),
                  label: Text(l10n.syncNow),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => provider.loadTablatures(),
          child: CustomScrollView(
            slivers: [
              // Statistiche
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: StatisticsCard(statistics: provider.getStatistics()),
                ),
              ),

              // Tablature recenti
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Icon(
                        MdiIcons.musicNoteEighth,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        l10n.recentTablatures,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 8)),

              // Lista delle tablature
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final tablature = provider.tablatures[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 4.0,
                      ),
                      child: TablatureCard(tablature: tablature),
                    );
                  },
                  childCount: provider.tablatures.length > 10
                      ? 10
                      : provider.tablatures.length,
                ),
              ),

              // Pulsante "Vedi tutte"
              if (provider.tablatures.length > 10)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: TextButton.icon(
                        onPressed: () {
                          // Navigate to search screen
                          DefaultTabController.of(context)!.animateTo(1);
                        },
                        icon: const Icon(Icons.list),
                        label: Text(
                          l10n.viewAllTablatures(provider.totalCount),
                        ),
                      ),
                    ),
                  ),
                ),

              // Spazio finale
              const SliverToBoxAdapter(child: SizedBox(height: 16)),
            ],
          ),
        );
      },
    );
  }
}
