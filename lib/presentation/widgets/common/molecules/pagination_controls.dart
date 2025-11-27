import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/interface/pagination_state.dart';

class PaginationControls extends StatelessWidget {
  final PaginationState paginationState;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final ValueChanged<int?>? onLimitChanged;

  const PaginationControls({
    super.key,
    required this.paginationState,
    this.onPrevious,
    this.onNext,
    this.onLimitChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 8,
      children: [
        // Botón Anterior
        IconButton(
          onPressed: paginationState.isFirstPage ? null : onPrevious,
          icon: const Icon(Icons.chevron_left),
          tooltip: 'Página anterior',
        ),

        // Selector de límite
        DropdownButton<int>(
          value: paginationState.limit,
          items: const [
            DropdownMenuItem(value: 5, child: Text('5')),
            DropdownMenuItem(value: 10, child: Text('10')),
            DropdownMenuItem(value: 15, child: Text('15')),
            DropdownMenuItem(value: 20, child: Text('20')),
          ],
          onChanged: onLimitChanged,
          underline: Container(),
        ),

        // Botón Siguiente
        IconButton(
          onPressed: paginationState.hasMore ? onNext : null,
          icon: const Icon(Icons.chevron_right),
          tooltip: 'Página siguiente',
        ),
      ],
    );
  }
}
