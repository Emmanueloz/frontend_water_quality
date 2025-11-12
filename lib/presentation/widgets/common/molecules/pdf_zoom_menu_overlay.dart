import 'package:flutter/material.dart';

/// Zoom percentage menu overlay for PDF viewer
///
/// Provides predefined zoom levels for quick selection
class PdfZoomMenuOverlay extends StatelessWidget {
  final double currentZoomLevel;
  final Function(double) onZoomLevelSelected;
  final VoidCallback onClose;

  const PdfZoomMenuOverlay({
    super.key,
    required this.currentZoomLevel,
    required this.onZoomLevelSelected,
    required this.onClose,
  });

  static const List<double> _zoomLevels = [
    0.5, // 50%
    0.75, // 75%
    1.0, // 100%
    1.25, // 125%
    1.5, // 150%
    2.0, // 200%
    3.0, // 300%
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 150,
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[850] : Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: _zoomLevels.length,
          itemBuilder: (context, index) {
            final zoomLevel = _zoomLevels[index];
            final isSelected = (currentZoomLevel - zoomLevel).abs() < 0.01;
            final percentage = (zoomLevel * 100).round();

            return ListTile(
              dense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              title: Text(
                '$percentage%',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected
                      ? (isDark ? Colors.blue[300] : Colors.blue[700])
                      : (isDark ? Colors.white : Colors.black87),
                ),
              ),
              trailing: isSelected
                  ? Icon(
                      Icons.check,
                      size: 18,
                      color: isDark ? Colors.blue[300] : Colors.blue[700],
                    )
                  : null,
              onTap: () {
                onZoomLevelSelected(zoomLevel);
                onClose();
              },
            );
          },
        ),
      ),
    );
  }
}
