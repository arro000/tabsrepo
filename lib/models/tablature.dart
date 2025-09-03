class Tablature {
  final int? id;
  final String title;
  final String composer;
  final String? opus;
  final String? key;
  final String? difficulty;
  final bool hasMidi;
  final bool hasLhf; // Left Hand Fingering
  final bool hasVideo;
  final String? videoUrl;
  final String tabUrl;
  final String? midiUrl;
  final String content;
  final DateTime? lastUpdated;
  final bool isFavorite;

  Tablature({
    this.id,
    required this.title,
    required this.composer,
    this.opus,
    this.key,
    this.difficulty,
    this.hasMidi = false,
    this.hasLhf = false,
    this.hasVideo = false,
    this.videoUrl,
    required this.tabUrl,
    this.midiUrl,
    required this.content,
    this.lastUpdated,
    this.isFavorite = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'composer': composer,
      'opus': opus,
      'key': key,
      'difficulty': difficulty,
      'hasMidi': hasMidi ? 1 : 0,
      'hasLhf': hasLhf ? 1 : 0,
      'hasVideo': hasVideo ? 1 : 0,
      'videoUrl': videoUrl,
      'tabUrl': tabUrl,
      'midiUrl': midiUrl,
      'content': content,
      'lastUpdated': lastUpdated?.millisecondsSinceEpoch,
      'isFavorite': isFavorite ? 1 : 0,
    };
  }

  factory Tablature.fromMap(Map<String, dynamic> map) {
    return Tablature(
      id: map['id'],
      title: map['title'] ?? '',
      composer: map['composer'] ?? '',
      opus: map['opus'],
      key: map['key'],
      difficulty: map['difficulty'],
      hasMidi: map['hasMidi'] == 1,
      hasLhf: map['hasLhf'] == 1,
      hasVideo: map['hasVideo'] == 1,
      videoUrl: map['videoUrl'],
      tabUrl: map['tabUrl'] ?? '',
      midiUrl: map['midiUrl'],
      content: map['content'] ?? '',
      lastUpdated: map['lastUpdated'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(map['lastUpdated'])
          : null,
      isFavorite: map['isFavorite'] == 1,
    );
  }

  Tablature copyWith({
    int? id,
    String? title,
    String? composer,
    String? opus,
    String? key,
    String? difficulty,
    bool? hasMidi,
    bool? hasLhf,
    bool? hasVideo,
    String? videoUrl,
    String? tabUrl,
    String? midiUrl,
    String? content,
    DateTime? lastUpdated,
    bool? isFavorite,
  }) {
    return Tablature(
      id: id ?? this.id,
      title: title ?? this.title,
      composer: composer ?? this.composer,
      opus: opus ?? this.opus,
      key: key ?? this.key,
      difficulty: difficulty ?? this.difficulty,
      hasMidi: hasMidi ?? this.hasMidi,
      hasLhf: hasLhf ?? this.hasLhf,
      hasVideo: hasVideo ?? this.hasVideo,
      videoUrl: videoUrl ?? this.videoUrl,
      tabUrl: tabUrl ?? this.tabUrl,
      midiUrl: midiUrl ?? this.midiUrl,
      content: content ?? this.content,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  String get displayTitle {
    if (opus != null && opus!.isNotEmpty) {
      return '$opus - $title';
    }
    return title;
  }

  String get difficultyDisplay {
    switch (difficulty?.toLowerCase()) {
      case 'easy':
        return 'Facile';
      case 'intermediate':
        return 'Intermedio';
      case 'advanced':
        return 'Avanzato';
      default:
        return difficulty ?? 'Non specificato';
    }
  }

  List<String> get features {
    final List<String> features = [];
    if (hasMidi) features.add('MIDI');
    if (hasLhf) features.add('LHF');
    if (hasVideo) features.add('Video');
    return features;
  }
}