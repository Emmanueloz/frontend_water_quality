import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend_water_quality/presentation/providers/theme_provider.dart';

/// An animated icon button for theme switching
/// Features scale, rotation, and color transitions
class ThemeToggleButton extends StatefulWidget {
  final double size;
  final Duration animationDuration;
  final bool showTooltip;

  const ThemeToggleButton({
    super.key,
    this.size = 35.0,
    this.animationDuration = const Duration(milliseconds: 400),
    this.showTooltip = true,
  });

  @override
  State<ThemeToggleButton> createState() => _ThemeToggleButtonState();
}

class _ThemeToggleButtonState extends State<ThemeToggleButton>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _scaleController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;

  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _rotationController,
        curve: Curves.elasticOut,
      ),
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.8,
    ).animate(
      CurvedAnimation(
        parent: _scaleController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  Future<void> _handleThemeToggle() async {
    if (_isAnimating) return;

    setState(() => _isAnimating = true);

    // Scale down
    await _scaleController.forward();

    // Toggle theme
    final themeProvider = context.read<ThemeProvider>();
    await themeProvider.toggleTheme();

    // Rotate
    _rotationController.forward(from: 0.0);

    // Scale up
    await _scaleController.reverse();

    setState(() => _isAnimating = false);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;
    final theme = Theme.of(context);

    final button = AnimatedBuilder(
      animation: Listenable.merge([_rotationController, _scaleController]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Transform.rotate(
            angle: _rotationAnimation.value * 6.28318, // 360 degrees
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: isDark
                      ? [
                          theme.colorScheme.primary,
                          theme.colorScheme.secondary,
                        ]
                      : [
                          theme.colorScheme.tertiary,
                          theme.colorScheme.primary,
                        ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _handleThemeToggle,
                  customBorder: const CircleBorder(),
                  child: Center(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) {
                        return RotationTransition(
                          turns: animation,
                          child: FadeTransition(
                            opacity: animation,
                            child: child,
                          ),
                        );
                      },
                      child: Icon(
                        isDark ? Icons.dark_mode : Icons.light_mode,
                        key: ValueKey(isDark),
                        color: Colors.white,
                        size: widget.size * 0.5,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    if (widget.showTooltip) {
      return Tooltip(
        message: isDark ? 'Cambiar a modo claro' : 'Cambiar a modo oscuro',
        child: button,
      );
    }

    return button;
  }
}
