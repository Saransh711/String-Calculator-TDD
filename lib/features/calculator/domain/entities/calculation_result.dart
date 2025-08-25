import 'package:equatable/equatable.dart';

class CalculationResult extends Equatable {
  final int value;
  final bool isValid;
  final String? errorMessage;
  final List<int>? negativeNumbers;

  const CalculationResult({
    required this.value,
    required this.isValid,
    this.errorMessage,
    this.negativeNumbers,
  });

  factory CalculationResult.success(int value) {
    return CalculationResult(value: value, isValid: true);
  }

  factory CalculationResult.error(
    String errorMessage, {
    List<int>? negativeNumbers,
  }) {
    return CalculationResult(
      value: 0,
      isValid: false,
      errorMessage: errorMessage,
      negativeNumbers: negativeNumbers,
    );
  }

  @override
  List<Object?> get props => [value, isValid, errorMessage, negativeNumbers];
}
