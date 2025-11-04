import 'package:flutter/material.dart';

enum ActionButtonStyle {
  filled,   // Botón con fondo sólido (ElevatedButton)
  outlined, // Botón con borde (OutlinedButton)
}

class ActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final ActionButtonStyle style;
  final Color? foregroundColor;
  final Color? backgroundColor;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final double? width; // Nuevo parámetro opcional

  const ActionButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.style = ActionButtonStyle.filled,
    this.foregroundColor,
    this.backgroundColor,
    this.borderRadius = 8.0,
    this.padding = const EdgeInsets.symmetric(vertical: 14),
    this.width, // si es null, el botón adaptará su ancho al entorno (Expanded, Row, etc.)
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color primary = theme.colorScheme.primary;
    final Color onPrimary = theme.colorScheme.onSecondary;

    // Colores por defecto según estilo
    final Color fg = foregroundColor ??
        (style == ActionButtonStyle.filled ? onPrimary : primary);
    final Color bg = backgroundColor ??
        (style == ActionButtonStyle.filled ? primary : Colors.transparent);

    Widget button;
    switch (style) {
      case ActionButtonStyle.outlined:
        button = OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: theme.colorScheme.tertiary, width: 1),
            backgroundColor: bg,
            foregroundColor: fg,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            padding: padding,
            textStyle: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          child: Text(label, style: TextStyle(color: theme.colorScheme.onPrimary),),
        );
        break;

      case ActionButtonStyle.filled:
        button = ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: bg,
            foregroundColor: fg,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            padding: padding,
            textStyle: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          child: Text(label, style: TextStyle(color: theme.colorScheme.surface),),
        );
        break;
    }

    // Si width se ha especificado, envolvemos en SizedBox; si no, devolvemos el button directo
    if (width != null) {
      return SizedBox(width: width, child: button);
    } else {
      return button;
    }
  }
}
