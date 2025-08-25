class ServerException implements Exception {
  final String message;
  const ServerException(this.message);
}

class CacheException implements Exception {
  final String message;
  const CacheException(this.message);
}

class ValidationException implements Exception {
  final String message;
  const ValidationException(this.message);
}

class NegativeNumbersException implements Exception {
  final List<int> negativeNumbers;
  const NegativeNumbersException(this.negativeNumbers);

  String get message =>
      'negative numbers not allowed ${negativeNumbers.join(',')}';
}
