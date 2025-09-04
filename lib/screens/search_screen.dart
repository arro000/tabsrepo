import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:classtab_catalog/providers/tablature_provider.dart';
import 'package:classtab_catalog/widgets/tablature_card.dart';
import 'package:classtab_catalog/widgets/search_filters.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _showFilters = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Barra di ricerca
          Container(
            padding: const EdgeInsets.all(16.0),
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
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Cerca tablature, compositori, opus...',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    _searchController.clear();
                                    context
                                        .read<TablatureProvider>()
                                        .search('');
                                  },
                                )
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        onChanged: (value) {
                          context.read<TablatureProvider>().search(value);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: Icon(
                        _showFilters
                            ? Icons.filter_list
                            : Icons.filter_list_off,
                        color: _showFilters
                            ? Theme.of(context).primaryColor
                            : Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _showFilters = !_showFilters;
                        });
                      },
                      tooltip: 'Filtri',
                    ),
                  ],
                ),

                // Filtri
                if (_showFilters) ...[
                  const SizedBox(height: 16),
                  const SearchFilters(),
                ],
              ],
            ),
          ),

          // Risultati della ricerca
          Expanded(
            child: Consumer<TablatureProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (provider.tablatures.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          provider.searchQuery.isEmpty
                              ? MdiIcons.musicNote
                              : Icons.search_off,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          provider.searchQuery.isEmpty
                              ? 'Inizia a cercare le tablature'
                              : 'Nessun risultato trovato',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (provider.searchQuery.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            'Prova con termini di ricerca diversi',
                            style: TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                }

                return Column(
                  children: [
                    // Informazioni sui risultati
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      color: Colors.grey[100],
                      child: Row(
                        children: [
                          Text(
                            '${provider.tablatures.length} risultati',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          if (provider.searchQuery.isNotEmpty ||
                              provider.selectedComposer.isNotEmpty)
                            TextButton.icon(
                              onPressed: () {
                                _searchController.clear();
                                provider.clearFilters();
                              },
                              icon: const Icon(Icons.clear_all, size: 16),
                              label: const Text('Pulisci filtri'),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    // Lista dei risultati
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: provider.tablatures.length,
                        itemBuilder: (context, index) {
                          final tablature = provider.tablatures[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: TablatureCard(
                              tablature: tablature,
                              highlightQuery: provider.searchQuery,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
