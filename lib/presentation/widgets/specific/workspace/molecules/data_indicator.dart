import 'package:flutter/material.dart';

class DataIndicator extends StatefulWidget {
  final bool active;
  const DataIndicator({super.key, required this.active});

  @override
  State<DataIndicator> createState() => _DataIndicatorState();
}

class _DataIndicatorState extends State<DataIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );
    _scale = Tween<double>(begin: 1.0, end: 1.4).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // If mounted initially active, pulse once.
    if (widget.active) {
      _controller.forward().then((_) => _controller.reverse());
    }
  }

  @override
  void didUpdateWidget(covariant DataIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Pulse on each rebuild while active.
    if (widget.active) {
      _controller.forward(from: 0.0).then((_) => _controller.reverse());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.active ? Colors.green : Colors.grey;
    return SizedBox(
      width: 40,
      height: 40,
      child: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final s = _scale.value;
            final boxShadows = widget.active
                ? [
                    BoxShadow(
                      color: Colors.green.withAlpha(115),
                      blurRadius: 8 * s,
                      spreadRadius: 1 * (s - 1),
                    ),
                  ]
                : null;

            return Transform.scale(
              scale: s,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  boxShadow: boxShadows,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
