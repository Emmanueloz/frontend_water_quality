import 'package:flutter/material.dart';
import 'package:frontend_water_quality/domain/models/guests.dart';
import 'package:frontend_water_quality/presentation/widgets/common/molecules/base_card.dart';
import 'package:frontend_water_quality/router/routes.dart';
import 'package:go_router/go_router.dart';

class GuestCard extends StatelessWidget {
  final Guest guest;
  final String workspaceId;
  final String workspaceTitle;

  const GuestCard({
    super.key,
    required this.guest,
    required this.workspaceId,
    required this.workspaceTitle,
  });

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      title: guest.name,
      subtitle: guest.email,
      chip: Chip(label: Text(_translateRole(guest.role))),
      onTap: () => _showGuestDetails(context),
    );
  }

  String _translateRole(String role) {
    switch (role.toLowerCase()) {
      case 'visitor':
        return 'VISITANTE';
      case 'manager':
        return 'GERENTE';
      case 'administrator':
        return 'ADMINISTRADOR';
      default:
        return role.toUpperCase();
    }
  }

  void _showGuestDetails(BuildContext context) {
    // Validar que el guestId no esté vacío
    if (guest.id.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error: ID de invitado no válido'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    context.goNamed(
      Routes.editGuest.name,
      pathParameters: {
        'id': workspaceId,
        'guestId': guest.id,
      },
    );
  }
}
