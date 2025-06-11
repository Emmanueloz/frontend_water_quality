import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/constants/profile_ui.dart';

class ProfileInfoField extends StatelessWidget {
  final String label;
  final String value;
  final TextInputType? keyboardType;

  const ProfileInfoField({
    super.key,
    required this.label,
    required this.value,
    this.keyboardType = TextInputType.text,
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
        TextFormField(
              keyboardType: keyboardType,
              initialValue: value,
              decoration: InputDecoration(
                isDense: true,
                border: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(ProfileConstants.fieldBorderRadius),
                  borderSide: BorderSide(color: theme.colorScheme.primary, width: 1,),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(ProfileConstants.fieldBorderRadius),
                  borderSide: BorderSide(color: theme.colorScheme.primary, width: 1,),
                ),
                // filled: true,
                // fillColor: const Color(0xFFEFEFEF),
                contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(ProfileConstants.fieldBorderRadius),
                  borderSide: BorderSide(color: theme.colorScheme.primary, width: 1),
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
      ],
    );
  }
}