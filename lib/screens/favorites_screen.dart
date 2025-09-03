import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:classtab_catalog/providers/tablature_provider.dart';
import 'package:classtab_catalog/widgets/tablature_card.dart';
import 'package:classtab_catalog/models/tablature.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Tablature> _favorites = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final favorites = await context.read<TablatureProvider>().getFavorites();
      setState(() {
        _favorites = favorites;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Errore nel caricamento dei preferiti: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _loadFavorites,
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_favorites.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            const Text(
              'Nessun preferito',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Aggiungi tablature ai preferiti per vederle qui',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                // Naviga alla schermata di ricerca
                DefaultTabController.of(context)!.animateTo(1);
              },
              icon: const Icon(Icons.search),
              label: const Text('Esplora tablature'),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Header con statistiche
        Container(
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
          child: Row(
            children: [
              Icon(
                Icons.favorite,
                color: Colors.red,
              ),
              const SizedBox(width: 8),
              Text(
                '${_favorites.length} Preferiti',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              if (_favorites.isNotEmpty)
                TextButton.icon(
                  onPressed: _showClearDialog,
                  icon: const Icon(Icons.clear_all, size: 16),
                  label: const Text('Pulisci tutto'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                ),
            ],
          ),
        ),

        // Lista dei preferiti
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _favorites.length,
            itemBuilder: (context, index) {
              final tablature = _favorites[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Consumer<TablatureProvider>(
                  builder: (context, provider, child) {
                    return TablatureCard(
                      tablature: tablature,
                      // Aggiorna la lista quando i preferiti cambiano
                      key: ValueKey('${tablature.id}_${tablature.isFavorite}'),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showClearDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Rimuovi tutti i preferiti'),
          content: const Text(
            'Sei sicuro di voler rimuovere tutte le tablature dai preferiti? '
            'Questa azione non può essere annullata.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annulla'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _clearAllFavorites();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Rimuovi tutto'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _clearAllFavorites() async {
    try {
      final provider = context.read<TablatureProvider>();
      
      // Rimuovi tutti i preferiti
      for (final tablature in _favorites) {
        await provider.toggleFavorite(tablature);
      }
      
      // Ricarica la lista
      await _loadFavorites();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tutti i preferiti sono stati rimossi'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Errore nella rimozione dei preferiti: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}