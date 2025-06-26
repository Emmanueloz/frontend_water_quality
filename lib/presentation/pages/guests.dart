import 'package:flutter/material.dart';
import '../../domain/models/guests.dart';
import '../widgets/specific/guests/atoms/add-guests.dart';
import '../widgets/specific/guests/organisms/grid_guests.dart';

class GuestsPage extends StatelessWidget {
  final String title;

  const GuestsPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final List<Guest> guests = [
      Guest(name: 'Alice Smith', email: 'alice@example.com'),
      Guest(name: 'Bob Johnson', email: 'bob@example.com'),
      Guest(name: 'Charlie Brown', email: 'charlie@example.com'),
      Guest(name: 'Dana Lee', email: 'dana@example.com'),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: AddButton(onPressed: null),
            ),
            const SizedBox(height: 16),
            Expanded(child: GuestGrid(guests: guests)),
          ],
        ),
      ),
    );
  }
}
