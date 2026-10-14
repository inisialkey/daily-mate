/// Input that breaks a domain rule. The message is safe to show the user.
class ValidationException implements Exception {
  const ValidationException(this.message);

  final String message;

  @override
  String toString() => 'ValidationException: $message';
}
