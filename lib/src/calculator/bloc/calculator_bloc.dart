import 'dart:async';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:calculator_math_expression/src/calculator/math/math.dart';
import './bloc.dart';
import 'dart:isolate';

class CalculatorBloc extends Bloc<CalculatorEvent, CalculatorState> {
  @override
  CalculatorState get initialState => InitialCalculatorState();

  @override
  Stream<CalculatorState> mapEventToState(
    CalculatorEvent event,
  ) async* {
    if (event is GetExpressionEvent) {
      yield ExpressionLoadingState();
      try {
        if (event.from == '' || event.to == '' || event.exp == '') {
          throw new Exception("Put the all data's");
        }
        var exp = event.exp;
        var from = event.from + ".0";
        var to = event.to + ".0";

        var isolatedData =
            await loadIsolate(exp, double.parse(from), double.parse(to));
        print(isolatedData);
        if (isolatedData != null) {
          yield ExpressionLoadedState(isolatedData);
        } else {
          yield ExpressionFailedState("Error, please correct data");
        }
      } catch (error) {
        yield ExpressionFailedState(error.toString());
      }
    }
  }

  Future<List<Point>> loadIsolate(exp, from, to) async {
    ReceivePort receivePort = ReceivePort();
    await Isolate.spawn(isolateEntry, receivePort.sendPort);
    SendPort sendPort = await receivePort.first;

    List<Point> pointData = await sendRecieve(sendPort, exp, from, to);
    return pointData;
  }

  static isolateEntry(SendPort sendPort) async {
    ReceivePort port = ReceivePort();
    sendPort.send(port.sendPort);

    await for (var msg in port) {
      String expression = msg[0];
      double from = msg[1];
      double to = msg[2];
      SendPort replyPort = msg[3];
      List<Point> pointData = [];
      for (double i = from; i <= to; i = i + 0.5) {
        try {
          var point = new Point(i, computeVarInExp(i, expression));
          pointData.add(point);
        } catch (e) {
          replyPort.send(null);
          break;
        }
      }
      replyPort.send(pointData);
    }
  }

  static double computeVarInExp(double number, String expression) {
    try {
      Parser p = new Parser();
      Expression exp = p.parse(expression);
      Variable x = new Variable('x');
      ContextModel cm = new ContextModel();
      var s = cm.bindVariable(x, new Number(number));
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      return eval;
    } catch (e) {
      throw new StateError(e.toString());
    }
  }

  Future sendRecieve(SendPort send, expression, from, to) {
    ReceivePort responsePort = ReceivePort();

    send.send([expression, from, to, responsePort.sendPort]);
    return responsePort.first;
  }
}
