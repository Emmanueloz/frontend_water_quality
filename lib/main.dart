import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/theme/theme.dart';
import 'package:frontend_water_quality/domain/models/storage_model.dart';
import 'package:frontend_water_quality/infrastructure/auth_repo_impl.dart';
import 'package:frontend_water_quality/infrastructure/ble_service.dart';
import 'package:frontend_water_quality/infrastructure/connectivity_provider.dart';
import 'package:frontend_water_quality/infrastructure/dio_helper.dart';
import 'package:frontend_water_quality/infrastructure/local_storage_service.dart';
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
  final dio = DioHelper.createDio();
  final StorageModel storageModel = await LocalStorageService.getAll();
  final AuthProvider authProvider = AuthProvider(
    AuthRepoImpl(dio),
  );

  await authProvider.loadSettings(storageModel);

  final MeterSocketService meterSocketService = MeterSocketService();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ConnectivityProvider>(
          create: (_) => ConnectivityProvider(dio),
        ),
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => authProvider,
        ),
        ChangeNotifierProxyProvider<AuthProvider, WorkspaceProvider>(
          create: (context) => WorkspaceProvider(
            WorkspaceRepoImpl(dio),
            context.read<AuthProvider>(),
          ),
          update: (context, authProvider, workspaceProvider) {
            return workspaceProvider!..setAuthProvider(authProvider);
          },
        ),
        ChangeNotifierProvider(
          create: (_) => BlueProvider(
            BLEService(),
          ),
        ),
        ChangeNotifierProxyProvider<AuthProvider, MeterProvider>(
          create: (context) => MeterProvider(
            MeterRepoImpl(dio),
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
              GuestRepositoryImpl(dio),
              authProvider,
            );
            return guestProvider;
          },
          update: (context, authProvider, previousGuestProvider) {
            previousGuestProvider!.clean();
            return previousGuestProvider..setAuthProvider(authProvider);
          },
        ),
        ChangeNotifierProxyProvider<AuthProvider, MeterRecordProvider>(
          create: (context) => MeterRecordProvider(
            meterSocketService,
            MeterRecordsRepoImpl(dio),
            context.read<AuthProvider>(),
          ),
          update: (context, authProvider, meterProvider) {
            meterProvider!.clean();
            return meterProvider..setAuthProvider(authProvider);
          },
        ),
        ChangeNotifierProxyProvider<AuthProvider, WeatherMeterProvider>(
          create: (context) => WeatherMeterProvider(
            WeatherMeterRepoImpl(dio),
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
              AlertRepositoryImpl(dio),
              authProvider,
            );
            return alertProvider;
          },
          update: (context, authProvider, previousAlertProvider) {
            previousAlertProvider!.clean();
            return previousAlertProvider..setAuthProvider(authProvider);
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
