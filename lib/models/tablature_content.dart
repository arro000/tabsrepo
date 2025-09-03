class TablatureContent {
  final String introduction;
  final String tablature;
  final String footer;

  TablatureContent({
    required this.introduction,
    required this.tablature,
    required this.footer,
  });

  factory TablatureContent.parse(String rawContent) {
    if (rawContent.isEmpty) {
      return TablatureContent(
        introduction: '',
        tablature: '',
        footer: '',
      );
    }

    final lines = rawContent.split('\n');

    // Trova l'inizio della tablatura (linee che contengono caratteri tipici della tablatura)
    int tablatureStart = -1;
    int tablatureEnd = -1;

    // Pattern per identificare linee di tablatura
    final tablaturePatterns = [
      RegExp(
          r'^[EADGBe]\|'), // Linee che iniziano con nota e barra (E|, A|, etc.)
      RegExp(r'^\s*[EADGBe]\s*\|'), // Linee con nota e barra con spazi
      RegExp(
          r'^\s*[\|\-0-9]{10,}'), // Linee lunghe con barre, trattini e numeri
      RegExp(
          r'^\s*[0-9\-\|]{8,}'), // Linee con numeri, trattini e barre (almeno 8 caratteri)
    ];

    // Trova l'inizio della tablatura
    for (int i = 0; i < lines.length; i++) {
      final line = lines[i].trim();
      if (line.isEmpty) continue;

      // Controlla se la linea corrisponde a un pattern di tablatura
      final bool isTablatureLine =
          tablaturePatterns.any((pattern) => pattern.hasMatch(line));

      if (isTablatureLine) {
        tablatureStart = i;
        break;
      }
    }

    // Se non trova pattern specifici, cerca linee con molti caratteri di tablatura
    if (tablatureStart == -1) {
      for (int i = 0; i < lines.length; i++) {
        final line = lines[i];
        if (line.length > 20 &&
            _countTablatureChars(line) > line.length * 0.3) {
          tablatureStart = i;
          break;
        }
      }
    }

    // Trova la fine della tablatura (cerca dall'ultimo verso l'inizio)
    if (tablatureStart != -1) {
      for (int i = lines.length - 1; i >= tablatureStart; i--) {
        final line = lines[i].trim();
        if (line.isEmpty) continue;

        final bool isTablatureLine =
            tablaturePatterns.any((pattern) => pattern.hasMatch(line)) ||
                (line.length > 20 &&
                    _countTablatureChars(line) > line.length * 0.3);

        if (isTablatureLine) {
          tablatureEnd = i;
          break;
        }
      }
    }

    // Se non trova la tablatura, tutto va nell'introduzione
    if (tablatureStart == -1 || tablatureEnd == -1) {
      return TablatureContent(
        introduction: rawContent,
        tablature: '',
        footer: '',
      );
    }

    // Estrai le tre parti
    final introduction = tablatureStart > 0
        ? lines.sublist(0, tablatureStart).join('\n').trim()
        : '';

    final tablature =
        lines.sublist(tablatureStart, tablatureEnd + 1).join('\n');

    final footer = tablatureEnd < lines.length - 1
        ? lines.sublist(tablatureEnd + 1).join('\n').trim()
        : '';

    return TablatureContent(
      introduction: introduction,
      tablature: tablature,
      footer: footer,
    );
  }

  static int _countTablatureChars(String line) {
    final tablatureChars = RegExp(r'[\|\-0-9\(\)hpbr\^~\/\\]');
    return tablatureChars.allMatches(line).length;
  }

  bool get hasIntroduction => introduction.isNotEmpty;
  bool get hasTablature => tablature.isNotEmpty;
  bool get hasFooter => footer.isNotEmpty;
}
