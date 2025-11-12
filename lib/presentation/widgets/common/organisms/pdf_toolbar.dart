import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

/// Custom toolbar for the PDF Viewer
///
/// Provides comprehensive PDF manipulation controls including:
/// - Undo/Redo for annotations
/// - Page navigation
/// - Zoom controls
/// - Download functionality
/// - Search
/// - Bookmarks
/// - View settings
/// - Annotation tools (secondary toolbar)
class PdfToolbar extends StatefulWidget {
  final PdfViewerController controller;
  final UndoHistoryController undoController;
  final bool isDesktopWeb;
  final Function(String action, {dynamic data}) onAction;
  final Annotation? selectedAnnotation;
  final int currentPage;
  final int totalPages;
  final double zoomLevel;
  final bool canUndo;
  final bool canRedo;
  final bool showAnnotationToolbar;
  final PdfAnnotationMode currentAnnotationMode;

  const PdfToolbar({
    super.key,
    required this.controller,
    required this.undoController,
    required this.isDesktopWeb,
    required this.onAction,
    this.selectedAnnotation,
    required this.currentPage,
    required this.totalPages,
    required this.zoomLevel,
    required this.canUndo,
    required this.canRedo,
    this.showAnnotationToolbar = false,
    this.currentAnnotationMode = PdfAnnotationMode.none,
  });

  @override
  State<PdfToolbar> createState() => _PdfToolbarState();
}

class _PdfToolbarState extends State<PdfToolbar> {
  final TextEditingController _pageController = TextEditingController();
  bool _isEditingPage = false;

  @override
  void initState() {
    super.initState();
    _pageController.text = widget.currentPage.toString();
  }

  @override
  void didUpdateWidget(PdfToolbar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isEditingPage && widget.currentPage != oldWidget.currentPage) {
      _pageController.text = widget.currentPage.toString();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Primary toolbar
        Container(
          height: widget.isDesktopWeb ? 56 : 48,
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[900] : Colors.grey[100],
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: widget.isDesktopWeb
              ? _buildDesktopToolbar(theme, isDark)
              : _buildMobileToolbar(theme, isDark),
        ),
        // Secondary annotation toolbar
        if (widget.showAnnotationToolbar)
          _buildAnnotationToolbar(theme, isDark),
      ],
    );
  }

  Widget _buildDesktopToolbar(ThemeData theme, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          // Undo/Redo group
          _buildUndoButton(isDark),
          const SizedBox(width: 4),
          _buildRedoButton(isDark),

          _buildDivider(),

          // Page navigation group
          _buildPreviousPageButton(isDark),
          const SizedBox(width: 8),
          _buildPageIndicator(theme, isDark),
          const SizedBox(width: 8),
          _buildNextPageButton(isDark),

          _buildDivider(),

          // Zoom controls group
          _buildZoomOutButton(isDark),
          const SizedBox(width: 4),
          _buildZoomPercentageButton(theme, isDark),
          const SizedBox(width: 4),
          _buildZoomInButton(isDark),

          _buildDivider(),

          // Action buttons group
          _buildAnnotationToggleButton(theme, isDark),
          const SizedBox(width: 4),
          _buildSearchButton(isDark),
          const SizedBox(width: 4),
          _buildSettingsButton(isDark),
          const SizedBox(width: 4),
          _buildDownloadButton(isDark),
        ],
      ),
    );
  }

  Widget _buildMobileToolbar(ThemeData theme, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          // Essential controls for mobile
          _buildPreviousPageButton(isDark, compact: true),
          const SizedBox(width: 4),
          Expanded(
            child: _buildPageIndicator(theme, isDark, compact: true),
          ),
          const SizedBox(width: 4),
          _buildNextPageButton(isDark, compact: true),

          const SizedBox(width: 8),

          _buildZoomOutButton(isDark, compact: true),
          const SizedBox(width: 4),
          _buildZoomInButton(isDark, compact: true),

          const SizedBox(width: 8),

          _buildSearchButton(isDark, compact: true),
          const SizedBox(width: 4),
          _buildDownloadButton(isDark, compact: true),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 24,
      width: 1,
      color: Colors.grey[400],
      margin: const EdgeInsets.symmetric(horizontal: 8),
    );
  }

  // Undo button
  Widget _buildUndoButton(bool isDark, {bool compact = false}) {
    return IconButton(
      icon: Icon(
        Icons.undo,
        size: compact ? 20 : 24,
      ),
      onPressed: widget.canUndo ? () => widget.onAction('undo') : null,
      tooltip: 'Deshacer',
      color: isDark ? Colors.white : Colors.black87,
      disabledColor: Colors.grey,
    );
  }

  // Redo button
  Widget _buildRedoButton(bool isDark, {bool compact = false}) {
    return IconButton(
      icon: Icon(
        Icons.redo,
        size: compact ? 20 : 24,
      ),
      onPressed: widget.canRedo ? () => widget.onAction('redo') : null,
      tooltip: 'Rehacer',
      color: isDark ? Colors.white : Colors.black87,
      disabledColor: Colors.grey,
    );
  }

  // Previous page button
  Widget _buildPreviousPageButton(bool isDark, {bool compact = false}) {
    final canGoBack = widget.currentPage > 1;
    return IconButton(
      icon: Icon(
        Icons.chevron_left,
        size: compact ? 20 : 24,
      ),
      onPressed: canGoBack ? () => widget.onAction('previousPage') : null,
      tooltip: 'Página anterior',
      color: isDark ? Colors.white : Colors.black87,
      disabledColor: Colors.grey,
    );
  }

  // Next page button
  Widget _buildNextPageButton(bool isDark, {bool compact = false}) {
    final canGoForward = widget.currentPage < widget.totalPages;
    return IconButton(
      icon: Icon(
        Icons.chevron_right,
        size: compact ? 20 : 24,
      ),
      onPressed: canGoForward ? () => widget.onAction('nextPage') : null,
      tooltip: 'Página siguiente',
      color: isDark ? Colors.white : Colors.black87,
      disabledColor: Colors.grey,
    );
  }

  // Page indicator with direct page jump
  Widget _buildPageIndicator(ThemeData theme, bool isDark,
      {bool compact = false}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: compact ? 40 : 50,
          child: TextField(
            controller: _pageController,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: compact ? 12 : 14,
              color: isDark ? Colors.white : Colors.black87,
            ),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 4,
                vertical: compact ? 4 : 8,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            onTap: () {
              setState(() {
                _isEditingPage = true;
              });
              _pageController.selection = TextSelection(
                baseOffset: 0,
                extentOffset: _pageController.text.length,
              );
            },
            onSubmitted: (value) {
              setState(() {
                _isEditingPage = false;
              });
              final pageNumber = int.tryParse(value);
              if (pageNumber != null &&
                  pageNumber >= 1 &&
                  pageNumber <= widget.totalPages) {
                widget.onAction('jumpToPage', data: pageNumber);
              } else {
                _pageController.text = widget.currentPage.toString();
              }
            },
            onEditingComplete: () {
              setState(() {
                _isEditingPage = false;
              });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            '/ ${widget.totalPages}',
            style: TextStyle(
              fontSize: compact ? 12 : 14,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ),
        ),
      ],
    );
  }

  // Zoom out button
  Widget _buildZoomOutButton(bool isDark, {bool compact = false}) {
    final canZoomOut = widget.zoomLevel > 1.0;
    return IconButton(
      icon: Icon(
        Icons.zoom_out,
        size: compact ? 20 : 24,
      ),
      onPressed: canZoomOut ? () => widget.onAction('zoomOut') : null,
      tooltip: 'Alejar',
      color: isDark ? Colors.white : Colors.black87,
      disabledColor: Colors.grey,
    );
  }

  // Zoom in button
  Widget _buildZoomInButton(bool isDark, {bool compact = false}) {
    final canZoomIn = widget.zoomLevel < 3.0;
    return IconButton(
      icon: Icon(
        Icons.zoom_in,
        size: compact ? 20 : 24,
      ),
      onPressed: canZoomIn ? () => widget.onAction('zoomIn') : null,
      tooltip: 'Acercar',
      color: isDark ? Colors.white : Colors.black87,
      disabledColor: Colors.grey,
    );
  }

  // Zoom percentage button (opens dropdown)
  Widget _buildZoomPercentageButton(ThemeData theme, bool isDark,
      {bool compact = false}) {
    return TextButton(
      onPressed: () => widget.onAction('zoomPercentage'),
      style: TextButton.styleFrom(
        foregroundColor: isDark ? Colors.white : Colors.black87,
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 8 : 12,
          vertical: compact ? 4 : 8,
        ),
      ),
      child: Text(
        '${(widget.zoomLevel * 100).round()}%',
        style: TextStyle(
          fontSize: compact ? 12 : 14,
        ),
      ),
    );
  }

  // Search button
  Widget _buildSearchButton(bool isDark, {bool compact = false}) {
    return IconButton(
      icon: Icon(
        Icons.search,
        size: compact ? 20 : 24,
      ),
      onPressed: () => widget.onAction('search'),
      tooltip: 'Buscar',
      color: isDark ? Colors.white : Colors.black87,
    );
  }

  // Settings button
  Widget _buildSettingsButton(bool isDark, {bool compact = false}) {
    return IconButton(
      icon: Icon(
        Icons.settings,
        size: compact ? 20 : 24,
      ),
      onPressed: () => widget.onAction('settings'),
      tooltip: 'Configuración',
      color: isDark ? Colors.white : Colors.black87,
    );
  }

  // Download button
  Widget _buildDownloadButton(bool isDark, {bool compact = false}) {
    return IconButton(
      icon: Icon(
        Icons.download,
        size: compact ? 20 : 24,
      ),
      onPressed: () => widget.onAction('download'),
      tooltip: 'Descargar',
      color: isDark ? Colors.white : Colors.black87,
    );
  }

  // Annotation toggle button
  Widget _buildAnnotationToggleButton(ThemeData theme, bool isDark,
      {bool compact = false}) {
    return IconButton(
      icon: Icon(
        widget.showAnnotationToolbar ? Icons.edit : Icons.edit_outlined,
        size: compact ? 20 : 24,
      ),
      onPressed: () => widget.onAction('toggleAnnotations'),
      tooltip: widget.showAnnotationToolbar
          ? 'Ocultar anotaciones'
          : 'Mostrar anotaciones',
      color: isDark ? Colors.white : Colors.black87,
    );
  }

  // Build annotation toolbar (secondary toolbar)
  Widget _buildAnnotationToolbar(ThemeData theme, bool isDark) {
    return Container(
      height: widget.isDesktopWeb ? 48 : 44,
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.grey[200],
        border: Border(
          top: BorderSide(
            color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
            width: 1,
          ),
        ),
      ),
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: widget.isDesktopWeb ? 16.0 : 8.0),
        child: Row(
          children: [
            // Text markup tools
            _buildHighlightButton(theme, isDark),
            const SizedBox(width: 4),
            _buildUnderlineButton(theme, isDark),
            const SizedBox(width: 4),
            _buildStrikethroughButton(theme, isDark),
            const SizedBox(width: 4),
            _buildSquigglyButton(theme, isDark),

            // Conditional buttons when annotation is selected
            if (widget.selectedAnnotation != null) ...[
              _buildDivider(),
              _buildDeleteAnnotationButton(isDark),
              const SizedBox(width: 4),
              _buildLockAnnotationButton(isDark),
            ],
          ],
        ),
      ),
    );
  }

  // Highlight button
  Widget _buildHighlightButton(ThemeData theme, bool isDark) {
    final isActive =
        widget.currentAnnotationMode == PdfAnnotationMode.highlight;

     return _buildIconButton(
      theme: theme,
      isDark: isDark,
      isActive: isActive,
      icon: Icons.highlight,
      tooltip: "Resaltar",
      onPressed: () => widget.onAction('highlight'),
    );
  }

  // Underline button
  Widget _buildUnderlineButton(ThemeData theme, bool isDark) {
    final isActive =
        widget.currentAnnotationMode == PdfAnnotationMode.underline;

    return _buildIconButton(
      theme: theme,
      isDark: isDark,
      isActive: isActive,
      icon: Icons.format_underlined,
      tooltip: "Subrayar",
      onPressed: () => widget.onAction('underline'),
    );
  }

  // Strikethrough button
  Widget _buildStrikethroughButton(ThemeData theme, bool isDark) {
    final isActive =
        widget.currentAnnotationMode == PdfAnnotationMode.strikethrough;

    return _buildIconButton(
      theme: theme,
      isDark: isDark,
      isActive: isActive,
      icon: Icons.format_strikethrough,
      tooltip: "Tachar",
      onPressed: () => widget.onAction('strikethrough'),
    );
  }

  // Squiggly underline button
  Widget _buildSquigglyButton(ThemeData theme, bool isDark) {
    final isActive = widget.currentAnnotationMode == PdfAnnotationMode.squiggly;

    return _buildIconButton(
      theme: theme,
      isDark: isDark,
      isActive: isActive,
      icon: Icons.format_underlined,
      tooltip: "Subrayado ondulado",
      onPressed: () => widget.onAction('squiggly'),
    );
  }

  Widget _buildIconButton({
    required ThemeData theme,
    required bool isDark,
    required bool isActive,
    required IconData icon,
    required String tooltip,
    required void Function()? onPressed,
  }) {
    return IconButton.filled(
      icon: Icon(icon, size: 20),
      onPressed: onPressed,
      tooltip: tooltip,
      style: isActive
          ? theme.iconButtonTheme.style
          : IconButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: isDark ? Colors.white : Colors.black87,
            ),
    );
  }

  // Delete annotation button
  Widget _buildDeleteAnnotationButton(bool isDark) {
    return IconButton(
      icon: const Icon(Icons.delete, size: 20),
      onPressed: () => widget.onAction('deleteAnnotation'),
      tooltip: 'Eliminar anotación',
      color: isDark ? Colors.red[300] : Colors.red[700],
    );
  }

  // Lock annotation button
  Widget _buildLockAnnotationButton(bool isDark) {
    final isLocked = widget.selectedAnnotation?.isLocked ?? false;
    return IconButton(
      icon: Icon(
        isLocked ? Icons.lock : Icons.lock_open,
        size: 20,
      ),
      onPressed: () => widget.onAction('lockAnnotation'),
      tooltip: isLocked ? 'Desbloquear anotación' : 'Bloquear anotación',
      color: isDark ? Colors.white : Colors.black87,
    );
  }
}
