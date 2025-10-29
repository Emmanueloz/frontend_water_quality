import 'dart:async';
import 'dart:math';

class RetryConfig {
  final int maxAttempts;
  final Duration initialDelay;
  final Duration maxDelay;
  final double backoffMultiplier;
  final bool exponentialBackoff;

  const RetryConfig({
    this.maxAttempts = 3,
    this.initialDelay = const Duration(seconds: 1),
    this.maxDelay = const Duration(seconds: 10),
    this.backoffMultiplier = 2.0,
    this.exponentialBackoff = true,
  });

  static const RetryConfig network = RetryConfig(
    maxAttempts: 3,
    initialDelay: Duration(seconds: 2),
    maxDelay: Duration(seconds: 8),
    backoffMultiplier: 2.0,
    exponentialBackoff: true,
  );

  static const RetryConfig bluetooth = RetryConfig(
    maxAttempts: 2,
    initialDelay: Duration(seconds: 1),
    maxDelay: Duration(seconds: 5),
    backoffMultiplier: 2.0,
    exponentialBackoff: true,
  );

  static const RetryConfig validation = RetryConfig(
    maxAttempts: 2,
    initialDelay: Duration(milliseconds: 500),
    maxDelay: Duration(seconds: 3),
    backoffMultiplier: 1.5,
    exponentialBackoff: true,
  );
}

class RetryMechanism {
  static Future<T> execute<T>(
    Future<T> Function() operation, {
    RetryConfig config = const RetryConfig(),
    bool Function(dynamic error)? shouldRetry,
    void Function(int attempt, dynamic error)? onRetry,
  }) async {
    int attempt = 0;
    Duration currentDelay = config.initialDelay;

    while (attempt < config.maxAttempts) {
      attempt++;
      
      try {
        return await operation();
      } catch (error) {
        // Check if we should retry this error
        final canRetry = shouldRetry?.call(error) ?? true;
        final isLastAttempt = attempt >= config.maxAttempts;
        
        if (!canRetry || isLastAttempt) {
          rethrow;
        }

        // Notify about retry attempt
        onRetry?.call(attempt, error);

        // Wait before retrying
        await Future.delayed(currentDelay);

        // Calculate next delay
        if (config.exponentialBackoff) {
          currentDelay = Duration(
            milliseconds: min(
              (currentDelay.inMilliseconds * config.backoffMultiplier).round(),
              config.maxDelay.inMilliseconds,
            ),
          );
        }
      }
    }

    throw StateError('Retry mechanism failed - this should not happen');
  }

  static Future<T> executeWithCircuitBreaker<T>(
    Future<T> Function() operation, {
    RetryConfig config = const RetryConfig(),
    Duration circuitBreakerTimeout = const Duration(minutes: 1),
    int failureThreshold = 5,
  }) async {
    // Simple circuit breaker implementation
    // In a real app, this would be more sophisticated
    return execute(operation, config: config);
  }
}

class RetryableOperation<T> {
  final Future<T> Function() _operation;
  final RetryConfig _config;
  final bool Function(dynamic error)? _shouldRetry;
  final void Function(int attempt, dynamic error)? _onRetry;

  RetryableOperation(
    this._operation, {
    RetryConfig config = const RetryConfig(),
    bool Function(dynamic error)? shouldRetry,
    void Function(int attempt, dynamic error)? onRetry,
  }) : _config = config, _shouldRetry = shouldRetry, _onRetry = onRetry;

  Future<T> execute() {
    return RetryMechanism.execute(
      _operation,
      config: _config,
      shouldRetry: _shouldRetry,
      onRetry: _onRetry,
    );
  }
}