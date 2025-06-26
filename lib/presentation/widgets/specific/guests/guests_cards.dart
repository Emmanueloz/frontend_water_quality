// lib/presentation/widgets/molecules/guest_card.dart
import 'package:flutter/material.dart';
import '../../../../domain/models/guests.dart';

class GuestCard extends StatelessWidget {
  final Guest guest;

  const GuestCard({super.key, required this.guest});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(guest.name, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(guest.email, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
