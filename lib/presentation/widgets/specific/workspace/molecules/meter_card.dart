import 'package:flutter/material.dart';
import 'package:frontend_water_quality/domain/models/meter_model.dart';
import 'package:frontend_water_quality/presentation/widgets/common/molecules/base_card.dart';

class MeterCard extends StatelessWidget {
  final String id;
  final String name;
  final String state;
  final Location location; 
  final void Function()? onTap;

  const MeterCard({
    super.key,
    required this.id,
    required this.name,
    required this.state,
    required this.location, 
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget iconAvatar = Icon(Icons.lock_outlined);
  
    return BaseCard(
      title: name,
      chip: Chip(
        avatar: iconAvatar,
        label: Text(state),
      ),
      onTap: onTap,
    );
  }
}
