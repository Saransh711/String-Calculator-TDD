import 'package:equatable/equatable.dart';

class Calculation extends Equatable {
  final String input;
  final int result;
  final DateTime timestamp;

  const Calculation({
    required this.input,
    required this.result,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [input, result, timestamp];

  @override
  String toString() => 'add("$input") = $result';
}
