class DeleteRequestException implements Exception {
  final String message;
  final int statusCode;

  DeleteRequestException({required this.message, required this.statusCode});

  @override
  String toString() {
    return message;
  }
}
