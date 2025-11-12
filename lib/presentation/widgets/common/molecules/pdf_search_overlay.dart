import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

/// Search overlay widget for PDF viewer
///
/// Provides text search functionality with:
/// - Search input field
/// - Previous/next navigation buttons
/// - Match counter display
/// - Clear and close buttons
class PdfSearchOverlay extends StatefulWidget {
  final PdfViewerController controller;
  final VoidCallback onClose;

  const PdfSearchOverlay({
    super.key,
    required this.controller,
    required this.onClose,
  });

  @override
  State<PdfSearchOverlay> createState() => _PdfSearchOverlayState();
}

class _PdfSearchOverlayState extends State<PdfSearchOverlay> {
  final TextEditingController _searchController = TextEditingController();
  PdfTextSearchResult? _searchResult;
  int _currentMatchIndex = 0;
  int _totalMatches = 0;

  @override
  void dispose() {
    _searchController.dispose();
    _searchResult?.clear();
    super.dispose();
  }

  void _performSearch(String searchText) {
    if (searchText.isEmpty) {
      setState(() {
        _searchResult?.clear();
        _searchResult = null;
        _currentMatchIndex = 0;
        _totalMatches = 0;
      });
      return;
    }

    _searchResult = widget.controller.searchText(searchText);
    _searchResult?.addListener(() {
      if (mounted) {
        if (_searchResult?.hasResult ?? false) {
          setState(() {
            _totalMatches = _searchResult?.totalInstanceCount ?? 0;
            _currentMatchIndex = _searchResult?.currentInstanceIndex ?? 0;
          });
        } else {
          setState(() {
            _totalMatches = 0;
            _currentMatchIndex = 0;
          });
        }
      }
    });
  }

  void _nextMatch() {
    _searchResult?.nextInstance();
  }

  void _previousMatch() {
    _searchResult?.previousInstance();
  }



  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[850] : Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Search input row
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'Buscar en el documento',
                      prefixIcon: Icon(Icons.search,color: theme.colorScheme.tertiary,),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {});
                      _performSearch(value);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: widget.onClose,
                  tooltip: 'Cerrar',
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Navigation and counter row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Match counter
                Text(
                  _totalMatches > 0
                      ? '$_currentMatchIndex de $_totalMatches'
                      : _searchController.text.isNotEmpty
                          ? 'Sin resultados'
                          : '',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                ),
                // Navigation buttons
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.keyboard_arrow_up, size: 20),
                      onPressed: _totalMatches > 0 ? _previousMatch : null,
                      tooltip: 'Anterior',
                    ),
                    const SizedBox(width: 4),
                    IconButton(
                      icon: const Icon(Icons.keyboard_arrow_down, size: 20),
                      onPressed: _totalMatches > 0 ? _nextMatch : null,
                      tooltip: 'Siguiente',
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
