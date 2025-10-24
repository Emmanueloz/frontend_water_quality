import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/responsive_screen_size.dart';

class BaseCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? tag;
  final IconData? icon;
  final Chip? chip;
  final String? state;
  final void Function()? onTap;

  const BaseCard({
    super.key,
    required this.title,
    this.subtitle,
    this.chip,
    this.onTap,
    this.tag,
    this.icon,
    this.state,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = ResponsiveScreenSize.getScreenSize(context);
    final isMobileOrTablet = screenSize == ScreenSize.mobile || screenSize == ScreenSize.tablet;

    return Card(
      color: Color(0xFFF4F8F9).withAlpha(38),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // esquinas redondeadas
      ),
      clipBehavior: Clip.antiAlias, // para que el borde se recorte bien
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            // color: Color(0xFFF4F8F9).withAlpha(38),
            border: Border(
              left: BorderSide(
                color: theme.colorScheme.tertiary,
                width: 10,
              ),
            ),
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 18.0, horizontal: 20.0),
            child: Stack(
              children: [
                // Contenido principal (columna con título y ubicación)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // verificar si el title tiene mas de 15 caracteres y en ese caso reducir el tamaño de la fuente
                    Text(
                      title.length > 15 && isMobileOrTablet
                          ? '${title.substring(0, 13)}\n${title.substring(13)}'
                          : title,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 14),
                    if (tag != null)
                      Text(
                        tag!,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onPrimary.withAlpha(185),
                        ),
                      ),
                    const SizedBox(height: 10),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          height: 1.25,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    // espacio flexible
                    const SizedBox(height: 6),
                  ],
                ),
                const Spacer(),
                // Status pill (esquina superior derecha)
                if (state != null)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      // margin: const EdgeInsets.only(top: 6),
                      decoration: BoxDecoration(
                        color:
                            theme.colorScheme.primary.withValues(alpha: 0.62),
                        borderRadius: BorderRadius.circular(19),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 6,
                        children: [
                          Text(
                            state!,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Icon(
                            icon,
                            size: 18,
                            color: theme.colorScheme.tertiary,
                          ),
                        ],
                      ),
                    ),
                  ),
                if (chip != null)
                  Align(
                    alignment: Alignment.bottomRight,
                    child: chip!,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
