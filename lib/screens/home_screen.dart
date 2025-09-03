import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:classtab_catalog/providers/tablature_provider.dart';
import 'package:classtab_catalog/screens/search_screen.dart';
import 'package:classtab_catalog/screens/favorites_screen.dart';
import 'package:classtab_catalog/screens/composers_screen.dart';
import 'package:classtab_catalog/screens/settings_screen.dart';
import 'package:classtab_catalog/widgets/tablature_card.dart';
import 'package:classtab_catalog/widgets/statistics_card.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('ClassTab Catalog'),
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
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Icon(Icons.sync),
                onPressed: provider.isLoading
                    ? null
                    : () => _showSyncDialog(context),
                tooltip: 'Sincronizza con ClassTab.org',
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: PageView(
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
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Cerca',
          ),
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.accountMusic),
            label: 'Compositori',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Preferiti',
          ),
        ],
      ),
    );
  }

  void _showSyncDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sincronizzazione'),
          content: const Text(
            'Vuoi sincronizzare le tablature con ClassTab.org? '
            'Questo scaricherà tutti i dati più recenti (circa 13MB).',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annulla'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<TablatureProvider>().syncWithClassTab();
              },
              child: const Text('Sincronizza'),
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
    return Consumer<TablatureProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SpinKitWave(
                  color: Color(0xFF8D6E63),
                  size: 50.0,
                ),
                SizedBox(height: 16),
                Text('Caricamento tablature...'),
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
                  child: const Text('Riprova'),
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
                const Text(
                  'Nessuna tablatura trovata',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Sincronizza con ClassTab.org per scaricare le tablature',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => provider.syncWithClassTab(),
                  icon: const Icon(Icons.sync),
                  label: const Text('Sincronizza ora'),
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
                      const Text(
                        'Tablature Recenti',
                        style: TextStyle(
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
                          // Naviga alla schermata di ricerca
                          DefaultTabController.of(context)!.animateTo(1);
                        },
                        icon: const Icon(Icons.list),
                        label: Text(
                          'Vedi tutte le ${provider.totalCount} tablature',
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