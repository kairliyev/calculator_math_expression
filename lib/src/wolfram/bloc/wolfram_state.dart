import 'package:calculator_math_expression/src/wolfram/model/plot.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class WolframState extends Equatable {
  WolframState([List props = const <dynamic>[]]) : super(props);
}

class InitialWolframState extends WolframState {}

class ExpressionLoadingState extends WolframState {}

class ExpressionLoadedState extends WolframState {
  Plot plotGraph;
  ExpressionLoadedState(this.plotGraph) : super([plotGraph]);
}

class ExpressionFailedState extends WolframState {
  String error;
  ExpressionFailedState(this.error) : super([error]);
}
