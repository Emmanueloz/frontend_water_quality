import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/core/enums/type_workspace.dart';

class WorkspaceCard extends StatelessWidget {
  final String id;
  final String title;
  final String owner;
  final TypeWorkspace? type;
  final void Function()? onTap;
  final ScreenSize screenSize;

  const WorkspaceCard({
    super.key,
    required this.id,
    required this.title,
    required this.owner,
    required this.type,
    this.onTap,
    required this.screenSize,
  });

  /// Obtiene las dimensiones responsivas según el tamaño de pantalla
  Map<String, double> _getResponsiveDimensions() {
    switch (screenSize) {
      case ScreenSize.mobile:
        return {
          'headerHeight': 46.0,
          'iconSize': 26.0,
          'iconContainerSize': 46.0,
          'leftPadding': 16.0,
          'contentPadding': 5.0,
        };
      case ScreenSize.tablet:
        return {
          'headerHeight': 60.0,
          'iconSize': 26.0,
          'iconContainerSize': 46.0,
          'leftPadding': 20.0,
          'contentPadding': 5.0,
        };
      case ScreenSize.smallDesktop:
        return {
          'headerHeight': 60.0,
          'iconSize': 36.0,
          'iconContainerSize': 56.0,
          'leftPadding': 20.0,
          'contentPadding': 5.0,
        };
      case ScreenSize.largeDesktop:
        return {
          'headerHeight': 60.0,
          'iconSize': 36.0,
          'iconContainerSize': 56.0,
          'leftPadding': 20,
          'contentPadding': 5.0,
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final dims = _getResponsiveDimensions();

    final headerHeight = dims['headerHeight']!;
    final iconSize = dims['iconSize']!;
    final iconContainerSize = dims['iconContainerSize']!;
    final leftPadding = dims['leftPadding']!;
    final contentPadding = dims['contentPadding']!;

    final headerColor = cs.primary;
    final bodyTextColor = cs.onSurface;
    final iconColor = cs.tertiary;

    Widget iconAvatar = Icon(
      type == TypeWorkspace.private
          ? Icons.lock_outline
          : Icons.public_outlined,
      color: iconColor,
      size: iconSize,
    );

    const borderRadius = 12.0;
    final iconTopOffset = headerHeight * 0.5;

    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(borderRadius),
        onTap: onTap,
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              child: Column(
                children: [
                  // Cabecera
                  Container(
                    height: headerHeight,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: headerColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(borderRadius),
                        topRight: Radius.circular(borderRadius),
                      ),
                    ),
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: contentPadding),
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.primaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Cuerpo (Expanded para ocupar el resto del espacio; dentro,
                  // SingleChildScrollView para permitir scroll cuando sea necesario)
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      color: cs.shadow,
                      padding: EdgeInsets.only(
                        top: iconContainerSize - (iconContainerSize * 0.4),
                        left: leftPadding,
                        right: contentPadding,
                        bottom: contentPadding,
                      ),
                      child: SingleChildScrollView(
                        // El scroll sólo se activa cuando el contenido no cabe.
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Propietario:',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: bodyTextColor.withValues(alpha: 0.62),
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              owner,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: bodyTextColor,
                                fontWeight: FontWeight.w400,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Icono circular solapado
            Positioned(
              top: iconTopOffset,
              left: leftPadding,
              child: Container(
                height: iconContainerSize,
                width: iconContainerSize,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: headerColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: iconAvatar,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
