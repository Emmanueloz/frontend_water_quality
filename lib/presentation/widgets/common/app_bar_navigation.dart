import 'package:flutter/material.dart';
import 'package:frontend_water_quality/presentation/widgets/common/button_profile.dart';

class AppBarNavigation extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const AppBarNavigation({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications),
          onPressed: () {},
        ),
        ButtonProfile(
          username: "Username",
          email: "email@email.com",
          onPressed: () {},
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
