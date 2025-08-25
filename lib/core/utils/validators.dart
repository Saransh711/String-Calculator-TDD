class InputValidator {
  static bool isValidCalculatorInput(String input) {
    if (input.isEmpty) return true;

    try {
      // Basic validation logic
      if (input.startsWith('//')) {
        int delimiterEndIndex = input.indexOf('\n');
        if (delimiterEndIndex == -1) return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }
}
