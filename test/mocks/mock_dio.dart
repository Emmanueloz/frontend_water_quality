import 'package:dio/dio.dart';

class MockApiCall {
  final String method;
  final String path;
  final int statusCode;
  final dynamic responseData;
  final bool shouldThrow;
  final DioException? exception;

  MockApiCall({
    required this.method,
    required this.path,
    required this.statusCode,
    this.responseData,
    this.shouldThrow = false,
    this.exception,
  });
}

class MockDio implements Dio {
  // For simple mocking
  Response<dynamic>? mockResponse;
  DioException? mockError;

  // For sequential, strict mocking
  final List<MockApiCall> expectedCalls = [];
  int currentCallIndex = 0;

  // For call counting
  int callCount = 0;

  void expectCall(MockApiCall call) {
    expectedCalls.add(call);
  }

  void reset() {
    mockResponse = null;
    mockError = null;
    expectedCalls.clear();
    currentCallIndex = 0;
    callCount = 0;
  }

  Future<Response<T>> _handleRequest<T>(String method, String path) async {
    callCount++;

    if (expectedCalls.isNotEmpty) {
      if (currentCallIndex >= expectedCalls.length) {
        throw Exception('Unexpected API call: $method $path');
      }

      final expectedCall = expectedCalls[currentCallIndex++];
      if (expectedCall.method != method || expectedCall.path != path) {
        throw Exception(
            'Expected ${expectedCall.method} ${expectedCall.path}, got $method $path');
      }

      if (expectedCall.shouldThrow) {
        if (expectedCall.exception != null) {
          throw expectedCall.exception!;
        }
        throw DioException(
          requestOptions: RequestOptions(path: path),
          response: Response(
            requestOptions: RequestOptions(path: path),
            statusCode: expectedCall.statusCode,
            data: expectedCall.responseData,
          ),
        );
      }

      return Response<T>(
        data: expectedCall.responseData as T,
        statusCode: expectedCall.statusCode,
        requestOptions: RequestOptions(path: path),
      );
    } else {
      if (mockError != null) {
        throw mockError!;
      }
      if (mockResponse != null) {
        return mockResponse as Response<T>;
      }
      throw Exception(
          'MockDio not configured for call: $method $path. Use mockResponse/mockError for simple mocks, or expectCall() for sequential mocks.');
    }
  }

  @override
  Future<Response<T>> get<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) {
    return _handleRequest('GET', path);
  }

  @override
  Future<Response<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) {
    return _handleRequest('POST', path);
  }

  @override
  Future<Response<T>> put<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) {
    return _handleRequest('PUT', path);
  }

  @override
  Future<Response<T>> delete<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _handleRequest('DELETE', path);
  }

  @override
  Future<Response<T>> patch<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) {
    return _handleRequest('PATCH', path);
  }

  @override
  BaseOptions get options => BaseOptions();

  @override
  set options(BaseOptions options) {}

  @override
  Interceptors get interceptors => Interceptors();

  @override
  HttpClientAdapter get httpClientAdapter => throw UnimplementedError();

  @override
  set httpClientAdapter(HttpClientAdapter adapter) {}

  @override
  Transformer get transformer => throw UnimplementedError();

  @override
  set transformer(Transformer transformer) {}

  @override
  void close({bool force = false}) {}

  @override
  Dio clone({
    HttpClientAdapter? httpClientAdapter,
    Interceptors? interceptors,
    BaseOptions? options,
    Transformer? transformer,
  }) =>
      throw UnimplementedError();

  @override
  Future<Response<T>> deleteUri<T>(Uri uri,
          {Object? data, Options? options, CancelToken? cancelToken}) =>
      throw UnimplementedError();

  @override
  Future<Response> download(String urlPath, dynamic savePath,
          {ProgressCallback? onReceiveProgress,
          Map<String, dynamic>? queryParameters,
          CancelToken? cancelToken,
          bool deleteOnError = true,
          String lengthHeader = Headers.contentLengthHeader,
          Object? data,
          Options? options,
          dynamic fileAccessMode}) =>
      throw UnimplementedError();

  @override
  Future<Response> downloadUri(Uri uri, dynamic savePath,
          {ProgressCallback? onReceiveProgress,
          CancelToken? cancelToken,
          bool deleteOnError = true,
          String lengthHeader = Headers.contentLengthHeader,
          Object? data,
          Options? options,
          dynamic fileAccessMode}) =>
      throw UnimplementedError();

  @override
  Future<Response<T>> fetch<T>(RequestOptions requestOptions) =>
      throw UnimplementedError();

  @override
  Future<Response<T>> getUri<T>(Uri uri,
          {Object? data,
          Options? options,
          CancelToken? cancelToken,
          ProgressCallback? onReceiveProgress}) =>
      throw UnimplementedError();

  @override
  Future<Response<T>> head<T>(String path,
          {Object? data,
          Map<String, dynamic>? queryParameters,
          Options? options,
          CancelToken? cancelToken}) =>
      throw UnimplementedError();

  @override
  Future<Response<T>> headUri<T>(Uri uri,
          {Object? data, Options? options, CancelToken? cancelToken}) =>
      throw UnimplementedError();

  void lock() {}

  @override
  Future<Response<T>> patchUri<T>(Uri uri,
          {Object? data,
          Options? options,
          CancelToken? cancelToken,
          ProgressCallback? onSendProgress,
          ProgressCallback? onReceiveProgress}) =>
      throw UnimplementedError();

  @override
  Future<Response<T>> postUri<T>(Uri uri,
          {Object? data,
          Options? options,
          CancelToken? cancelToken,
          ProgressCallback? onSendProgress,
          ProgressCallback? onReceiveProgress}) =>
      throw UnimplementedError();

  @override
  Future<Response<T>> putUri<T>(Uri uri,
          {Object? data,
          Options? options,
          CancelToken? cancelToken,
          ProgressCallback? onSendProgress,
          ProgressCallback? onReceiveProgress}) =>
      throw UnimplementedError();

  @override
  Future<Response<T>> request<T>(String path,
          {Object? data,
          Map<String, dynamic>? queryParameters,
          CancelToken? cancelToken,
          Options? options,
          ProgressCallback? onSendProgress,
          ProgressCallback? onReceiveProgress}) =>
      throw UnimplementedError();

  @override
  Future<Response<T>> requestUri<T>(Uri uri,
          {Object? data,
          CancelToken? cancelToken,
          Options? options,
          ProgressCallback? onSendProgress,
          ProgressCallback? onReceiveProgress}) =>
      throw UnimplementedError();

  void unlock() {}
}
