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

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  void _loadUser() async {
    final provider = context.read<UserProvider>();
    setState(() => _isLoading = true);
    await provider.getUser(); 
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _handleSubmit(User updatedUser) async {
    setState(() => _isLoading = true);
    final provider = context.read<UserProvider>();
    final resultMessage = await provider.updateUser(updatedUser);

    if (resultMessage != null && context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(resultMessage)));
    }

    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final user = userProvider.user;

    return Layout(
      title: 'Perfil',
      builder: (context, screenSize) {
        if (_isLoading || userProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (userProvider.errorMessage != null) {
          return Center(
            child: Text(
              userProvider.errorMessage!,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (user == null) {
          return const Center(
            child: Text(
              'No se encontró información del usuario',
              style: TextStyle(color: Colors.red),
            ),
          );
        }

        return _buildProfileContent(screenSize, user);
      },
    );
  }

  Widget _buildProfileContent(ScreenSize screenSize, User user) {
    final content = _ProfileContent(
      screenSize: screenSize,
      user: user,
      onSave: _handleSubmit,
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

  double _getCardHeight() =>
      _isMobileOrTablet
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
