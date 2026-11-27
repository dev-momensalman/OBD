class BluetoothException implements Exception {
  final String message;
  final String? code;
  const BluetoothException(this.message, {this.code});

  @override
  String toString() => 'BluetoothException: $message (code: $code)';
}

class ObdProtocolException implements Exception {
  final String message;
  const ObdProtocolException(this.message);

  @override
  String toString() => 'ObdProtocolException: $message';
}

class DeviceBusyException implements Exception {
  final String message;
  const DeviceBusyException(this.message);

  @override
  String toString() => 'DeviceBusyException: $message';
}

class ServerException implements Exception {
  final String message;
  final int? statusCode;
  const ServerException(this.message, {this.statusCode});

  @override
  String toString() => 'ServerException($statusCode): $message';
}

class NetworkTimeoutException implements Exception {
  final String message;
  const NetworkTimeoutException(this.message);

  @override
  String toString() => 'NetworkTimeoutException: $message';
}
