import 'package:frontend_water_quality/core/interface/result.dart';
import 'package:frontend_water_quality/domain/models/pairing_response.dart';
import 'package:frontend_water_quality/domain/repositories/meter_repo.dart';

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
