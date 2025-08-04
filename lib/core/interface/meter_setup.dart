import 'dart:convert';

class MeterSetup {
  final String? ssidWifi;
  final String? passwordWifi;
  final String? token;
  final double? ph4;
  final double? ph6;
  final String? state;

  MeterSetup({
    this.ssidWifi,
    this.passwordWifi,
    this.token,
    this.ph4,
    this.ph6,
    this.state,
  });

  factory MeterSetup.fromString(String data) =>
      MeterSetup.fromMap(jsonDecode(data));

  factory MeterSetup.fromMap(Map<String, dynamic> json) => MeterSetup(
        ssidWifi: json['wifiSSID'],
        passwordWifi: json['wifiPassword'],
        token: json['apiKey'],
        ph4: json['calibrationVol4'] != null
            ? double.tryParse(json['calibrationVol4'])
            : null,
        ph6: json['calibrationVol6'] != null
            ? double.tryParse(json['calibrationVol6'])
            : null,
        state: json['state'],
      );
}
