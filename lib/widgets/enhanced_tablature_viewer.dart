import 'package:flutter/material.dart';
import 'package:classtab_catalog/models/tablature_content.dart';
import 'dart:async';

class EnhancedTablatureViewer extends StatefulWidget {
  final String content;
  final double initialFontSize;
  final bool showLineNumbers;
  final Function(double)? onFontSizeChanged;

  const EnhancedTablatureViewer({
    super.key,
    required this.content,
    this.initialFontSize = 14.0,
    this.showLineNumbers = false,
    this.onFontSizeChanged,
  });

  @override
  State<EnhancedTablatureViewer> createState() =>
      _EnhancedTablatureViewerState();
}

class _EnhancedTablatureViewerState extends State<EnhancedTablatureViewer>
    with TickerProviderStateMixin {
  late TablatureContent _parsedContent;
  late ScrollController _scrollController;
  late TabController _tabController;

  double _fontSize = 14.0;
  bool _isAutoScrolling = false;
  double _autoScrollSpeed = 1.0; // pixels per millisecond
  Timer? _autoScrollTimer;

  // Zoom controls
  static const double _minFontSize = 8.0;
  static const double _maxFontSize = 32.0;
  static const double _fontSizeStep = 1.0;

  @override
  void initState() {
    super.initState();
    _fontSize = widget.initialFontSize;
    _parsedContent = TablatureContent.parse(widget.content);
    _scrollController = ScrollController();

    // Conta le sezioni disponibili
    final sections = <String>[];
    if (_parsedContent.hasIntroduction) sections.add('Introduzione');
    if (_parsedContent.hasTablature) sections.add('Tablatura');
    if (_parsedContent.hasFooter) sections.add('Note');

    _tabController = TabController(
      length: sections.length,
      vsync: this,
      initialIndex: _parsedContent.hasTablature
          ? (sections.contains('Tablatura') ? sections.indexOf('Tablatura') : 0)
          : 0,
    );
  }

  @override
  void dispose() {
    _stopAutoScroll();
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    if (_isAutoScrolling) return;

    setState(() {
      _isAutoScrolling = true;
    });

    _autoScrollTimer =
        Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (!_scrollController.hasClients) return;

      final currentOffset = _scrollController.offset;
      final maxOffset = _scrollController.position.maxScrollExtent;

      if (currentOffset >= maxOffset) {
        _stopAutoScroll();
        return;
      }

      final newOffset = currentOffset + (_autoScrollSpeed * 50);
      _scrollController.animateTo(
        newOffset.clamp(0.0, maxOffset),
        duration: const Duration(milliseconds: 50),
        curve: Curves.linear,
      );
    });
  }

  void _stopAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = null;
    setState(() {
      _isAutoScrolling = false;
    });
  }

  void _adjustFontSize(double delta) {
    final newSize = (_fontSize + delta).clamp(_minFontSize, _maxFontSize);
    setState(() {
      _fontSize = newSize;
    });
    widget.onFontSizeChanged?.call(newSize);
  }

  void _resetScroll() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final sections = <String>[];
    if (_parsedContent.hasIntroduction) sections.add('Introduzione');
    if (_parsedContent.hasTablature) sections.add('Tablatura');
    if (_parsedContent.hasFooter) sections.add('Note');

    if (sections.isEmpty) {
      return const Center(
        child: Text(
          'Contenuto non disponibile',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return Column(
      children: [
        // Controls bar
        _buildControlsBar(),

        // Tab bar (solo se ci sono più sezioni)
        if (sections.length > 1)
          Container(
            color: Theme.of(context).cardColor,
            child: TabBar(
              controller: _tabController,
              tabs: sections.map((section) => Tab(text: section)).toList(),
              labelColor: Theme.of(context).primaryColor,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Theme.of(context).primaryColor,
            ),
          ),

        // Content
        Expanded(
          child: sections.length > 1
              ? TabBarView(
                  controller: _tabController,
                  children: sections
                      .map((section) => _buildSectionContent(section))
                      .toList(),
                )
              : _buildSectionContent(sections.first),
        ),
      ],
    );
  }

  Widget _buildControlsBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          // Font size controls
          IconButton(
            icon: const Icon(Icons.zoom_out),
            onPressed: _fontSize > _minFontSize
                ? () => _adjustFontSize(-_fontSizeStep)
                : null,
            tooltip: 'Riduci testo',
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '${_fontSize.toInt()}px',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),

          IconButton(
            icon: const Icon(Icons.zoom_in),
            onPressed: _fontSize < _maxFontSize
                ? () => _adjustFontSize(_fontSizeStep)
                : null,
            tooltip: 'Ingrandisci testo',
          ),

          const SizedBox(width: 16),

          // Auto-scroll controls
          IconButton(
            icon: Icon(_isAutoScrolling ? Icons.pause : Icons.play_arrow),
            onPressed: _isAutoScrolling ? _stopAutoScroll : _startAutoScroll,
            tooltip:
                _isAutoScrolling ? 'Ferma scorrimento' : 'Avvia scorrimento',
          ),

          if (_isAutoScrolling) ...[
            const SizedBox(width: 8),
            const Icon(Icons.speed, size: 16),
            const SizedBox(width: 4),
            SizedBox(
              width: 100,
              child: Slider(
                value: _autoScrollSpeed,
                min: 0.5,
                max: 3.0,
                divisions: 5,
                onChanged: (value) {
                  setState(() {
                    _autoScrollSpeed = value;
                  });
                },
              ),
            ),
          ],

          const Spacer(),

          // Reset scroll
          IconButton(
            icon: const Icon(Icons.vertical_align_top),
            onPressed: _resetScroll,
            tooltip: 'Torna all\'inizio',
          ),
        ],
      ),
    );
  }

  Widget _buildSectionContent(String section) {
    String content;
    bool isMonospace = false;

    switch (section) {
      case 'Introduzione':
        content = _parsedContent.introduction;
        break;
      case 'Tablatura':
        content = _parsedContent.tablature;
        isMonospace = true;
        break;
      case 'Note':
        content = _parsedContent.footer;
        break;
      default:
        content = widget.content;
    }

    if (content.isEmpty) {
      return Center(
        child: Text(
          'Sezione vuota',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      color: isMonospace ? Colors.white : null,
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        controller: section == 'Tablatura' ? _scrollController : null,
        child: widget.showLineNumbers && isMonospace
            ? _buildNumberedContent(content, isMonospace)
            : _buildSimpleContent(content, isMonospace),
      ),
    );
  }

  Widget _buildSimpleContent(String content, bool isMonospace) {
    return SelectableText(
      content,
      style: TextStyle(
        fontFamily: isMonospace ? 'Courier' : null,
        fontSize: _fontSize,
        height: isMonospace ? 1.3 : 1.4,
        letterSpacing: isMonospace ? 0.0 : null,
        color: isMonospace ? Colors.black : null,
      ),
    );
  }

  Widget _buildNumberedContent(String content, bool isMonospace) {
    final lines = content.split('\n');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines.asMap().entries.map((entry) {
        final lineNumber = entry.key + 1;
        final line = entry.value;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 50,
              padding: const EdgeInsets.only(right: 8),
              child: Text(
                '$lineNumber',
                style: TextStyle(
                  fontFamily: 'Courier',
                  fontSize: _fontSize - 2,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.right,
              ),
            ),
            Expanded(
              child: SelectableText(
                line,
                style: TextStyle(
                  fontFamily: isMonospace ? 'Courier' : null,
                  fontSize: _fontSize,
                  height: isMonospace ? 1.3 : 1.4,
                  letterSpacing: isMonospace ? 0.0 : null,
                  color: isMonospace ? Colors.black : null,
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
