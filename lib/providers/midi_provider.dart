import 'package:flutter/foundation.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';

import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:classtab_catalog/services/classtab_service.dart';

enum MidiPlayerState {
  stopped,
  playing,
  paused,
  loading,
  error,
}

class MidiProvider with ChangeNotifier {
  final ClassTabService _classTabService = ClassTabService();
  
  MidiPlayerState _state = MidiPlayerState.stopped;
  String _currentMidiUrl = '';
  String _errorMessage = '';
  double _position = 0.0;
  double _duration = 0.0;
  bool _isLooping = false;
  double _volume = 0.7;
  double _tempo = 1.0;

  // Getters
  MidiPlayerState get state => _state;
  String get currentMidiUrl => _currentMidiUrl;
  String get errorMessage => _errorMessage;
  double get position => _position;
  double get duration => _duration;
  bool get isLooping => _isLooping;
  double get volume => _volume;
  double get tempo => _tempo;
  bool get isPlaying => _state == MidiPlayerState.playing;
  bool get isPaused => _state == MidiPlayerState.paused;
  bool get isLoading => _state == MidiPlayerState.loading;

  Future<void> playMidi(String midiUrl) async {
    if (_currentMidiUrl == midiUrl && _state == MidiPlayerState.playing) {
      return;
    }

    try {
      _setState(MidiPlayerState.loading);
      _currentMidiUrl = midiUrl;
      _clearError();

      // Scarica il file MIDI se necessario
      final midiData = await _getMidiData(midiUrl);
      
      // Salva temporaneamente il file MIDI
      final tempFile = await _saveTempMidiFile(midiData, midiUrl);
      
      // Inizializza il player MIDI
      await _initializeMidiPlayer();
      
      // Carica e riproduci il file MIDI
      await _loadAndPlayMidi(tempFile.path);
      
      _setState(MidiPlayerState.playing);
    } catch (e) {
      _setError('Errore nella riproduzione MIDI: $e');
      _setState(MidiPlayerState.error);
    }
  }

  Future<void> pauseMidi() async {
    if (_state == MidiPlayerState.playing) {
      try {
        // Implementa la pausa del MIDI
        // Nota: flutter_midi_command potrebbe non supportare la pausa
        // In questo caso, fermiamo e salviamo la posizione
        await stopMidi();
        _setState(MidiPlayerState.paused);
      } catch (e) {
        _setError('Errore nella pausa: $e');
      }
    }
  }

  Future<void> resumeMidi() async {
    if (_state == MidiPlayerState.paused) {
      try {
        // Riprendi dalla posizione salvata
        await playMidi(_currentMidiUrl);
      } catch (e) {
        _setError('Errore nella ripresa: $e');
      }
    }
  }

  Future<void> stopMidi() async {
    try {
      // Ferma la riproduzione MIDI
      // Nota: implementazione semplificata per il player MIDI
      _setState(MidiPlayerState.stopped);
      _position = 0.0;
      _currentMidiUrl = '';
    } catch (e) {
      _setError('Errore nell\'arresto: $e');
    }
  }

  Future<void> seekTo(double position) async {
    if (_state == MidiPlayerState.playing || _state == MidiPlayerState.paused) {
      try {
        _position = position;
        // Implementa il seek se supportato
        notifyListeners();
      } catch (e) {
        _setError('Errore nel seek: $e');
      }
    }
  }

  void setVolume(double volume) {
    _volume = volume.clamp(0.0, 1.0);
    // Implementa il controllo del volume se supportato
    notifyListeners();
  }

  void setTempo(double tempo) {
    _tempo = tempo.clamp(0.5, 2.0);
    // Implementa il controllo del tempo se supportato
    notifyListeners();
  }

  void toggleLoop() {
    _isLooping = !_isLooping;
    notifyListeners();
  }

  Future<Uint8List> _getMidiData(String midiUrl) async {
    try {
      // Prima controlla se il file è già in cache
      final cachedFile = await _getCachedMidiFile(midiUrl);
      if (cachedFile != null && await cachedFile.exists()) {
        return await cachedFile.readAsBytes();
      }

      // Scarica il file MIDI
      final midiData = await _classTabService.fetchMidiFile(midiUrl);
      
      // Salva in cache
      if (cachedFile != null) {
        await cachedFile.writeAsBytes(midiData);
      }
      
      return midiData;
    } catch (e) {
      throw Exception('Errore nel download del file MIDI: $e');
    }
  }

  Future<File?> _getCachedMidiFile(String midiUrl) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final cacheDir = Directory(path.join(directory.path, 'midi_cache'));
      
      if (!await cacheDir.exists()) {
        await cacheDir.create(recursive: true);
      }
      
      final fileName = _getMidiFileName(midiUrl);
      return File(path.join(cacheDir.path, fileName));
    } catch (e) {
      debugPrint('Errore nella gestione della cache: $e');
      return null;
    }
  }

  String _getMidiFileName(String midiUrl) {
    final uri = Uri.parse(midiUrl);
    final fileName = path.basename(uri.path);
    return fileName.isNotEmpty ? fileName : 'midi_${midiUrl.hashCode}.mid';
  }

  Future<File> _saveTempMidiFile(Uint8List midiData, String midiUrl) async {
    final directory = await getTemporaryDirectory();
    final fileName = _getMidiFileName(midiUrl);
    final tempFile = File(path.join(directory.path, fileName));
    
    await tempFile.writeAsBytes(midiData);
    return tempFile;
  }

  Future<void> _initializeMidiPlayer() async {
    try {
      // Inizializza il sistema MIDI
      // Nota: implementazione semplificata per il player MIDI
      
      // Configura i dispositivi MIDI se necessario
      final devices = await MidiCommand().devices;
      if (devices != null && devices.isNotEmpty) {
        // Seleziona il primo dispositivo disponibile
        await MidiCommand().connectToDevice(devices.first);
      }
    } catch (e) {
      throw Exception('Errore nell\'inizializzazione del player MIDI: $e');
    }
  }

  Future<void> _loadAndPlayMidi(String filePath) async {
    try {
      // Nota: flutter_midi_command potrebbe non supportare direttamente
      // la riproduzione di file MIDI. Potresti dover implementare
      // un parser MIDI personalizzato o usare un'altra libreria.
      
      // Per ora, implementiamo una versione semplificata
      final file = File(filePath);
      final midiData = await file.readAsBytes();
      
      // Simula la durata del file MIDI (implementazione semplificata)
      _duration = _estimateMidiDuration(midiData);
      
      // Avvia un timer per simulare la riproduzione
      _startPlaybackTimer();
      
    } catch (e) {
      throw Exception('Errore nel caricamento del file MIDI: $e');
    }
  }

  double _estimateMidiDuration(Uint8List midiData) {
    // Implementazione semplificata per stimare la durata
    // In una implementazione reale, dovresti parsare il file MIDI
    return 120.0; // 2 minuti di default
  }

  void _startPlaybackTimer() {
    // Simula la riproduzione con un timer
    // In una implementazione reale, questo sarebbe gestito dal player MIDI
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_state == MidiPlayerState.playing) {
        _position += 0.1;
        if (_position >= _duration) {
          if (_isLooping) {
            _position = 0.0;
          } else {
            _setState(MidiPlayerState.stopped);
            _position = 0.0;
            return;
          }
        }
        notifyListeners();
        _startPlaybackTimer();
      }
    });
  }

  void _setState(MidiPlayerState state) {
    _state = state;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = '';
    notifyListeners();
  }

  Future<void> clearCache() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final cacheDir = Directory(path.join(directory.path, 'midi_cache'));
      
      if (await cacheDir.exists()) {
        await cacheDir.delete(recursive: true);
      }
    } catch (e) {
      debugPrint('Errore nella pulizia della cache: $e');
    }
  }

  @override
  void dispose() {
    stopMidi();
    super.dispose();
  }
}