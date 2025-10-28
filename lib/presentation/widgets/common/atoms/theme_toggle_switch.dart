import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend_water_quality/presentation/providers/theme_provider.dart';

/// A modern animated toggle switch for theme switching
/// Features smooth transitions and visual feedback
class ThemeToggleSwitch extends StatefulWidget {
  final double width;
  final double height;
  final Duration animationDuration;

  const ThemeToggleSwitch({
    super.key,
    this.width = 60.0,
    this.height = 32.0,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  @override
  State<ThemeToggleSwitch> createState() => _ThemeToggleSwitchState();
}

class _ThemeToggleSwitchState extends State<ThemeToggleSwitch>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _toggleAnimation;
  late Animation<double> _iconRotation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _toggleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _iconRotation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;

    // Sync animation with theme state
    if (isDark && _controller.value != 1.0) {
      _controller.forward();
    } else if (!isDark && _controller.value != 0.0) {
      _controller.reverse();
    }

    return GestureDetector(
      onTap: () async {
        await themeProvider.toggleTheme();
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.height / 2),
              gradient: LinearGradient(
                colors: [
                  Color.lerp(
                    const Color(0xFFFFD93D), // Light mode yellow
                    const Color(0xFF1E3A8A), // Dark mode blue
                    _toggleAnimation.value,
                  )!,
                  Color.lerp(
                    const Color(0xFFFFA500), // Light mode orange
                    const Color(0xFF0F172A), // Dark mode dark blue
                    _toggleAnimation.value,
                  )!,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Color.lerp(
                    Colors.orange.withOpacity(0.3),
                    Colors.blue.withOpacity(0.3),
                    _toggleAnimation.value,
                  )!,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Animated thumb
                AnimatedPositioned(
                  duration: widget.animationDuration,
                  curve: Curves.easeInOut,
                  left: isDark
                      ? widget.width - widget.height + 4
                      : 4,
                  top: 4,
                  child: Container(
                    width: widget.height - 8,
                    height: widget.height - 8,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Transform.rotate(
                      angle: _iconRotation.value * 3.14159, // 180 degrees
                      child: Icon(
                        isDark ? Icons.nightlight_round : Icons.wb_sunny,
                        size: widget.height - 16,
                        color: Color.lerp(
                          const Color(0xFFFF8C00),
                          const Color(0xFF1E3A8A),
                          _toggleAnimation.value,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
