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
          'contentPadding': 12.0,
        };
      case ScreenSize.tablet:
        return {
          'headerHeight': 60.0,
          'iconSize': 60.0,
          'iconContainerSize': 70.0,
          'leftPadding': 20.0,
          'contentPadding': 14.0,
        };
      case ScreenSize.smallDesktop:
        return {
          'headerHeight': 66.0,
          'iconSize': 60.0,
          'iconContainerSize': 76.0,
          'leftPadding': 28.0,
          'contentPadding': 16.0,
        };
      case ScreenSize.largeDesktop:
        return {
          'headerHeight': 72.0,
          'iconSize': 64.0,
          'iconContainerSize': 82.0,
          'leftPadding': 32.0,
          'contentPadding': 18.0,
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
    final headerTextColor = cs.onPrimary;
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

    return Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(borderRadius),
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(borderRadius),
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Cuerpo de la tarjeta
              Container(
                color: Color(0xFFF4F8F9).withAlpha(38),
                width: double.infinity,
                margin: EdgeInsets.only(top: screenSize == ScreenSize.mobile ? headerHeight * 0.8 : headerHeight,),
                padding: EdgeInsets.only(
                  top: (iconContainerSize * 0.5) + 8,
                  left: leftPadding,
                  right: contentPadding,
                  bottom: contentPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      'Propietario:',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: bodyTextColor.withValues(alpha: 0.62),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      owner,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: bodyTextColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),

              // Cabecera
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: headerHeight,
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
                    style: theme.textTheme.displaySmall?.copyWith(
                      color: headerTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
      ),
    );
  }
}