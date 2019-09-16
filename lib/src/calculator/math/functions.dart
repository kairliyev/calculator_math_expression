import 'math.dart';
import 'dart:math' as math;

abstract class MathFunction extends Expression {
  String name;

  List<Variable> args;

  MathFunction(this.name, this.args);

  MathFunction._empty(this.name);

  Variable getParam(int i) => args[i];

  Variable getParamByName(String name) =>
      args.singleWhere((e) => e.name == name);

  int get domainDimension => args.length;

  @override
  String toString() => '$name($args)';

  String toFullString() => toString();
}

class CustomFunction extends MathFunction {
  Expression expression;

  CustomFunction(String name, List<Variable> args, this.expression)
      : super(name, args);

  @override
  Expression derive(String toVar) =>
      new CustomFunction(name, args, expression.derive(toVar));

  @override
  Expression simplify() =>
      new CustomFunction(name, args, expression.simplify());

  @override
  dynamic evaluate(EvaluationType type, ContextModel context) =>
      expression.evaluate(type, context);

  @override
  String toFullString() => '$name($args) = $expression';
}

abstract class DefaultFunction extends MathFunction {

  DefaultFunction._unary(String name, Expression arg) : super._empty(name) {
    final Variable bindingVariable = _wrapIntoVariable(arg);
    this.args = <Variable>[bindingVariable];
  }


  DefaultFunction._binary(String name, Expression arg1, Expression arg2)
      : super._empty(name) {
    final Variable bindingVariable1 = _wrapIntoVariable(arg1);
    final Variable bindingVariable2 = _wrapIntoVariable(arg2);
    this.args = <Variable>[bindingVariable1, bindingVariable2];
  }

  Variable _wrapIntoVariable(Expression e) {
    if (e is Variable) {
      return e;
    }
  }

  @override
  String toString() =>
      args.length == 1 ? '$name(${args[0]})' : '$name(${args[0]},${args[1]})';
}

class Sqrt extends DefaultFunction {
  Expression get arg => getParam(0);

  Sqrt(Expression arg) : super._unary('sqrt', arg);

  @override
  Expression simplify() {
    final Expression argSimpl = arg.simplify();
    return new Sqrt(argSimpl);
  }

  @override
  dynamic evaluate(EvaluationType type, ContextModel context) {
    final dynamic argEval = arg.evaluate(type, context);

    if (type == EvaluationType.REAL) {
      return math.sqrt(argEval);
    }

    throw new UnimplementedError('Can not evaluate $name on $type yet.');
  }

  @override
  String toString() => 'sqrt($arg)';

  @override
  Expression derive(String toVar) => this.asPower().derive(toVar);

  Expression asPower() =>
      new Power(arg, new Divide(new Number(1), new Number(2)));
}
