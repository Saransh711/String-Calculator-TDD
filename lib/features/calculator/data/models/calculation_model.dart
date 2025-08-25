import '../../domain/entities/calculation.dart';

class CalculationModel extends Calculation {
  const CalculationModel({
    required super.input,
    required super.result,
    required super.timestamp,
  });

  factory CalculationModel.fromJson(Map<String, dynamic> json) {
    return CalculationModel(
      input: json['input'] as String,
      result: json['result'] as int,
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp'] as int),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'input': input,
      'result': result,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  factory CalculationModel.fromEntity(Calculation entity) {
    return CalculationModel(
      input: entity.input,
      result: entity.result,
      timestamp: entity.timestamp,
    );
  }
}
