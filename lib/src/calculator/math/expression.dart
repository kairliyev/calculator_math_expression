import 'math.dart';
import 'dart:math' as math;

abstract class Expression {
  Expression operator +(Expression exp) => new Plus(this, exp);

  Expression operator -(Expression exp) => new Minus(this, exp);

  Expression operator *(Expression exp) => new Times(this, exp);

  Expression operator /(Expression exp) => new Divide(this, exp);

  Expression operator ^(Expression exp) => new Power(this, exp);

  Expression operator -() => new UnaryMinus(this);

  Expression derive(String toVar);

  Expression simplify() => this;

  dynamic evaluate(EvaluationType type, ContextModel context);

  @override
  String toString();

  Expression _toExpression(dynamic arg) {
    if (arg is Expression) {
      return arg;
    }

    if (arg is num) {
      return new Number(arg);
    }

    if (arg is String) {
      return new Variable(arg);
    }

    throw new ArgumentError('$arg is not a valid expression!');
  }

  bool _isNumber(Expression exp, [num value = 0]) {
    if (exp is Literal && exp.isConstant()) {
      return exp.getConstantValue() == value;
    }

    return false;
  }
}

abstract class BinaryOperator extends Expression {
  Expression first, second;

  BinaryOperator(dynamic first, dynamic second) {
    this.first = _toExpression(first);
    this.second = _toExpression(second);
  }

  BinaryOperator.raw(this.first, this.second);
}

abstract class UnaryOperator extends Expression {
  Expression exp;

  UnaryOperator(dynamic exp) {
    this.exp = _toExpression(exp);
  }

  UnaryOperator.raw(this.exp);
}

class UnaryMinus extends UnaryOperator {
  UnaryMinus(dynamic exp) : super(exp);

  @override
  Expression derive(String toVar) => new UnaryMinus(exp.derive(toVar));

  @override
  Expression simplify() {
    final Expression simplifiedOp = exp.simplify();

    if (simplifiedOp is UnaryMinus) {
      return simplifiedOp.exp;
    }

    if (_isNumber(simplifiedOp, 0)) {
      return simplifiedOp;
    }

    return new UnaryMinus(simplifiedOp);
  }

  @override
  dynamic evaluate(EvaluationType type, ContextModel context) =>
      -(exp.evaluate(type, context));

  @override
  String toString() => '(-$exp)';
}

class Plus extends BinaryOperator {
  Plus(dynamic first, dynamic second) : super(first, second);

  @override
  Expression derive(String toVar) =>
      new Plus(first.derive(toVar), second.derive(toVar));

  @override
  Expression simplify() {
    final Expression firstOp = first.simplify();
    final Expression secondOp = second.simplify();

    if (_isNumber(firstOp, 0)) {
      return secondOp;
    }

    if (_isNumber(secondOp, 0)) {
      return firstOp;
    }

    if (secondOp is UnaryMinus) {
      return firstOp - secondOp.exp;
    }

    return new Plus(firstOp, secondOp);
  }

  @override
  dynamic evaluate(EvaluationType type, ContextModel context) =>
      first.evaluate(type, context) + second.evaluate(type, context);

  @override
  String toString() => '($first + $second)';
}

class Minus extends BinaryOperator {
  Minus(dynamic first, dynamic second) : super(first, second);

  @override
  Expression derive(String toVar) =>
      new Minus(first.derive(toVar), second.derive(toVar));

  @override
  Expression simplify() {
    final Expression firstOp = first.simplify();
    final Expression secondOp = second.simplify();

    if (_isNumber(secondOp, 0)) {
      return firstOp;
    }

    if (_isNumber(firstOp, 0)) {
      return -secondOp;
    }

    if (secondOp is UnaryMinus) {
      return firstOp + secondOp.exp;
    }

    return new Minus(firstOp, secondOp);
  }

  @override
  dynamic evaluate(EvaluationType type, ContextModel context) =>
      first.evaluate(type, context) - second.evaluate(type, context);

  @override
  String toString() => '($first - $second)';
}

class Times extends BinaryOperator {
  Times(dynamic first, dynamic second) : super(first, second);

  @override
  Expression derive(String toVar) => new Plus(
      new Times(first, second.derive(toVar)),
      new Times(first.derive(toVar), second));

  @override
  Expression simplify() {
    Expression firstOp = first.simplify();
    Expression secondOp = second.simplify();
    Expression tempResult;

    bool negative = false;
    if (firstOp is UnaryMinus) {
      firstOp = (firstOp as UnaryMinus).exp;
      negative = !negative;
    }

    if (secondOp is UnaryMinus) {
      secondOp = (secondOp as UnaryMinus).exp;
      negative = !negative;
    }

    if (_isNumber(firstOp, 0)) {
      return firstOp;
    }

    if (_isNumber(firstOp, 1)) {
      tempResult = secondOp;
    }

    if (_isNumber(secondOp, 0)) {
      return secondOp;
    }

    if (_isNumber(secondOp, 1)) {
      tempResult = firstOp;
    }

    if (tempResult == null) {
      tempResult = new Times(firstOp, secondOp);
      return negative ? -tempResult : tempResult;
    }
    return negative ? new UnaryMinus(tempResult) : tempResult;
  }

  @override
  dynamic evaluate(EvaluationType type, ContextModel context) {
    final dynamic firstEval = first.evaluate(type, context);
    final dynamic secondEval = second.evaluate(type, context);

    return firstEval * secondEval;
  }

  @override
  String toString() => '($first * $second)';
}

class Divide extends BinaryOperator {
  Divide(dynamic dividend, dynamic divisor) : super(dividend, divisor);

  @override
  Expression derive(String toVar) =>
      ((first.derive(toVar) * second) - (first * second.derive(toVar))) /
      (second * second);

  @override
  Expression simplify() {
    Expression firstOp = first.simplify();
    Expression secondOp = second.simplify();
    Expression tempResult;

    bool negative = false;

    if (firstOp is UnaryMinus) {
      firstOp = (firstOp as UnaryMinus).exp;
      negative = !negative;
    }

    if (secondOp is UnaryMinus) {
      secondOp = (secondOp as UnaryMinus).exp;
      negative = !negative;
    }

    if (_isNumber(firstOp, 0)) {
      return firstOp;
    }

    if (_isNumber(secondOp, 1)) {
      tempResult = firstOp;
    } else {
      tempResult = new Divide(firstOp, secondOp);
    }

    return negative ? new UnaryMinus(tempResult) : tempResult;
  }

  @override
  dynamic evaluate(EvaluationType type, ContextModel context) {
    final dynamic firstEval = first.evaluate(type, context);
    final dynamic secondEval = second.evaluate(type, context);

    return firstEval / secondEval;
  }

  @override
  String toString() => '($first / $second)';
}

class Power extends BinaryOperator {
  Power(dynamic x, dynamic exp) : super(x, exp);

  @override
  Expression derive(String toVar) => this;

  @override
  Expression simplify() {
    final Expression baseOp = first.simplify();
    final Expression exponentOp = second.simplify();

    if (_isNumber(baseOp, 0)) {
      return baseOp;
    }

    if (_isNumber(baseOp, 1)) {
      return baseOp;
    }

    if (_isNumber(exponentOp, 0)) {
      return new Number(1.0);
    }

    if (_isNumber(exponentOp, 1)) {
      return baseOp;
    }

    return new Power(baseOp, exponentOp);
  }

  @override
  dynamic evaluate(EvaluationType type, ContextModel context) {
    if (type == EvaluationType.REAL) {
      return math.pow(
          first.evaluate(type, context), second.evaluate(type, context));
    }

    throw new UnimplementedError(
        'Evaluate Power with type $type not supported yet.');
  }

  @override
  String toString() => '($first^$second)';
}

abstract class Literal extends Expression {
  dynamic value;

  Literal([this.value]);

  bool isConstant() => false;

  dynamic getConstantValue() {
    throw new StateError('Literal ${this} is not constant.');
  }

  @override
  String toString() => value.toString();
}

class Number extends Literal {
  Number(num value) : super(value.toDouble());

  @override
  bool isConstant() => true;

  @override
  double getConstantValue() => value;

  @override
  dynamic evaluate(EvaluationType type, ContextModel context) {
    if (type == EvaluationType.REAL) {
      return value;
    }

    throw new UnsupportedError('Number $this can not be interpreted as: $type');
  }

  @override
  Expression derive(String toVar) => new Number(0.0);
}

class Variable extends Literal {
  String name;
  Variable(this.name);

  @override
  Expression derive(String toVar) =>
      name == toVar ? new Number(1.0) : new Number(0.0);

  @override
  String toString() => '$name';

  @override
  dynamic evaluate(EvaluationType type, ContextModel context) =>
      context.getExpression(name).evaluate(type, context);
}

class BoundVariable extends Variable {
  BoundVariable(Expression expr) : super('anon') {
    this.value = expr;
  }

  @override
  bool isConstant() => value is Literal ? value.isConstant() : false;

  @override
  dynamic getConstantValue() => value.value;

  @override
  Expression derive(String toVar) => value.derive(toVar);

  @override
  Expression simplify() => value.simplify();

  @override
  dynamic evaluate(EvaluationType type, ContextModel context) =>
      value.evaluate(type, context);

  /// Put bound variable in curly brackets to make them distinguishable.
  @override
  String toString() => '{$value}';
}
