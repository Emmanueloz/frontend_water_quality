import 'package:flutter/material.dart';
import 'package:frontend_water_quality/domain/models/guests.dart';
import 'package:frontend_water_quality/presentation/widgets/common/molecules/base_card.dart';

class GuestCard extends StatelessWidget {
  final Guest guest;

  const GuestCard({super.key, required this.guest});

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      title: guest.name,
      subtitle: guest.email,
      chip: Chip(
        label: const Text('Invitado'),
        visualDensity: VisualDensity.compact,
        labelStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: const Color(0xFFF7FAFA), // color surface
            ),
      ),
    );
  }
}
