import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

/// Settings menu overlay for PDF viewer
///
/// Provides configuration options for:
/// - Page layout mode (continuous vs page-by-page)
/// - Scroll direction (vertical vs horizontal)
class PdfSettingsMenuOverlay extends StatefulWidget {
  final PdfPageLayoutMode initialLayoutMode;
  final PdfScrollDirection initialScrollDirection;
  final Function(PdfPageLayoutMode) onLayoutModeChanged;
  final Function(PdfScrollDirection) onScrollDirectionChanged;
  final VoidCallback onClose;

  const PdfSettingsMenuOverlay({
    super.key,
    required this.initialLayoutMode,
    required this.initialScrollDirection,
    required this.onLayoutModeChanged,
    required this.onScrollDirectionChanged,
    required this.onClose,
  });

  @override
  State<PdfSettingsMenuOverlay> createState() => _PdfSettingsMenuOverlayState();
}

class _PdfSettingsMenuOverlayState extends State<PdfSettingsMenuOverlay> {
  late PdfPageLayoutMode _currentLayoutMode;
  late PdfScrollDirection _currentScrollDirection;

  @override
  void initState() {
    super.initState();
    _currentLayoutMode = widget.initialLayoutMode;
    _currentScrollDirection = widget.initialScrollDirection;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 280,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[850] : Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Configuración',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: widget.onClose,
                  tooltip: 'Cerrar',
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Layout mode section
            Text(
              'Modo de visualización',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
            const SizedBox(height: 8),
            _buildLayoutModeOption(
              context,
              isDark,
              'Continuo',
              'Desplazamiento continuo',
              PdfPageLayoutMode.continuous,
            ),
            _buildLayoutModeOption(
              context,
              isDark,
              'Página por página',
              'Una página a la vez',
              PdfPageLayoutMode.single,
            ),

            const Divider(height: 24),

            // Scroll direction section
            Text(
              'Dirección de desplazamiento',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
            const SizedBox(height: 8),
            _buildScrollDirectionOption(
              context,
              isDark,
              'Vertical',
              Icons.swap_vert,
              PdfScrollDirection.vertical,
            ),
            _buildScrollDirectionOption(
              context,
              isDark,
              'Horizontal',
              Icons.swap_horiz,
              PdfScrollDirection.horizontal,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLayoutModeOption(
    BuildContext context,
    bool isDark,
    String title,
    String subtitle,
    PdfPageLayoutMode mode,
  ) {
    final isSelected = _currentLayoutMode == mode;

    return InkWell(
      onTap: () {
        setState(() {
          _currentLayoutMode = mode;
        });
        widget.onLayoutModeChanged(mode);
      },
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Row(
          children: [
            Radio<PdfPageLayoutMode>(
              value: mode,
              groupValue: _currentLayoutMode,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _currentLayoutMode = value;
                  });
                  widget.onLayoutModeChanged(value);
                }
              },
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white60 : Colors.black45,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScrollDirectionOption(
    BuildContext context,
    bool isDark,
    String title,
    IconData icon,
    PdfScrollDirection direction,
  ) {
    final isSelected = _currentScrollDirection == direction;

    return InkWell(
      onTap: () {
        setState(() {
          _currentScrollDirection = direction;
        });
        widget.onScrollDirectionChanged(direction);
      },
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Row(
          children: [
            Radio<PdfScrollDirection>(
              value: direction,
              groupValue: _currentScrollDirection,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _currentScrollDirection = value;
                  });
                  widget.onScrollDirectionChanged(value);
                }
              },
            ),
            const SizedBox(width: 8),
            Icon(
              icon,
              size: 20,
              color: isSelected
                  ? (isDark ? Colors.blue[300] : Colors.blue[700])
                  : (isDark ? Colors.white70 : Colors.black54),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
