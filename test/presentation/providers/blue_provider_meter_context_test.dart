import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_water_quality/presentation/providers/blue_provider.dart';
import 'package:frontend_water_quality/domain/repositories/meter_repo.dart';
import 'package:frontend_water_quality/core/interface/result.dart';
import 'package:frontend_water_quality/core/enums/pairing_state.dart';
import 'package:frontend_water_quality/core/interface/meter_setup.dart';

class MockMeterRepo implements MeterRepo {
  Result<bool>? mockValidateTokenResult;
  int validateTokenCallCount = 0;
  String? lastValidatedWorkspaceId;
  String? lastValidatedMeterId;
  String? lastValidatedToken;

  void reset() {
    mockValidateTokenResult = null;
    validateTokenCallCount = 0;
    lastValidatedWorkspaceId = null;
    lastValidatedMeterId = null;
    lastValidatedToken = null;
  }

  @override
  Future<Result<bool>> validateToken(
    String userToken,
    String idWorkspace,
    String idMeter,
    String deviceToken,
  ) async {
    validateTokenCallCount++;
    lastValidatedWorkspaceId = idWorkspace;
    lastValidatedMeterId = idMeter;
    lastValidatedToken = deviceToken;
    
    return mockValidateTokenResult ?? Result.failure('Mock not configured');
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('BlueProvider Meter Context Tests', () {
    late MockMeterRepo mockMeterRepo;
    late BlueProvider provider;

    setUp(() {
      mockMeterRepo = MockMeterRepo();
      provider = BlueProvider(null, mockMeterRepo);
    });

    tearDown(() {
      mockMeterRepo.reset();
    });

    group('Validation Context Management', () {
      test('should validate token when meter context changes', () async {
        // Setup initial context
        provider.setValidationContext(
          userToken: 'user_token',
          workspaceId: 'workspace_1',
          meterId: 'meter_1',
        );

        // Simulate meter setup with token
        final meterSetup = MeterSetup(
          ssidWifi: 'test_wifi',
          passwordWifi: 'test_password',
          ph4: 4.0,
          ph6: 6.0,
          token: 'device_token_123',
        );

        // Mock successful validation
        mockMeterRepo.mockValidateTokenResult = Result.success(true);

        // Manually set the meter setup to simulate receiving it from device
        provider.currentMeterSetup = meterSetup;

        // Change to different meter context (should trigger validation)
        provider.setValidationContext(
          userToken: 'user_token',
          workspaceId: 'workspace_1',
          meterId: 'meter_2', // Different meter
        );

        // Wait for async validation
        await Future.delayed(Duration(milliseconds: 100));

        // Verify validation was called for the new meter
        expect(mockMeterRepo.validateTokenCallCount, equals(1));
        expect(mockMeterRepo.lastValidatedMeterId, equals('meter_2'));
        expect(mockMeterRepo.lastValidatedToken, equals('device_token_123'));
      });

      test('should force validation when requested', () async {
        // Setup context and meter setup
        provider.setValidationContext(
          userToken: 'user_token',
          workspaceId: 'workspace_1',
          meterId: 'meter_1',
        );

        final meterSetup = MeterSetup(
          ssidWifi: 'test_wifi',
          passwordWifi: 'test_password',
          ph4: 4.0,
          ph6: 6.0,
          token: 'device_token_456',
        );

        // Manually set meter setup
        provider.currentMeterSetup = meterSetup;

        // Mock successful validation
        mockMeterRepo.mockValidateTokenResult = Result.success(true);

        // Force validation
        await provider.forceTokenValidation();

        // Verify validation was called
        expect(mockMeterRepo.validateTokenCallCount, equals(1));
        expect(mockMeterRepo.lastValidatedMeterId, equals('meter_1'));
        expect(mockMeterRepo.lastValidatedToken, equals('device_token_456'));
        expect(provider.pairingState, equals(PairingState.paired));
      });

      test('should set unpaired state when no token available for force validation', () async {
        // Setup context but no meter setup
        provider.setValidationContext(
          userToken: 'user_token',
          workspaceId: 'workspace_1',
          meterId: 'meter_1',
        );

        // Force validation without meter setup
        await provider.forceTokenValidation();

        // Verify no validation was called and state is unpaired
        expect(mockMeterRepo.validateTokenCallCount, equals(0));
        expect(provider.pairingState, equals(PairingState.unpaired));
      });

      test('should validate when meter setup token changes', () async {
        // Setup context
        provider.setValidationContext(
          userToken: 'user_token',
          workspaceId: 'workspace_1',
          meterId: 'meter_1',
        );

        // Mock successful validation
        mockMeterRepo.mockValidateTokenResult = Result.success(true);

        // Simulate callback message with first token (should validate)
        provider.callbackMessage('{"wifiSSID":"wifi1","wifiPassword":"pass1","calibrationVol4":"4.0","calibrationVol6":"6.0","apiKey":"token_1"}');
        await Future.delayed(Duration(milliseconds: 100));

        // Should validate once for the first setup
        expect(mockMeterRepo.validateTokenCallCount, equals(1));
        expect(mockMeterRepo.lastValidatedToken, equals('token_1'));

        // Simulate callback message with same token (should not validate again)
        provider.callbackMessage('{"wifiSSID":"wifi1","wifiPassword":"pass1","calibrationVol4":"4.0","calibrationVol6":"6.0","apiKey":"token_1"}');
        await Future.delayed(Duration(milliseconds: 100));

        // Should still be 1 validation call
        expect(mockMeterRepo.validateTokenCallCount, equals(1));

        // Simulate callback message with different token (should validate again)
        provider.callbackMessage('{"wifiSSID":"wifi1","wifiPassword":"pass1","calibrationVol4":"4.0","calibrationVol6":"6.0","apiKey":"token_2"}');
        await Future.delayed(Duration(milliseconds: 100));

        // Should validate again for the new token
        expect(mockMeterRepo.validateTokenCallCount, equals(2));
        expect(mockMeterRepo.lastValidatedToken, equals('token_2'));
      });

      test('should reset pairing state when disconnecting', () async {
        // Setup and pair
        provider.setValidationContext(
          userToken: 'user_token',
          workspaceId: 'workspace_1',
          meterId: 'meter_1',
        );

        provider.updatePairingState(PairingState.paired);
        expect(provider.pairingState, equals(PairingState.paired));

        // Disconnect
        await provider.disconnect();

        // Verify state is reset
        expect(provider.pairingState, equals(PairingState.unpaired));
        expect(provider.currentMeterSetup, isNull);
        expect(provider.isConnected, isFalse);
      });

      test('should handle validation failure correctly', () async {
        // Setup context
        provider.setValidationContext(
          userToken: 'user_token',
          workspaceId: 'workspace_1',
          meterId: 'meter_1',
        );

        final meterSetup = MeterSetup(
          ssidWifi: 'test_wifi',
          passwordWifi: 'test_password',
          ph4: 4.0,
          ph6: 6.0,
          token: 'invalid_token',
        );

        provider.currentMeterSetup = meterSetup;

        // Mock validation failure
        mockMeterRepo.mockValidateTokenResult = Result.success(false);

        // Force validation
        await provider.forceTokenValidation();

        // Verify validation was called and state is unpaired
        expect(mockMeterRepo.validateTokenCallCount, equals(1));
        expect(provider.pairingState, equals(PairingState.unpaired));
      });
    });
  });
}