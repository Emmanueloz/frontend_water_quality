import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/meter_connection/meter_pairing_status.dart';
import 'package:frontend_water_quality/presentation/providers/blue_provider.dart';
import 'package:frontend_water_quality/presentation/providers/meter_provider.dart';
import 'package:frontend_water_quality/presentation/providers/auth_provider.dart';
import 'package:frontend_water_quality/core/enums/pairing_state.dart';
import 'package:frontend_water_quality/core/errors/pairing_error.dart';
import 'package:frontend_water_quality/core/interface/result.dart';
import 'package:frontend_water_quality/domain/models/pairing_response.dart';
import 'package:frontend_water_quality/domain/models/user.dart';
import 'package:frontend_water_quality/domain/repositories/auth_repo.dart';
import 'package:frontend_water_quality/domain/repositories/user_repo.dart';
import 'package:frontend_water_quality/domain/repositories/meter_repo.dart';

class MockBlueProvider extends BlueProvider {
  PairingState _mockPairingState = PairingState.unpaired;
  PairingError? _mockLastError;
  bool _mockIsConnected = false;

  MockBlueProvider() : super(null, null);

  void setMockPairingState(PairingState state, [PairingError? error]) {
    _mockPairingState = state;
    _mockLastError = error;
    notifyListeners();
  }

  void setMockConnected(bool connected) {
    _mockIsConnected = connected;
    notifyListeners();
  }

  @override
  PairingState get pairingState => _mockPairingState;

  @override
  PairingError? get lastError => _mockLastError;

  @override
  bool get isConnected => _mockIsConnected;

  @override
  Future<bool> setApiKey(String token) async {
    if (!_mockIsConnected) {
      setMockPairingState(PairingState.error, PairingError.connectionLost());
      return false;
    }
    if (token.isEmpty) {
      setMockPairingState(PairingState.error, PairingError.invalidToken());
      return false;
    }
    setMockPairingState(PairingState.pairing);
    await Future.delayed(Duration(milliseconds: 100));
    setMockPairingState(PairingState.paired);
    return true;
  }

  @override
  Future<void> validateToken() async {
    setMockPairingState(PairingState.checking);
    await Future.delayed(Duration(milliseconds: 100));
    setMockPairingState(PairingState.paired);
  }

  @override
  void setValidationContext({
    required String userToken,
    required String workspaceId,
    required String meterId,
  }) {
    // Mock implementation
  }
}

class MockMeterProvider extends MeterProvider {
  Result<PairingResponse>? mockPairMeterResult;

  MockMeterProvider() : super(MockMeterRepo(), MockAuthProvider());

  void setMockPairMeterResult(Result<PairingResponse> result) {
    mockPairMeterResult = result;
  }

  @override
  Future<Result<PairingResponse>> pairMeter(String idWorkspace, String idMeter) async {
    return mockPairMeterResult ?? Result.failure('Mock not configured');
  }
}

class MockMeterRepo implements MeterRepo {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockAuthProvider extends AuthProvider {
  User? _mockUser;
  String? _mockToken;

  MockAuthProvider() : super(MockAuthRepo(), MockUserRepo());

  void setMockUser(User? user, String? token) {
    _mockUser = user;
    _mockToken = token;
  }

  @override
  User? get user => _mockUser;

  @override
  String? get token => _mockToken;

  @override
  bool get isAuthenticated => _mockUser != null && _mockToken != null;
}

class MockAuthRepo implements AuthRepo {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockUserRepo implements UserRepo {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('MeterPairingStatus Widget Tests', () {
    late MockBlueProvider mockBlueProvider;
    late MockMeterProvider mockMeterProvider;
    late MockAuthProvider mockAuthProvider;

    setUp(() {
      mockBlueProvider = MockBlueProvider();
      mockMeterProvider = MockMeterProvider();
      mockAuthProvider = MockAuthProvider();
      
      // Set default authenticated user
      mockAuthProvider.setMockUser(
        User(uid: 'test_user', email: 'test@example.com'),
        'test_token',
      );
    });

    Widget createTestWidget({
      String? deviceToken,
      Function(String)? onTokenUpdated,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: MultiProvider(
            providers: [
              ChangeNotifierProvider<BlueProvider>.value(value: mockBlueProvider),
              ChangeNotifierProvider<MeterProvider>.value(value: mockMeterProvider),
              ChangeNotifierProvider<AuthProvider>.value(value: mockAuthProvider),
            ],
            child: MeterPairingStatus(
              idWorkspace: 'workspace_1',
              idMeter: 'meter_1',
              deviceToken: deviceToken,
              onTokenUpdated: onTokenUpdated,
            ),
          ),
        ),
      );
    }

    group('Widget Rendering', () {
      testWidgets('should render pairing status widget', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        expect(find.text('Estado de Emparejamiento'), findsOneWidget);
        expect(find.byType(MeterPairingStatus), findsOneWidget);
      });

      testWidgets('should show unpaired state initially', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        expect(find.text('Medidor no emparejado'), findsOneWidget);
        expect(find.byIcon(Icons.warning), findsOneWidget);
      });

      testWidgets('should show pairing button when unpaired', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        expect(find.text('Emparejar Medidor'), findsOneWidget);
        expect(find.byIcon(Icons.link), findsOneWidget);
      });
    });

    group('State Transitions', () {
      testWidgets('should show checking state', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        
        mockBlueProvider.setMockPairingState(PairingState.checking);
        await tester.pump();

        expect(find.text('Validando token del medidor...'), findsOneWidget);
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets('should show paired state', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        
        mockBlueProvider.setMockPairingState(PairingState.paired);
        await tester.pump();

        expect(find.text('Medidor emparejado correctamente'), findsOneWidget);
        expect(find.byIcon(Icons.check), findsOneWidget);
        expect(find.text('Emparejar Medidor'), findsNothing);
      });

      testWidgets('should show pairing state', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        
        mockBlueProvider.setMockPairingState(PairingState.pairing);
        await tester.pump();

        expect(find.text('Emparejando medidor...'), findsOneWidget);
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets('should show error state', (WidgetTester tester) async {
        final error = PairingError.networkTimeout(); // Use retryable error
        await tester.pumpWidget(createTestWidget());
        
        mockBlueProvider.setMockPairingState(PairingState.error, error);
        await tester.pump();

        expect(find.text('Error en el emparejamiento'), findsOneWidget);
        expect(find.byIcon(Icons.error), findsOneWidget);
        expect(find.text('Reintentar'), findsOneWidget);
      });
    });

    group('Error Handling', () {
      testWidgets('should show error details when error occurs', (WidgetTester tester) async {
        final error = PairingError.networkTimeout();
        await tester.pumpWidget(createTestWidget());
        
        mockBlueProvider.setMockPairingState(PairingState.error, error);
        await tester.pump();

        expect(find.text('Detalles del Error'), findsOneWidget);
        expect(find.text(error.message), findsAtLeastNWidgets(1));
      });

      testWidgets('should show retry button for retryable errors', (WidgetTester tester) async {
        final error = PairingError.networkTimeout(); // Retryable error
        await tester.pumpWidget(createTestWidget());
        
        mockBlueProvider.setMockPairingState(PairingState.error, error);
        await tester.pump();

        expect(find.text('Reintentar'), findsOneWidget);
        expect(find.text('Validar Token'), findsOneWidget);
      });

      testWidgets('should show help button for non-retryable errors', (WidgetTester tester) async {
        final error = PairingError.unauthorized(); // Non-retryable error
        await tester.pumpWidget(createTestWidget());
        
        mockBlueProvider.setMockPairingState(PairingState.error, error);
        await tester.pump();

        expect(find.text('Ayuda'), findsOneWidget);
        expect(find.text('Reintentar'), findsNothing);
      });
    });

    group('User Interactions', () {
      testWidgets('should handle pairing button press successfully', (WidgetTester tester) async {
        String? updatedToken;
        mockBlueProvider.setMockConnected(true);
        mockMeterProvider.setMockPairMeterResult(
          Result.success(PairingResponse(message: 'Success', token: 'new_token_123')),
        );

        await tester.pumpWidget(createTestWidget(
          onTokenUpdated: (token) => updatedToken = token,
        ));

        await tester.tap(find.text('Emparejar Medidor'));
        await tester.pump();
        await tester.pump(Duration(milliseconds: 200)); // Wait for async operations

        expect(updatedToken, equals('new_token_123'));
        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text('Medidor emparejado exitosamente'), findsOneWidget);
      });

      testWidgets('should handle pairing failure when not connected', (WidgetTester tester) async {
        mockBlueProvider.setMockConnected(false);

        await tester.pumpWidget(createTestWidget());

        await tester.tap(find.text('Emparejar Medidor'));
        await tester.pump();
        await tester.pump(Duration(milliseconds: 100));

        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text('Error: No hay conexión Bluetooth con el medidor. Conecta el medidor primero.'), findsOneWidget);
      });

      testWidgets('should handle pairing failure when not authenticated', (WidgetTester tester) async {
        mockAuthProvider.setMockUser(null, null);

        await tester.pumpWidget(createTestWidget());

        await tester.tap(find.text('Emparejar Medidor'));
        await tester.pump();
        await tester.pump(Duration(milliseconds: 100));

        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text('Error: Usuario no autenticado. Inicia sesión nuevamente.'), findsOneWidget);
      });

      testWidgets('should handle API pairing failure', (WidgetTester tester) async {
        mockBlueProvider.setMockConnected(true);
        mockMeterProvider.setMockPairMeterResult(
          Result.failure('Server error'),
        );

        await tester.pumpWidget(createTestWidget());

        await tester.tap(find.text('Emparejar Medidor'));
        await tester.pump();
        await tester.pump(Duration(milliseconds: 100));

        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text('Server error'), findsOneWidget);
      });

      testWidgets('should handle validate token button press', (WidgetTester tester) async {
        final error = PairingError.networkTimeout();
        mockBlueProvider.setMockPairingState(PairingState.error, error);

        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        await tester.tap(find.text('Validar Token'));
        await tester.pump();
        await tester.pump(Duration(milliseconds: 200));

        // Should transition through checking to paired
        expect(mockBlueProvider.pairingState, equals(PairingState.paired));
      });

      testWidgets('should show help dialog when help button is pressed', (WidgetTester tester) async {
        final error = PairingError.unauthorized();
        mockBlueProvider.setMockPairingState(PairingState.error, error);

        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        await tester.tap(find.text('Ayuda'));
        await tester.pumpAndSettle();

        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.text('Ayuda para Resolver el Error'), findsOneWidget);
        expect(find.text('Tu sesión ha expirado. Cierra la aplicación e inicia sesión nuevamente.'), findsOneWidget);
      });
    });

    group('Visual Indicators', () {
      testWidgets('should show correct icon for each state', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        // Test unpaired state
        mockBlueProvider.setMockPairingState(PairingState.unpaired);
        await tester.pump();
        expect(find.byIcon(Icons.warning), findsOneWidget);

        // Test paired state
        mockBlueProvider.setMockPairingState(PairingState.paired);
        await tester.pump();
        expect(find.byIcon(Icons.check), findsOneWidget);

        // Test error state
        mockBlueProvider.setMockPairingState(PairingState.error, PairingError.tokenMismatch());
        await tester.pump();
        expect(find.byIcon(Icons.error), findsOneWidget);

        // Test checking state
        mockBlueProvider.setMockPairingState(PairingState.checking);
        await tester.pump();
        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        // Test pairing state
        mockBlueProvider.setMockPairingState(PairingState.pairing);
        await tester.pump();
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets('should show correct status messages', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        // Test unpaired message
        mockBlueProvider.setMockPairingState(PairingState.unpaired);
        await tester.pump();
        expect(find.text('Medidor no emparejado'), findsOneWidget);
        expect(find.text('Haz clic en "Emparejar Medidor" para sincronizar'), findsOneWidget);

        // Test paired message
        mockBlueProvider.setMockPairingState(PairingState.paired);
        await tester.pump();
        expect(find.text('Medidor emparejado correctamente'), findsOneWidget);
        expect(find.text('El medidor está sincronizado con la aplicación'), findsOneWidget);

        // Test checking message
        mockBlueProvider.setMockPairingState(PairingState.checking);
        await tester.pump();
        expect(find.text('Validando token del medidor...'), findsOneWidget);
        expect(find.text('Verificando la conexión con el servidor'), findsOneWidget);

        // Test pairing message
        mockBlueProvider.setMockPairingState(PairingState.pairing);
        await tester.pump();
        expect(find.text('Emparejando medidor...'), findsOneWidget);
        expect(find.text('Enviando token de seguridad al dispositivo'), findsOneWidget);
      });
    });

    group('Callback Handling', () {
      testWidgets('should call onTokenUpdated when pairing succeeds', (WidgetTester tester) async {
        String? receivedToken;
        mockBlueProvider.setMockConnected(true);
        mockMeterProvider.setMockPairMeterResult(
          Result.success(PairingResponse(message: 'Success', token: 'callback_token')),
        );

        await tester.pumpWidget(createTestWidget(
          onTokenUpdated: (token) => receivedToken = token,
        ));

        await tester.tap(find.text('Emparejar Medidor'));
        await tester.pump();
        await tester.pump(Duration(milliseconds: 200));

        expect(receivedToken, equals('callback_token'));
      });

      testWidgets('should not call onTokenUpdated when pairing fails', (WidgetTester tester) async {
        String? receivedToken;
        mockBlueProvider.setMockConnected(false);

        await tester.pumpWidget(createTestWidget(
          onTokenUpdated: (token) => receivedToken = token,
        ));

        await tester.tap(find.text('Emparejar Medidor'));
        await tester.pump();
        await tester.pump(Duration(milliseconds: 100));

        expect(receivedToken, isNull);
      });
    });
  });
}