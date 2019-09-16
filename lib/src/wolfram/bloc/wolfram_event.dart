import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class WolframEvent extends Equatable {
  WolframEvent([List props = const <dynamic>[]]) : super(props);
}

class GetExpressionEvent extends WolframEvent {
  String exp;
  String from;
  String to;
  GetExpressionEvent(this.exp, this.from, this.to) : super([exp, from, to]);
}
