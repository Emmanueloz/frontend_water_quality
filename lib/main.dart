import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/theme/theme.dart';
import 'package:frontend_water_quality/infrastructure/auth_repo_impl.dart';
import 'package:frontend_water_quality/infrastructure/ble_service.dart';
import 'package:frontend_water_quality/infrastructure/dio_provider.dart';
import 'package:frontend_water_quality/infrastructure/meter_records_repo_impl.dart';
import 'package:frontend_water_quality/infrastructure/meter_socket_service.dart';
import 'package:frontend_water_quality/infrastructure/weather_meter_repo_impl.dart';
import 'package:frontend_water_quality/infrastructure/guest_repo_impl.dart';
import 'package:frontend_water_quality/infrastructure/alert_repo_impl.dart';
import 'package:frontend_water_quality/infrastructure/workspace_repo_impl.dart';
import 'package:frontend_water_quality/infrastructure/meter_repo_impl.dart';
import 'package:frontend_water_quality/presentation/providers/auth_provider.dart';
import 'package:frontend_water_quality/presentation/providers/weather_meter_provider.dart';
import 'package:frontend_water_quality/presentation/providers/guest_provider.dart';
import 'package:frontend_water_quality/presentation/providers/blue_provider.dart';
import 'package:frontend_water_quality/presentation/providers/workspace_provider.dart';
import 'package:frontend_water_quality/presentation/providers/meter_provider.dart';
import 'package:frontend_water_quality/router/app_router.dart';
import 'package:provider/provider.dart';
import 'package:frontend_water_quality/presentation/providers/meter_record_provider.dart';
import 'package:frontend_water_quality/presentation/providers/alert_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var dio = DioProvider.createDio();

  final AuthProvider authProvider = AuthProvider(AuthRepoImpl(dio));
  final WorkspaceRepoImpl workspaceRepo = WorkspaceRepoImpl(dio);
  final WeatherMeterRepoImpl weatherMeterRepo = WeatherMeterRepoImpl(dio);
  final MeterSocketService meterSocketService = MeterSocketService();
  final MeterRecordsRepoImpl meterRecordsRepo = MeterRecordsRepoImpl(dio);
  final MeterRepoImpl meterRepo = MeterRepoImpl(dio);
  final GuestRepositoryImpl guestRepo = GuestRepositoryImpl(dio);
  final AlertRepositoryImpl alertRepo = AlertRepositoryImpl(dio);
  await authProvider.loadSettings();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => authProvider,
        ),
        ProxyProvider<AuthProvider, WorkspaceProvider>(
          create: (context) => WorkspaceProvider(
            workspaceRepo,
            context.read<AuthProvider>(),
          ),
          update: (context, authProvider, workspaceProvider) {
            workspaceProvider!.clean();
            return workspaceProvider..setAuthProvider(authProvider);
          },
        ),
        ChangeNotifierProvider(
          create: (_) => BlueProvider(
            BLEService(),
          ),
        ),
        ProxyProvider<AuthProvider, MeterProvider>(
          create: (context) => MeterProvider(
            meterRepo,
            context.read<AuthProvider>(),
          ),
          update: (context, authProvider, meterProvider) {
            return meterProvider!..setAuthProvider(authProvider);
          },
        ),
        ChangeNotifierProxyProvider<AuthProvider, GuestProvider>(
          create: (context) {
            final authProvider = context.read<AuthProvider>();
            final guestProvider = GuestProvider(
              guestRepo,
              authProvider,
            );
            return guestProvider;
          },
          update: (context, authProvider, previousGuestProvider) {
            if (previousGuestProvider != null) {
              previousGuestProvider.setAuthProvider(authProvider);
              previousGuestProvider.clean();
            }
            return previousGuestProvider ??
                GuestProvider(guestRepo, authProvider);
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
        ChangeNotifierProxyProvider<AuthProvider, AlertProvider>(
          create: (context) {
            final authProvider = context.read<AuthProvider>();
            final alertProvider = AlertProvider(
              alertRepo,
              authProvider,
            );
            return alertProvider;
          },
          update: (context, authProvider, previousAlertProvider) {
            if (previousAlertProvider != null) {
              previousAlertProvider.setAuthProvider(authProvider);
              previousAlertProvider.clean();
            }
            return previousAlertProvider ??
                AlertProvider(alertRepo, authProvider);
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
