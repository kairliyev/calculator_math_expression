import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class CalculatorState extends Equatable {
  CalculatorState([List props = const <dynamic>[]]) : super(props);
}

class InitialCalculatorState extends CalculatorState {}

class ExpressionLoadingState extends CalculatorState {}

class ExpressionLoadedState extends CalculatorState {
  List<Point> poindData;
  ExpressionLoadedState(this.poindData) : super([poindData]);
}

class ExpressionFailedState extends CalculatorState {
  String error;
  ExpressionFailedState(this.error):super([error]);
}
