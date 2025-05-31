import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Layout(
        title: 'Perfil',
        builder: (context, screenSize) {
          if (screenSize == ScreenSize.mobile ||
              screenSize == ScreenSize.tablet) {
            return _MainContent(screenSize: screenSize);
          }
          return Center(child: _MainContent(screenSize: screenSize));
        });
  }
}

class _MainContent extends StatelessWidget {
  final ScreenSize screenSize;
  bool get isMobileOrTablet =>
      screenSize == ScreenSize.mobile || screenSize == ScreenSize.tablet;

  const _MainContent({
    required this.screenSize,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
      child: Column(
        children: [
          // Card principal del perfil
          Container(
            width: isMobileOrTablet ? double.infinity : 800,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF4A7C7A),
              borderRadius:
                  BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Color(0xFF7DD3C0),
                    size: 30,
                  ),
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Marcos esp',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFF7DD3C0),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'cliente',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
    
          // const SizedBox(height: 32),
    
          // Información del usuario
          Container(
            
            width: isMobileOrTablet ? double.infinity : 800,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            decoration: BoxDecoration(
              color: const Color(0xFFf7fafa),
              borderRadius:
                  BorderRadius.vertical(bottom: Radius.circular(12)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _ProfileInfoItem(
                  label: 'Nombre de usuario',
                  value: 'Marcos esp',
                ),
                SizedBox(height: 20),
                _ProfileInfoItem(
                  label: 'Correo electrónico',
                  value: 'mrlsp.452@gmail.com',
                ),
                SizedBox(height: 20),
                _ProfileInfoItem(
                  label: 'Teléfono',
                  value: '919 453 2398',
                ),
                SizedBox(height: 20),
                _ProfileInfoItem(
                  label: 'Rol',
                  value: 'cliente',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileInfoItem extends StatelessWidget {
  final String label;
  final String value;

  const _ProfileInfoItem({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 7),
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFF145C57),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: Color(0xffefefef),
            borderRadius: BorderRadius.circular(3),
          ),
          child: Text(
            value,
            style: const TextStyle(
              color: Color(0xff145c57),
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
