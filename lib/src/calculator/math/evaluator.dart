import 'math.dart';

enum EvaluationType { REAL }

class ContextModel {
  ContextModel parentScope;
  Map<String, Expression> variables = <String, Expression>{};
  Set<MathFunction> functions = new Set<MathFunction>();

  ContextModel();

  ContextModel._child(this.parentScope);
  
  ContextModel createChildScope() => new ContextModel._child(this);

  Expression getExpression(String varName) {
    if (variables.containsKey(varName)) {
      return variables[varName];
    } else if (parentScope != null) {
      return parentScope.getExpression(varName);
    } else {
      throw new StateError('Variable not bound: $varName');
    }
  }

  MathFunction getFunction(String name) {
    final Iterable<MathFunction> candidates =
        functions.where((mathFunction) => mathFunction.name == name);
    if (candidates.isNotEmpty) {
      return candidates.first;
    } else if (parentScope != null) {
      return parentScope.getFunction(name);
    } else {
      throw new StateError('Function not bound: $name');
    }
  }

  void bindVariable(Variable v, Expression e) {
    variables[v.name] = e;
  }

  void bindVariableName(String vName, Expression e) {
    variables[vName] = e;
  }


  void bindFunction(MathFunction f) {
    functions.add(f);
  }

  @override
  String toString() => 'ContextModel['
      'PARENT: $parentScope, '
      'VARS: ${variables.toString()}, '
      'FUNCS: ${functions.toString()}]';
}
