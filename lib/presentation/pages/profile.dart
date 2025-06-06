import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/constants/profile_ui.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/profile/profile_header.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/profile/user_info_card.dart';


// Modelo para datos del usuario
class UserProfile {
  final String name;
  final String email;
  final String phone;
  final String role;

  const UserProfile({
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
  });
}

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: 'Perfil',
      builder: (context, screenSize) => _buildProfileContent(screenSize),
    );
  }

  Widget _buildProfileContent(ScreenSize screenSize) {
    final content = _ProfileContent(screenSize: screenSize);
    
    if (_isDesktop(screenSize)) {
      return Center(child: content);
    }
    return SingleChildScrollView(
      child: content,
    );
  }

  bool _isDesktop(ScreenSize screenSize) {
    return screenSize != ScreenSize.mobile && screenSize != ScreenSize.tablet;
  }
}

class _ProfileContent extends StatelessWidget {
  final ScreenSize screenSize;

  const _ProfileContent({required this.screenSize});

  bool get _isMobileOrTablet =>
      screenSize == ScreenSize.mobile || screenSize == ScreenSize.tablet;

  // Datos del usuario (en una app real vendría de un provider/bloc)
  UserProfile get _userProfile => const UserProfile(
    name: 'Marcos esp',
    email: 'mrlsp.452@gmail.com',
    phone: '919 453 2398',
    role: 'cliente',
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: ProfileConstants.horizontalPadding,
          vertical: ProfileConstants.verticalPadding,
        ),
        child: Column(
          children: [
            _ProfileCard(
              user: _userProfile,
              width: _getCardWidth(),
            ),
            UserInfoCard(
              user: _userProfile,
              width: _getCardWidth(),
            ),
          ],
        ),
      );
  }

  double _getCardWidth() {
    return _isMobileOrTablet 
        ? double.infinity 
        : ProfileConstants.profileCardWidth;
  }
}

class _ProfileCard extends StatelessWidget {
  final UserProfile user;
  final double width;

  const _ProfileCard({
    required this.user,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      width: width,
      padding: const EdgeInsets.all(ProfileConstants.horizontalPadding),
      decoration: BoxDecoration(
        color: colorScheme.primary, // Color principal del header
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(ProfileConstants.cardBorderRadius),
        ),
      ),
      child: Row(
        children: [
          _ProfileAvatar(),
          const SizedBox(width: 20),
          ProfileHeader(user: user),
        ],
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      width: ProfileConstants.avatarSize,
      height: ProfileConstants.avatarSize,
      decoration:  BoxDecoration(
        color: colorScheme.secondary, // Color de fondo del avatar
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.person,
        color: colorScheme.primary,
        size: 30,
      ),
    );
  }
}
