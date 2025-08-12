import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/presentation/providers/guest_provider.dart';
import 'package:frontend_water_quality/presentation/widgets/common/atoms/base_container.dart';
import 'package:frontend_water_quality/presentation/widgets/common/organisms/grid_loading_skeleton.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/responsive_screen_size.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/guests/organisms/grid_guests.dart';
import 'package:frontend_water_quality/router/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class GuestsPage extends StatefulWidget {
  final String id;
  final String title;

  const GuestsPage({
    super.key,
    required this.id,
    required this.title,
  });

  @override
  State<GuestsPage> createState() => _GuestsPageState();
}

class _GuestsPageState extends State<GuestsPage> {
  @override
  void initState() {
    super.initState();
    // Solo cargar invitados si no están ya cargados para este workspace
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final guestProvider = context.read<GuestProvider>();
      if (guestProvider.currentWorkspaceId != widget.id) {
        guestProvider.setWorkspaceId(widget.id);
        guestProvider.loadGuests(widget.id);
      }
    });
  }

  void _navigateToInviteForm() {
    context.goNamed(
      Routes.createGuest.name,
      pathParameters: {'id': widget.id},
    );
  }

  void _reloadGuests() {
    final guestProvider = context.read<GuestProvider>();
    guestProvider.forceReload();
  }

  @override
  Widget build(BuildContext context) {
    final guestProvider = context.watch<GuestProvider>();
    final screenSize = ResponsiveScreenSize.getScreenSize(context);

    return _buildMain(context, screenSize, guestProvider);
  }

  Widget _buildMain(BuildContext context, ScreenSize screenSize, GuestProvider guestProvider) {
    // Configurar márgenes responsivos
    final margin = screenSize == ScreenSize.mobile || screenSize == ScreenSize.tablet
        ? const EdgeInsets.all(10)
        : EdgeInsets.zero;

    if (guestProvider.isLoading) {
      return BaseContainer(
        margin: margin,
        child: Column(
          children: [
            Expanded(
              child: GridLoadingSkeleton(screenSize: screenSize),
            ),
          ],
        ),
      );
    }

    // Solo mostrar error real (no estado vacío)
    if (guestProvider.errorMessage != null && 
        guestProvider.errorMessage != 'No se encontraron invitados') {
      return BaseContainer(
        margin: margin,
        child: Center(
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
        ),
      );
    }

    return Container(
      margin: margin,
      child: GuestGrid(
        guests: guestProvider.guests,
        screenSize: screenSize,
        title: widget.title,
        workspaceId: widget.id,
        onAddPressed: _navigateToInviteForm,
        onReloadPressed: _reloadGuests,
      ),
    );
  }
}
