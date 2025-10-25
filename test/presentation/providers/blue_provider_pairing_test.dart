import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_water_quality/presentation/providers/blue_provider.dart';
import 'package:frontend_water_quality/domain/repositories/meter_repo.dart';
import 'package:frontend_water_quality/core/interface/result.dart';
import 'package:frontend_water_quality/domain/models/pairing_response.dart';
import 'package:frontend_water_quality/core/enums/pairing_state.dart';
import 'package:frontend_water_quality/core/errors/pairing_error.dart';

// Simple test-focused BlueProvider that extends the real one
class TestableBlueProvider extends BlueProvider {
  bool _mockIsConnected = false;
  
  TestableBlueProvider(super.bleService, super.meterRepo);

  void setMockConnected(bool connected) {
    _mockIsConnected = connected;
    notifyListeners();
  }

  @override
  bool get isConnected => _mockIsConnected;
}

class MockMeterRepo implements MeterRepo {
  Result<bool>? mockValidateTokenResult;
  Result<PairingResponse>? mockPairMeterResult;
  bool shouldThrowException = false;
  String? exceptionMessage;
  int validateTokenCallCount = 0;
  int pairMeterCallCount = 0;

  void reset() {
    mockValidateTokenResult = null;
    mockPairMeterResult = null;
    shouldThrowException = false;
    exceptionMessage = null;
    validateTokenCallCount = 0;
    pairMeterCallCount = 0;
  }

  @override
  Future<Result<bool>> validateToken(
    String userToken,
    String idWorkspace,
    String idMeter,
    String deviceToken,
  ) async {
    validateTokenCallCount++;
    if (shouldThrowException) {
      throw Exception(exceptionMessage ?? 'Validation failed');
    }
    return mockValidateTokenResult ?? Result.failure('Mock not configured');
  }

  @override
  Future<Result<PairingResponse>> pairMeter(
    String userToken,
    String idWorkspace,
    String idMeter,
  ) async {
    pairMeterCallCount++;
    if (shouldThrowException) {
      throw Exception(exceptionMessage ?? 'Pairing failed');
    }
    return mockPairMeterResult ?? Result.failure('Mock not configured');
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}



void main() {
  group('BlueProvider Pairing Tests', () {
    late MockMeterRepo mockMeterRepo;
    late TestableBlueProvider provider;

    setUp(() {
      mockMeterRepo = MockMeterRepo();
      provider = TestableBlueProvider(null, mockMeterRepo);
    });

    tearDown(() {
      mockMeterRepo.reset();
    });

    group('Pairing State Management', () {
      test('should initialize with unpaired state', () {
        expect(provider.pairingState, equals(PairingState.unpaired));
        expect(provider.lastError, isNull);
      });

      test('should update pairing state and notify listeners', () {
        bool notified = false;
        provider.addListener(() {
          notified = true;
        });

        provider.updatePairingState(PairingState.paired);

        expect(provider.pairingState, equals(PairingState.paired));
        expect(notified, isTrue);
      });

      test('should update pairing state with error', () {
        final error = PairingError.tokenMismatch();
        
        provider.updatePairingState(PairingState.error, error);

        expect(provider.pairingState, equals(PairingState.error));
        expect(provider.lastError, equals(error));
      });

      test('should reset pairing state', () {
        provider.updatePairingState(PairingState.error, PairingError.tokenMismatch());
        
        provider.resetPairingState();

        expect(provider.pairingState, equals(PairingState.unpaired));
        expect(provider.lastError, isNull);
      });
    });

    group('Validation Context', () {
      test('should set validation context', () {
        provider.setValidationContext(
          userToken: 'test_token',
          workspaceId: 'workspace_1',
          meterId: 'meter_1',
        );

        // Context is set internally, we can verify by triggering validation
        expect(() => provider.setValidationContext(
          userToken: 'test_token',
          workspaceId: 'workspace_1', 
          meterId: 'meter_1',
        ), returnsNormally);
      });
    });

    group('API Key Setting', () {
      test('should fail to set API key when not connected', () async {
        // Act
        final result = await provider.setApiKey('new_token_123');

        // Assert
        expect(result, isFalse);
        expect(provider.pairingState, equals(PairingState.error));
        expect(provider.lastError?.type, equals(PairingErrorType.connectionLost));
      });

      test('should fail to set empty API key', () async {
        // Act
        final result = await provider.setApiKey('');

        // Assert
        expect(result, isFalse);
        expect(provider.pairingState, equals(PairingState.error));
        expect(provider.lastError?.type, equals(PairingErrorType.invalidToken));
      });
    });






  });
}