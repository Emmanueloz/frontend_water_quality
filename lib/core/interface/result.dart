class Result<T> {
  /// Indicates whether the operation was successful.
  final bool isSuccess;
  final T? value;
  final String? message;

  Result({required this.isSuccess, this.value, this.message});

  /// Factory constructor to create a successful result.
  factory Result.success(T value) {
    return Result<T>(isSuccess: true, value: value);
  }

  /// Factory constructor to create a failed result.
  factory Result.failure(String message) {
    return Result<T>(isSuccess: false, message: message);
  }
}
