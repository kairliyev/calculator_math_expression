import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class CalculatorEvent extends Equatable {
  CalculatorEvent([List props = const <dynamic>[]]) : super(props);
}

class GetExpressionEvent extends CalculatorEvent {
  String exp;
  String from;
  String to;
  GetExpressionEvent(this.exp, this.from, this.to) : super([exp, from, to]);
}
