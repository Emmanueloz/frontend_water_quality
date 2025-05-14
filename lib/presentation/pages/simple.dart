import 'package:flutter/material.dart';
import 'package:frontend_water_quality/router/routes.dart';
import 'package:go_router/go_router.dart';

class Simple extends StatelessWidget {
  final String title;
  const Simple({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Text(title),
          ElevatedButton(
            onPressed: () {
              context.go(Routes.listWorkspace.path);
            },
            child: const Text('Go to List Workspace'),
          ),
        ],
      ),
    );
  }
}
