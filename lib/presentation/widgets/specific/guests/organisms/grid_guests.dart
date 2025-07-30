import 'package:flutter/material.dart';
import 'package:frontend_water_quality/domain/models/guests.dart';
import 'package:frontend_water_quality/presentation/widgets/common/atoms/base_container.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/workspace/molecules/button_actions.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/guests/molecules/guests_cards.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';

class GuestGrid extends StatelessWidget {
  final List<Guest> guests;
  final ScreenSize screenSize;
  final String title;
  final String workspaceId;
  final VoidCallback? onAddPressed;

  const GuestGrid({
    super.key,
    required this.guests,
    required this.screenSize,
    required this.workspaceId,
    this.title = "Invitados",
    this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    return _buildMain(context);
  }

  Widget _buildMain(BuildContext context) {
    final config = _gridConfig(screenSize);

    return BaseContainer(
      margin: screenSize == ScreenSize.mobile || screenSize == ScreenSize.tablet
          ? const EdgeInsets.all(10)
          : EdgeInsets.zero,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ButtonActions(
            title: Text(
              title,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: onAddPressed != null ? [
              ElevatedButton.icon(
                onPressed: onAddPressed!,
                icon: const Icon(Icons.person_add),
                label: const Text("Agregar Invitado"),
              ),
            ] : [],
            screenSize: screenSize,
          ),
          const SizedBox(height: 16),
          _gridBuilder(context, config),
        ],
      ),
    );
  }

  Widget _gridBuilder(BuildContext context, _GridConfig config) {
    return Expanded(
      child: SingleChildScrollView(
        child: GridView.count(
          crossAxisCount: config.crossAxisCount,
          childAspectRatio: config.childAspectRatio,
          crossAxisSpacing: config.gap,
          mainAxisSpacing: config.gap,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: guests.map((guest) => GuestCard(
            guest: guest,
            workspaceId: workspaceId,
          )).toList(),
        ),
      ),
    );
  }

  _GridConfig _gridConfig(ScreenSize screenSize) {
    switch (screenSize) {
      case ScreenSize.mobile:
        return _GridConfig(
            crossAxisCount: 1, childAspectRatio: 1 / 0.5, gap: 5);
      case ScreenSize.tablet:
        return _GridConfig(
            crossAxisCount: 2, childAspectRatio: 1 / 0.6, gap: 5);
      case ScreenSize.smallDesktop:
        return _GridConfig(
            crossAxisCount: 3, childAspectRatio: 1 / 0.6, gap: 10);
      default:
        return _GridConfig(
            crossAxisCount: 4, childAspectRatio: 1 / 0.6, gap: 16);
    }
  }
}

class _GridConfig {
  final int crossAxisCount;
  final double childAspectRatio;
  final double gap;

  _GridConfig({
    required this.crossAxisCount,
    required this.childAspectRatio,
    required this.gap,
  });
}
