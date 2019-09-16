import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:calculator_math_expression/src/wolfram/repository/wolfram_repository.dart';
import './bloc.dart';

class WolframBloc extends Bloc<WolframEvent, WolframState> {
  @override
  WolframState get initialState => InitialWolframState();

  @override
  Stream<WolframState> mapEventToState(
    WolframEvent event,
  ) async* {
    if (event is GetExpressionEvent) {
      yield ExpressionLoadingState();
      try {
        var from = event.from;
        var to = event.to;
        var response = await WolframRepository().getPlotFunction(from, to, event.exp);
        yield ExpressionLoadedState(response);
      } catch (error) {
        yield ExpressionFailedState(error.toString());
      }
    }
  }
}
