class AppConstants {
  static const String appName = 'String Calculator TDD Kata';
  static const int maxHistoryItems = 10;
  static const String historyKey = 'calculation_history';

  // Calculator examples
  static const List<String> calculatorExamples = [
    '""', // Empty string
    '"1"', // Single number
    '"1,2"', // Two numbers
    '"1,2,3"', // Multiple numbers
    '"1\\n2,3"', // Newlines mixed with commas
    '"//;\\n1;2"', // Custom delimiter
    '"//|\\n1|2|3"', // Pipe delimiter
  ];
}
