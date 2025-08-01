import 'package:flutter/material.dart';
import 'package:frontend_water_quality/domain/models/guests.dart';
import 'package:frontend_water_quality/presentation/pages/form_invite_guest.dart';
import 'package:frontend_water_quality/presentation/providers/guest_provider.dart';
import 'package:frontend_water_quality/presentation/widgets/common/molecules/base_card.dart';
import 'package:provider/provider.dart';

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
      chip: _buildChip(context),
      onTap: () => _showGuestDetails(context),
    );
  }

  Chip _buildChip(BuildContext context) {
    String roleText = _translateRole(guest.role);
    
    return Chip(
      label: Text(
        roleText,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      backgroundColor: const Color(0xff145c57),
      visualDensity: VisualDensity.compact,
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
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FormInviteGuestPage(
          workspaceId: workspaceId,
          workspaceTitle: workspaceTitle,
          guest: guest,
        ),
      ),
    );
  }
}
