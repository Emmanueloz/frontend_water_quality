import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend_water_quality/presentation/providers/theme_provider.dart';

/// A minimalist icon button for theme switching
/// Perfect for app bars and toolbars
class ThemeToggleIconButton extends StatefulWidget {
  final double iconSize;
  final Color? lightModeColor;
  final Color? darkModeColor;
  final EdgeInsetsGeometry? padding;

  const ThemeToggleIconButton({
    super.key,
    this.iconSize = 24.0,
    this.lightModeColor,
    this.darkModeColor,
    this.padding,
  });

  @override
  State<ThemeToggleIconButton> createState() => _ThemeToggleIconButtonState();
}

class _ThemeToggleIconButtonState extends State<ThemeToggleIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  Future<void> _handleToggle() async {
    await _controller.forward();
    final themeProvider = context.read<ThemeProvider>();
    await themeProvider.toggleTheme();
    _controller.reset();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;
    final theme = Theme.of(context);

    final iconColor = isDark
        ? (widget.darkModeColor ?? theme.iconTheme.color)
        : (widget.lightModeColor ?? theme.iconTheme.color);

    return IconButton(
      padding: widget.padding,
      icon: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _controller.isAnimating
                ? _scaleAnimation.value
                : 1.0,
            child: Opacity(
              opacity: _controller.isAnimating
                  ? _fadeAnimation.value
                  : 1.0,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (child, animation) {
                  return ScaleTransition(
                    scale: animation,
                    child: RotationTransition(
                      turns: Tween<double>(begin: 0.5, end: 1.0)
                          .animate(animation),
                      child: child,
                    ),
                  );
                },
                child: Icon(
                  isDark ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
                  key: ValueKey(isDark),
                  size: widget.iconSize,
                  color: iconColor,
                ),
              ),
            ),
          );
        },
      ),
      onPressed: _handleToggle,
      tooltip: isDark ? 'Light mode' : 'Dark mode',
    );
  }
}
