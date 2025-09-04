import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:classtab_catalog/providers/tablature_provider.dart';
import 'package:classtab_catalog/screens/composer_detail_screen.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ComposersScreen extends StatefulWidget {
  const ComposersScreen({super.key});

  @override
  State<ComposersScreen> createState() => _ComposersScreenState();
}

class _ComposersScreenState extends State<ComposersScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _filteredComposers = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<TablatureProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.composers.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    MdiIcons.accountMusic,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Nessun compositore trovato',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Sincronizza con ClassTab.org per caricare i compositori',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          // Filtra i compositori in base alla ricerca
          if (_filteredComposers.isEmpty && _searchController.text.isEmpty) {
            _filteredComposers = List.from(provider.composers);
          }

          return Column(
            children: [
              // Barra di ricerca
              Container(
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
                  children: [
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Cerca compositori...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _searchController.clear();
                                  _filterComposers('', provider.composers);
                                },
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      onChanged: (value) {
                        _filterComposers(value, provider.composers);
                      },
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          MdiIcons.accountMusic,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${_filteredComposers.length} compositori',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Lista dei compositori
              Expanded(
                child: _buildComposersList(provider),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildComposersList(TablatureProvider provider) {
    if (_filteredComposers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            const Text(
              'Nessun compositore trovato',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            const Text(
              'Prova con un termine di ricerca diverso',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    // Raggruppa i compositori per lettera iniziale
    final groupedComposers = <String, List<String>>{};
    for (final composer in _filteredComposers) {
      final firstLetter = composer.isNotEmpty ? composer[0].toUpperCase() : '#';
      groupedComposers.putIfAbsent(firstLetter, () => []).add(composer);
    }

    final sortedKeys = groupedComposers.keys.toList()..sort();

    return ListView.builder(
      itemCount: sortedKeys.length,
      itemBuilder: (context, index) {
        final letter = sortedKeys[index];
        final composers = groupedComposers[letter]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header della sezione
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.grey[100],
              child: Text(
                letter,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),

            // Lista dei compositori per questa lettera
            ...composers
                .map((composer) => _buildComposerTile(composer, provider)),
          ],
        );
      },
    );
  }

  Widget _buildComposerTile(String composer, TablatureProvider provider) {
    // Conta le tablature per questo compositore
    final tablatureCount =
        provider.tablatures.where((t) => t.composer == composer).length;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
        child: Text(
          composer.isNotEmpty ? composer[0].toUpperCase() : '?',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(
        composer,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        '$tablatureCount tablatur${tablatureCount == 1 ? 'a' : 'e'}',
        style: TextStyle(color: Colors.grey[600]),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ComposerDetailScreen(
              composer: composer,
            ),
          ),
        );
      },
    );
  }

  void _filterComposers(String query, List<String> allComposers) {
    setState(() {
      if (query.isEmpty) {
        _filteredComposers = List.from(allComposers);
      } else {
        _filteredComposers = allComposers
            .where((composer) =>
                composer.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }
}
