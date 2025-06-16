import 'package:frontend_water_quality/core/enums/meter_state.dart';

class MeterItem {
  final String id;
  final String name;
  final MeterState state;

  MeterItem({required this.id, required this.name, required this.state});
}
