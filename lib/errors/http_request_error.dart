class RequestError implements Exception {
  final String message;
  final int statusCode;

  RequestError({required this.message, required this.statusCode});

  @override
  String toString() {
    return message;
  }
}
