import '../../domain/entities/calculation_result.dart';

class CalculationResultModel extends CalculationResult {
  const CalculationResultModel({
    required super.value,
    required super.isValid,
    super.errorMessage,
    super.negativeNumbers,
  });

  factory CalculationResultModel.fromJson(Map<String, dynamic> json) {
    return CalculationResultModel(
      value: json['value'] as int,
      isValid: json['isValid'] as bool,
      errorMessage: json['errorMessage'] as String?,
      negativeNumbers: (json['negativeNumbers'] as List<dynamic>?)?.cast<int>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'isValid': isValid,
      'errorMessage': errorMessage,
      'negativeNumbers': negativeNumbers,
    };
  }

  factory CalculationResultModel.fromEntity(CalculationResult entity) {
    return CalculationResultModel(
      value: entity.value,
      isValid: entity.isValid,
      errorMessage: entity.errorMessage,
      negativeNumbers: entity.negativeNumbers,
    );
  }
}
