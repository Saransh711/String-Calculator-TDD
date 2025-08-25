extension StringExtension on String {
  String cleanExample() {
    String cleaned = replaceAll('"', '');
    cleaned = cleaned.replaceAll('\\n', '\n');
    return cleaned;
  }
}
