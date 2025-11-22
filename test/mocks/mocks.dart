/// Centralized mocks for testing
/// 
/// This file exports all shared mocks to avoid duplication across test files.
/// 
/// Available mocks:
/// - MockAuthProvider: Mock for AuthProvider with user and token management
/// - MockAuthRepo: Mock implementation of AuthRepo
/// - MockUserRepo: Mock implementation of UserRepo
/// - MockConnectivityProvider: Mock for connectivity status
/// - MockMeterRepo: Mock for MeterRepo with pairing functionality
/// 
/// Usage:
/// ```dart
/// import '../../mocks/mocks.dart';
/// 
/// void main() {
///   late MockAuthProvider mockAuthProvider;
///   
///   setUp(() {
///     mockAuthProvider = MockAuthProvider();
///     mockAuthProvider.setMockUser(testUser, testToken);
///   });
/// }
/// ```
library;

export 'mock_auth_provider.dart';
export 'mock_connectivity_provider.dart';
export 'mock_dio.dart';
export 'mock_meter_repo.dart';