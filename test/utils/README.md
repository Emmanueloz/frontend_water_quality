# Test Utilities

## MockDio

A mock implementation of the Dio HTTP client for testing API interactions without making real network calls.

### Features

- **Simple Mocking**: Set a single response or error for all requests
- **Sequential Mocking**: Define a sequence of expected API calls with specific responses
- **Call Counting**: Track the number of API calls made
- **HTTP Method Support**: GET, POST, PUT, DELETE, PATCH
- **Error Simulation**: Simulate DioExceptions and network errors

### Usage Patterns

#### 1. Simple Mocking

Use `mockResponse` or `mockError` for straightforward test scenarios:

```dart
// Success response
mockDio.mockResponse = Response(
  data: {'key': 'value'},
  statusCode: 200,
  requestOptions: RequestOptions(path: ''),
);

// Error response
mockDio.mockError = DioException(
  type: DioExceptionType.connectionTimeout,
  requestOptions: RequestOptions(path: ''),
);
```

#### 2. Sequential Mocking

Use `expectCall()` for strict, ordered API call verification:

```dart
mockDio.expectCall(MockApiCall(
  method: 'GET',
  path: '/api/users',
  statusCode: 200,
  responseData: {'users': []},
));

mockDio.expectCall(MockApiCall(
  method: 'POST',
  path: '/api/users',
  statusCode: 201,
  responseData: {'id': '123'},
));
```

#### 3. Error Simulation

Simulate errors with `shouldThrow` flag:

```dart
mockDio.expectCall(MockApiCall(
  method: 'GET',
  path: '/api/data',
  statusCode: 500,
  shouldThrow: true,
  exception: DioException(
    type: DioExceptionType.connectionTimeout,
    requestOptions: RequestOptions(path: ''),
  ),
));
```

#### 4. Call Counting

Verify the number of API calls:

```dart
await repository.someMethod();
expect(mockDio.callCount, equals(1));
```

### Best Practices

1. **Always reset in tearDown**: Call `mockDio.reset()` to clear state between tests
2. **Use descriptive test data**: Match production data formats for realistic tests
3. **Test error scenarios**: Cover HTTP status codes (400, 401, 403, 404, 500) and network errors
4. **Verify call counts**: Ensure retry logic works correctly by checking `callCount`
5. **Follow AAA pattern**: Arrange (setup mock), Act (call method), Assert (verify results)

### Supported HTTP Methods

- `GET`: Retrieve data
- `POST`: Create resources
- `PUT`: Update resources (full replacement)
- `PATCH`: Update resources (partial update)
- `DELETE`: Remove resources

### Example Test

```dart
group('UserRepository Tests', () {
  late MockDio mockDio;
  late UserRepository repository;

  setUp(() {
    mockDio = MockDio();
    repository = UserRepository(mockDio);
  });

  tearDown(() {
    mockDio.reset();
  });

  test('should return user when API returns 200', () async {
    // Arrange
    mockDio.mockResponse = Response(
      data: {'id': '1', 'name': 'John'},
      statusCode: 200,
      requestOptions: RequestOptions(path: ''),
    );

    // Act
    final result = await repository.getUser('1');

    // Assert
    expect(result.isSuccess, isTrue);
    expect(result.value?.name, equals('John'));
    expect(mockDio.callCount, equals(1));
  });
});
```

### Limitations

- Does not support URI-based methods (getUri, postUri, etc.)
- Does not support file downloads
- Does not support request/response interceptors
- Does not track request data or query parameters

For these advanced scenarios, consider using the actual Dio client with a mock HTTP server.
