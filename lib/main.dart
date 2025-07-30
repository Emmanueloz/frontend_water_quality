import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/theme/theme.dart';
import 'package:frontend_water_quality/infrastructure/auth_repo_impl.dart';
import 'package:frontend_water_quality/infrastructure/dio_provider.dart';
import 'package:frontend_water_quality/infrastructure/guest_repo_impl.dart';
import 'package:frontend_water_quality/infrastructure/workspace_repo_impl.dart';
import 'package:frontend_water_quality/presentation/providers/auth_provider.dart';
import 'package:frontend_water_quality/presentation/providers/guest_provider.dart';
import 'package:frontend_water_quality/presentation/providers/workspace_provider.dart';
import 'package:frontend_water_quality/router/app_router.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var dio = DioProvider.createDio();

  final AuthProvider authProvider = AuthProvider(AuthRepoImpl(dio));
  final WorkspaceRepoImpl workspaceRepo = WorkspaceRepoImpl(dio);
  await authProvider.loadSettings();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => authProvider,
        ),
        ChangeNotifierProxyProvider<AuthProvider, WorkspaceProvider>(
          create: (context) => WorkspaceProvider(
            workspaceRepo,
            context.read<AuthProvider>(),
          ),
          update: (context, authProvider, workspaceProvider) {
            workspaceProvider!.clean();
            return workspaceProvider..setAuthProvider(authProvider);
          },
        ),
        ChangeNotifierProxyProvider<AuthProvider, GuestProvider>(
          create: (context) {
            final authProvider = context.read<AuthProvider>();
            final dio = DioProvider.createDio();
            if (authProvider.token != null) {
              dio.options.headers['Authorization'] = 'Bearer ${authProvider.token}';
            }
            final guestProvider = GuestProvider(
              GuestRepositoryImpl(dio),
              authProvider,
            );
            return guestProvider;
          },
          update: (context, authProvider, previousGuestProvider) {
            final dio = DioProvider.createDio();
            if (authProvider.token != null) {
              dio.options.headers['Authorization'] = 'Bearer ${authProvider.token}';
            }
            final guestProvider = GuestProvider(
              GuestRepositoryImpl(dio),
              authProvider,
            );
            if (previousGuestProvider != null) {
              guestProvider.clean();
            }
            return guestProvider;
          },
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
      title: 'Aqua Minds',
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.router, // Usa directamente la instancia router
      debugShowCheckedModeBanner: false,
    );
  }
}
