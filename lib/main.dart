import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/theme/theme.dart';
import 'package:frontend_water_quality/infrastructure/auth_repo_impl.dart';
import 'package:frontend_water_quality/infrastructure/dio_provider.dart';
import 'package:frontend_water_quality/infrastructure/meter_records_repo_impl.dart';
import 'package:frontend_water_quality/infrastructure/meter_socket_service.dart';
import 'package:frontend_water_quality/infrastructure/weather_meter_repo_impl.dart';
import 'package:frontend_water_quality/infrastructure/workspace_repo_impl.dart';
import 'package:frontend_water_quality/presentation/providers/auth_provider.dart';
import 'package:frontend_water_quality/presentation/providers/weather_meter_provider.dart';
import 'package:frontend_water_quality/presentation/providers/workspace_provider.dart';
import 'package:frontend_water_quality/router/app_router.dart';
import 'package:provider/provider.dart';
import 'package:frontend_water_quality/presentation/providers/meter_record_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var dio = DioProvider.createDio();

  final AuthProvider authProvider = AuthProvider(AuthRepoImpl(dio));
  final WorkspaceRepoImpl workspaceRepo = WorkspaceRepoImpl(dio);
  final WeatherMeterRepoImpl weatherMeterRepo = WeatherMeterRepoImpl(dio);
  final MeterSocketService meterSocketService = MeterSocketService();
  final MeterRecordsRepoImpl meterRecordsRepo = MeterRecordsRepoImpl(dio);
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
        ChangeNotifierProxyProvider<AuthProvider, MeterRecordProvider>(
          create: (context) => MeterRecordProvider(
            meterSocketService,
            meterRecordsRepo,
            context.read<AuthProvider>(),
          ),
          update: (context, authProvider, meterProvider) {
            meterProvider!.clean();
            return meterProvider..setAuthProvider(authProvider);
          },
        ),
        ChangeNotifierProxyProvider<AuthProvider, WeatherMeterProvider>(
          create: (context) => WeatherMeterProvider(
            weatherMeterRepo,
            context.read<AuthProvider>(),
          ),
          update: (context, authProvider, weatherMeterProvider) {
            weatherMeterProvider!.clean();
            return weatherMeterProvider..setAuthProvider(authProvider);
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
