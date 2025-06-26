// lib/presentation/widgets/organisms/guest_grid.dart
import 'package:flutter/material.dart';
import '../../../../../domain/models/guests.dart';
import '../molecules/guests_cards.dart';

class GuestGrid extends StatelessWidget {
  final List<Guest> guests;

  const GuestGrid({super.key, required this.guests});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: guests.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 2.7,
      ),
      itemBuilder: (context, index) {
        return GuestCard(guest: guests[index]);
      },
    );
  }
}
