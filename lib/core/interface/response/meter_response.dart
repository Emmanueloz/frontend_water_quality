import 'package:frontend_water_quality/core/interface/response/base_response.dart';
import 'package:frontend_water_quality/domain/models/meter_model.dart';

class MeterResponse extends BaseResponse {
  final List<Meter>? meters;
  final Meter? meter;

  MeterResponse({
    super.message,
    super.detail,
    this.meters,
    this.meter,
  });

  factory MeterResponse.fromJson(Map<String, dynamic> json) {
    List<Meter>? metersList;
    Meter? singleMeter;

    // Procesar lista de medidores
    if (json['meters'] != null) {
      metersList = (json['meters'] as List)
          .map((meterJson) => Meter.fromJson(meterJson))
          .toList();
    }

    // Procesar medidor individual
    if (json['meter'] != null) {
      singleMeter = Meter.fromJson(json['meter']);
    }

    return MeterResponse(
      message: json["message"],
      detail: json["detail"],
      meters: metersList,
      meter: singleMeter,
    );
  }
} 