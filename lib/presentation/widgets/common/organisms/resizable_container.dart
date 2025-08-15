import 'package:flutter/material.dart';

class ResizableContainer extends StatefulWidget {
  final double? width;
  final double? height;
  final double minWidth;
  final double minHeight;
  final bool resizable;
  final Widget child;

  const ResizableContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.minWidth = 100,
    this.minHeight = 80,
    this.resizable = true,
  });

  @override
  State<ResizableContainer> createState() => _ResizableContainerState();
}

class _ResizableContainerState extends State<ResizableContainer> {
  late double _width;
  late double _height;

  bool _isResizingRight = false;
  bool _isResizingBottom = false;
  bool _isResizingCorner = false;

  final double _edgeSize = 8;

  @override
  void initState() {
    super.initState();
    _width = widget.width ?? 200;
    _height = widget.height ?? 150;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: _width,
          height: _height,
          child: widget.child,
        ),
        if (widget.resizable) ...[
          // Borde derecho visible
          Positioned(
            right: 0,
            top: 0,
            bottom: _edgeSize, // deja espacio para la esquina
            width: _edgeSize,
            child: MouseRegion(
              cursor: SystemMouseCursors.resizeLeftRight,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onPanStart: (_) => _isResizingRight = true,
                onPanEnd: (_) => _isResizingRight = false,
                onPanUpdate: (details) {
                  if (_isResizingRight) {
                    setState(() {
                      _width = (_width + details.delta.dx)
                          .clamp(widget.minWidth, double.infinity);
                    });
                  }
                },
                child: Container(
                  color: Theme.of(context)
                      .colorScheme
                      .tertiary
                      .withValues(alpha: _isResizingRight ? 1 : 0.5), // visible
                ),
              ),
            ),
          ),

          // Borde inferior visible
          Positioned(
            left: 0,
            right: _edgeSize, // deja espacio para la esquina
            bottom: 0,
            height: _edgeSize,
            child: MouseRegion(
              cursor: SystemMouseCursors.resizeUpDown,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onPanStart: (_) => _isResizingBottom = true,
                onPanEnd: (_) => _isResizingBottom = false,
                onPanUpdate: (details) {
                  if (_isResizingBottom) {
                    setState(() {
                      _height = (_height + details.delta.dy)
                          .clamp(widget.minHeight, double.infinity);
                    });
                  }
                },
                child: Container(
                  color: Theme.of(context).colorScheme.tertiary.withValues(
                      alpha: _isResizingBottom ? 1 : 0.5), // visible
                ),
              ),
            ),
          ),

          // Esquina inferior derecha visible
          Positioned(
            right: 0,
            bottom: 0,
            width: _edgeSize,
            height: _edgeSize,
            child: MouseRegion(
              cursor: SystemMouseCursors.resizeUpLeftDownRight,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onPanStart: (_) => _isResizingCorner = true,
                onPanEnd: (_) => _isResizingCorner = false,
                onPanUpdate: (details) {
                  if (_isResizingCorner) {
                    setState(() {
                      _width = (_width + details.delta.dx)
                          .clamp(widget.minWidth, double.infinity);
                      _height = (_height + details.delta.dy)
                          .clamp(widget.minHeight, double.infinity);
                    });
                  }
                },
                child: Container(
                  color: Theme.of(context)
                      .colorScheme
                      .tertiary, // más fuerte para esquina
                ),
              ),
            ),
          ),
        ]
      ],
    );
  }
}
