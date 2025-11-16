import 'package:flutter/material.dart';
import 'package:intl_mobile_field/country_picker_dialog.dart';
import 'package:intl_mobile_field/intl_mobile_field.dart';
import 'package:intl_mobile_field/mobile_number.dart';

class MobileField extends StatelessWidget {
  final TextEditingController controller;
  final InputDecoration inputDecoration;
  final String? initialCountryCode;
  final void Function(MobileNumber)? onChanged;
  const MobileField({
    super.key,
    required this.controller,
    this.inputDecoration = const InputDecoration(),
    this.initialCountryCode = "MX",
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return IntlMobileField(
      languageCode: "mx",
      controller: controller,
      pickerDialogStyle: PickerDialogStyle(
        width: 600,
        searchFieldInputDecoration: InputDecoration(
          label: Text("Buscar Pais"),
        ),
      ),
      initialCountryCode: initialCountryCode,
      invalidNumberMessage: "Numero de telefono invalido",
      decoration: inputDecoration,
      validator: (value) {
        if (value == null || value.number.isEmpty) {
          return 'Por favor, introduzca un número de móvil';
        }
        if (!RegExp(r'^[0-9]+$').hasMatch(value.number)) {
          return 'Solo se permiten dígitos';
        }
        return null;
      },
      onChanged: onChanged,
      countries: const [
        'AR',
        'BO',
        'BR',
        'BZ',
        'CA',
        'CL',
        'CO',
        'CR',
        'CU',
        'DO',
        'EC',
        'ES',
        'GT',
        'GY',
        'HN',
        'HT',
        'JM',
        'MX',
        'NI',
        'PA',
        'PE',
        'PR',
        'PY',
        'SR',
        'SV',
        'TT',
        'US',
        'UY',
        'VE'
      ],
    );
  }
}
