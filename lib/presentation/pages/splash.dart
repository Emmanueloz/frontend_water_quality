import 'package:flutter/material.dart';
import 'package:frontend_water_quality/router/routes.dart';
import 'package:go_router/go_router.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Text("Splash"),
          ElevatedButton(
            onPressed: () {
              context.go(Routes.login);
            },
            child: const Text('Go to List Workspace'),
          ),
        ],
      ),
    );
  }
}
