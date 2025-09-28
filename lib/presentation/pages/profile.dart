import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/constants/profile_ui.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/domain/models/user.dart';
import 'package:frontend_water_quality/presentation/providers/user_provider.dart';
import 'package:frontend_water_quality/presentation/widgets/common/atoms/base_container.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/profile/profile_header.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/profile/user_info_card.dart';
import 'package:provider/provider.dart';
import 'package:frontend_water_quality/core/interface/result.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  Future<void> _handleSubmit(BuildContext context, User updatedUser) async {
    final provider = context.read<UserProvider>();
    final resultMessage = await provider.updateUser(updatedUser);
    if (resultMessage != null && context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(resultMessage)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.read<UserProvider>();

    return Layout(
      title: 'Perfil',
      builder: (context, screenSize) {
        return FutureBuilder<Result<User>>(
          future: userProvider.getUser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  "Error: ${snapshot.error}",
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            if (!snapshot.hasData || !snapshot.data!.isSuccess) {
              return const Center(
                child: Text(
                  'No se encontró información del usuario',
                  style: TextStyle(color: Colors.red),
                ),
              );
            }

            final user = snapshot.data!.value!;
            return _buildProfileContent(screenSize, user, context);
          },
        );
      },
    );
  }

  Widget _buildProfileContent(
      ScreenSize screenSize, User user, BuildContext context) {
    final content = _ProfileContent(
      screenSize: screenSize,
      user: user,
      onSave: (updatedUser) => _handleSubmit(context, updatedUser),
    );
    if (screenSize != ScreenSize.mobile && screenSize != ScreenSize.tablet) {
      return Align(alignment: Alignment.topCenter, child: content);
    }
    return SingleChildScrollView(child: content);
  }
}

class _ProfileContent extends StatelessWidget {
  final ScreenSize screenSize;
  final User user;
  final Future<void> Function(User) onSave;
  const _ProfileContent({
    required this.screenSize,
    required this.user,
    required this.onSave,
  });

  bool get _isMobileOrTablet =>
      screenSize == ScreenSize.mobile || screenSize == ScreenSize.tablet;

  @override
  Widget build(BuildContext context) {
    return BaseContainer(
      width: _getCardWidth(),
      height: _getCardHeight(),
      margin: EdgeInsets.symmetric(
        vertical: ProfileConstants.verticalPadding,
        horizontal: ProfileConstants.horizontalPadding,
      ),
      child: Column(
        children: [
          _ProfileCard(user: user, width: _getCardWidth()),
          UserInfoCard(
            user: user,
            width: _getCardWidth(),
          ),
        ],
      ),
    );
  }

  double _getCardWidth() =>
      _isMobileOrTablet ? double.infinity : ProfileConstants.profileCardWidth;
  double _getCardHeight() => _isMobileOrTablet
      ? ProfileConstants.profileCardHeightMobile
      : ProfileConstants.profileCardHeightDesktop;
}

class _ProfileCard extends StatelessWidget {
  final User user;
  final double width;
  const _ProfileCard({required this.user, required this.width});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: width,
      padding: const EdgeInsets.all(ProfileConstants.horizontalPadding),
      decoration: BoxDecoration(
        color: colorScheme.primary,
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
      decoration: BoxDecoration(
        color: colorScheme.secondary,
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
