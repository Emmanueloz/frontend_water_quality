import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/constants/profile_ui.dart';

class ProfileInfoField extends StatelessWidget {
  final String label;
  final String value;

  const ProfileInfoField({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 7),
          child: Text(
            label,
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.secondary, 
              fontSize: 14,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Color(0xFFEFEFEF), // Fondo del campo
            borderRadius: BorderRadius.circular(ProfileConstants.fieldBorderRadius),
          ),
          child: TextFormField(
            initialValue: value,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(10),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(ProfileConstants.fieldBorderRadius),
                borderSide: BorderSide(color: theme.colorScheme.primary),
                ),
              labelStyle: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.secondary,
                fontSize: 14,
                fontWeight: FontWeight.w300,
              ),
            ),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.secondary, // Color del texto del valor
            ),
          ),
        ),
      ],
    );
  }
}