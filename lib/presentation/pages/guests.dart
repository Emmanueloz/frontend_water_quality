import 'package:flutter/material.dart';
import 'package:frontend_water_quality/domain/models/guests.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/responsive_screen_size.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/guests/organisms/grid_guests.dart';

class GuestsPage extends StatelessWidget {
  final String id;
  final String title;

  const GuestsPage({super.key, required this.id, required this.title});

  @override
  Widget build(BuildContext context) {
    final screenSize = ResponsiveScreenSize.getScreenSize(context);
    final guests = [
      Guest(name: 'Alice Smith', email: 'alice@example.com'),
      Guest(name: 'Bob Johnson', email: 'bob@example.com'),
      Guest(name: 'Charlie Brown', email: 'charlie@example.com'),
      Guest(name: 'Dana Lee', email: 'dana@example.com'),
    ];

    return GuestGrid(
      guests: guests,
      screenSize: screenSize,
    );
  }
}
