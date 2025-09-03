import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:classtab_catalog/providers/tablature_provider.dart';
import 'package:classtab_catalog/providers/midi_provider.dart';
import 'package:classtab_catalog/services/database_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _autoSync = false;
  bool _downloadMidiFiles = true;
  bool _showLineNumbers = false;
  double _defaultFontSize = 14.0;
  String _lastSyncDate = 'Mai';
  int _totalTablatures = 0;
  int _cacheSize = 0;

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _loadStats();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _autoSync = prefs.getBool('auto_sync') ?? false;
      _downloadMidiFiles = prefs.getBool('download_midi_files') ?? true;
      _showLineNumbers = prefs.getBool('show_line_numbers') ?? false;
      _defaultFontSize = prefs.getDouble('default_font_size') ?? 14.0;
      _lastSyncDate = prefs.getString('last_sync_date') ?? 'Mai';
    });
  }

  Future<void> _loadStats() async {
    final dbService = DatabaseService.instance;
    final count = await dbService.getTablatureCount();

    setState(() {
      _totalTablatures = count;
      // Calcola la dimensione della cache (semplificato)
      _cacheSize = count * 2; // KB approssimativi
    });
  }

  Future<void> _saveSetting(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is double) {
      await prefs.setDouble(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Impostazioni'),
      ),
      body: ListView(
        children: [
          // Sezione Sincronizzazione
          _buildSectionHeader('Sincronizzazione'),
          _buildSwitchTile(
            title: 'Sincronizzazione automatica',
            subtitle: 'Controlla automaticamente gli aggiornamenti',
            value: _autoSync,
            icon: Icons.sync,
            onChanged: (value) {
              setState(() {
                _autoSync = value;
              });
              _saveSetting('auto_sync', value);
            },
          ),
          _buildListTile(
            title: 'Ultima sincronizzazione',
            subtitle: _lastSyncDate,
            icon: Icons.history,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: () => _testConnectivity(),
                  child: const Text('Test'),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () => _syncNow(),
                  child: const Text('Sincronizza ora'),
                ),
              ],
            ),
          ),
          _buildListTile(
            title: 'Tablature nel database',
            subtitle: '$_totalTablatures tablature',
            icon: MdiIcons.musicNote,
          ),

          const Divider(),

          // Sezione MIDI
          _buildSectionHeader('Riproduzione MIDI'),
          _buildSwitchTile(
            title: 'Scarica file MIDI',
            subtitle:
                'Scarica automaticamente i file MIDI per la riproduzione offline',
            value: _downloadMidiFiles,
            icon: MdiIcons.musicNoteEighth,
            onChanged: (value) {
              setState(() {
                _downloadMidiFiles = value;
              });
              _saveSetting('download_midi_files', value);
            },
          ),
          _buildListTile(
            title: 'Pulisci cache MIDI',
            subtitle: 'Libera ${_cacheSize}KB di spazio',
            icon: Icons.cleaning_services,
            trailing: TextButton(
              onPressed: () => _clearMidiCache(),
              child: const Text('Pulisci'),
            ),
          ),

          const Divider(),

          // Sezione Visualizzazione
          _buildSectionHeader('Visualizzazione'),
          _buildSwitchTile(
            title: 'Mostra numeri di riga',
            subtitle: 'Mostra i numeri di riga nelle tablature',
            value: _showLineNumbers,
            icon: Icons.format_list_numbered,
            onChanged: (value) {
              setState(() {
                _showLineNumbers = value;
              });
              _saveSetting('show_line_numbers', value);
            },
          ),
          _buildSliderTile(
            title: 'Dimensione carattere predefinita',
            subtitle: '${_defaultFontSize.toInt()}px',
            value: _defaultFontSize,
            min: 10.0,
            max: 24.0,
            divisions: 14,
            icon: Icons.text_fields,
            onChanged: (value) {
              setState(() {
                _defaultFontSize = value;
              });
              _saveSetting('default_font_size', value);
            },
          ),

          const Divider(),

          // Sezione Database
          _buildSectionHeader('Database'),
          _buildListTile(
            title: 'Pulisci database',
            subtitle: 'Rimuovi tutte le tablature dal database locale',
            icon: Icons.delete_sweep,
            trailing: TextButton(
              onPressed: () => _showClearDatabaseDialog(),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Pulisci'),
            ),
          ),
          _buildListTile(
            title: 'Esporta preferiti',
            subtitle: 'Esporta la lista dei preferiti',
            icon: Icons.file_download,
            trailing: TextButton(
              onPressed: () => _exportFavorites(),
              child: const Text('Esporta'),
            ),
          ),

          const Divider(),

          // Sezione Informazioni
          _buildSectionHeader('Informazioni'),
          _buildListTile(
            title: 'Versione app',
            subtitle: '1.0.0',
            icon: Icons.info_outline,
          ),
          _buildListTile(
            title: 'Sito ClassTab.org',
            subtitle: 'Visita il sito ufficiale',
            icon: Icons.open_in_browser,
            onTap: () => _openClassTabWebsite(),
          ),
          _buildListTile(
            title: 'Informazioni su ClassTab',
            subtitle: 'Scopri di più sul progetto',
            icon: Icons.help_outline,
            onTap: () => _showAboutDialog(),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required IconData icon,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildListTile({
    required String title,
    required String subtitle,
    required IconData icon,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: trailing,
      onTap: onTap,
    );
  }

  Widget _buildSliderTile({
    required String title,
    required String subtitle,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required IconData icon,
    required ValueChanged<double> onChanged,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(subtitle),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Future<void> _testConnectivity() async {
    try {
      final provider = context.read<TablatureProvider>();
      final service = provider.classTabService;

      // Mostra dialog di caricamento
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Text('Testing connectivity...'),
            ],
          ),
        ),
      );

      // Test connettività
      final isConnected = await service.testConnectivity();

      // Test disponibilità ZIP
      final zipInfo = await service.checkZipAvailability();

      // Chiudi dialog di caricamento
      if (mounted) Navigator.of(context).pop();

      // Mostra risultati
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Test Connettività'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      isConnected ? Icons.check_circle : Icons.error,
                      color: isConnected ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Text(
                        'Server ClassTab: ${isConnected ? 'OK' : 'Non raggiungibile'}'),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      zipInfo['available'] ? Icons.check_circle : Icons.error,
                      color: zipInfo['available'] ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Text(
                        'File ZIP: ${zipInfo['available'] ? 'Disponibile' : 'Non disponibile'}'),
                  ],
                ),
                if (zipInfo['available']) ...[
                  const SizedBox(height: 8),
                  Text('Dimensione: ${zipInfo['contentLength']} bytes'),
                  Text(
                      'Ultimo aggiornamento: ${zipInfo['lastModified'] ?? 'N/A'}'),
                ],
                if (!zipInfo['available'] && zipInfo['error'] != null) ...[
                  const SizedBox(height: 8),
                  Text('Errore: ${zipInfo['error']}',
                      style: const TextStyle(color: Colors.red)),
                ],
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      // Chiudi dialog di caricamento se aperto
      if (mounted) Navigator.of(context).pop();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Errore nel test: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _syncNow() async {
    try {
      await context.read<TablatureProvider>().syncWithClassTab();

      // Aggiorna la data di sincronizzazione
      final now = DateTime.now();
      final dateString = '${now.day}/${now.month}/${now.year}';
      await _saveSetting('last_sync_date', dateString);

      setState(() {
        _lastSyncDate = dateString;
      });

      await _loadStats();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sincronizzazione completata')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Errore nella sincronizzazione: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _clearMidiCache() async {
    try {
      await context.read<MidiProvider>().clearCache();
      setState(() {
        _cacheSize = 0;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cache MIDI pulita')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Errore nella pulizia della cache: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showClearDatabaseDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pulisci database'),
          content: const Text(
            'Sei sicuro di voler rimuovere tutte le tablature dal database locale? '
            'Dovrai sincronizzare nuovamente per riavere i dati.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annulla'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _clearDatabase();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Pulisci'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _clearDatabase() async {
    try {
      await DatabaseService.instance.clearAllTablatures();
      await context.read<TablatureProvider>().loadTablatures();

      setState(() {
        _totalTablatures = 0;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Database pulito')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Errore nella pulizia del database: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _exportFavorites() async {
    // Implementazione semplificata
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Funzione di esportazione non ancora implementata')),
    );
  }

  void _openClassTabWebsite() {
    // Implementazione per aprire il sito web
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Apertura del sito ClassTab.org...')),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Informazioni su ClassTab'),
          content: const SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'ClassTab Catalog è un\'applicazione per catalogare e visualizzare '
                  'le tablature di chitarra classica dal sito ClassTab.org.',
                ),
                SizedBox(height: 16),
                Text(
                  'ClassTab.org contiene oltre 3000 tablature di chitarra classica '
                  'in formato testo, molte con file MIDI associati.',
                ),
                SizedBox(height: 16),
                Text(
                  'Questa applicazione ti permette di:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('• Cercare e filtrare le tablature'),
                Text('• Visualizzare le tablature con formattazione'),
                Text('• Riprodurre i file MIDI associati'),
                Text('• Salvare le tablature preferite'),
                Text('• Sincronizzare con gli aggiornamenti del sito'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Chiudi'),
            ),
          ],
        );
      },
    );
  }
}
