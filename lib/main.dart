import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/theme/theme.dart';
import 'package:frontend_water_quality/infrastructure/auth_repo_impl.dart';
import 'package:frontend_water_quality/infrastructure/dio_provider.dart';
import 'package:frontend_water_quality/presentation/providers/auth_provider.dart';
import 'package:frontend_water_quality/router/app_router.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  var dio = DioProvider.createDio();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(AuthRepoImpl(dio)),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Water Quality App',
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.router, // Usa directamente la instancia router
      debugShowCheckedModeBanner: false,
    );
  }
}
