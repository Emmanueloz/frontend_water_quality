import 'package:flutter/material.dart';
import 'package:frontend_water_quality/domain/models/guests.dart';
import 'package:frontend_water_quality/presentation/providers/guest_provider.dart';
import 'package:frontend_water_quality/presentation/widgets/common/molecules/empty_state_view.dart';
import 'package:frontend_water_quality/presentation/widgets/common/organisms/grid_loading_skeleton.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/responsive_screen_size.dart';
import 'package:frontend_water_quality/presentation/pages/form_invite_guest.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/guests/organisms/grid_guests.dart';
import 'package:provider/provider.dart';

class GuestsPage extends StatefulWidget {
  final String id;
  final String title;

  const GuestsPage({super.key, required this.id, required this.title});

  @override
  State<GuestsPage> createState() => _GuestsPageState();
}

class _GuestsPageState extends State<GuestsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final guestProvider = context.read<GuestProvider>();
      guestProvider.setWorkspaceId(widget.id);
      guestProvider.loadGuests(widget.id);
    });
  }

  void _navigateToInviteForm() {
    print('GuestsPage: _navigateToInviteForm called');
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FormInviteGuestPage(
          workspaceId: widget.id,
          workspaceTitle: widget.title,
        ),
      ),
    ).then((_) {
      print('GuestsPage: form page closed, reloading guests');
      final guestProvider = context.read<GuestProvider>();
      guestProvider.loadGuests(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final guestProvider = context.watch<GuestProvider>();
    final screenSize = ResponsiveScreenSize.getScreenSize(context);

    if (guestProvider.isLoading) {
      return GridLoadingSkeleton(screenSize: screenSize);
    }

    // Solo mostrar error real (no estado vacío)
    if (guestProvider.errorMessage != null && 
        guestProvider.errorMessage != 'No se encontraron invitados') {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.grey[600],
            ),
            const SizedBox(height: 16),
            Text(
              guestProvider.errorMessage!,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                guestProvider.cleanError();
                guestProvider.loadGuests(widget.id);
              },
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    return GuestGrid(
      guests: guestProvider.guests,
      screenSize: screenSize,
      title: widget.title,
      workspaceId: widget.id,
      onAddPressed: _navigateToInviteForm,
    );
  }
}
