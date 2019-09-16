import 'math.dart';

class Parser {
  final Lexer lex;

  Parser() : lex = new Lexer();

  Expression parse(String inputString) {
    if (inputString == null || inputString.trim().isEmpty) {
      throw new ArgumentError('The given input string was empty.');
    }

    final List<Expression> exprStack = <Expression>[];
    final List<Token> inputStream = lex.tokenizeToRPN(inputString);

    for (Token currToken in inputStream) {
      Expression currExpr, left, right;

      switch (currToken.type) {
        case TokenType.VAL:
          currExpr = new Number(double.parse(currToken.text));
          break;
        case TokenType.VAR:
          currExpr = new Variable(currToken.text);
          break;
        case TokenType.UNMINUS:
          currExpr = -exprStack.removeLast();
          break;
        case TokenType.PLUS:
          right = exprStack.removeLast();
          left = exprStack.removeLast();
          currExpr = left + right;
          break;
        case TokenType.MINUS:
          right = exprStack.removeLast();
          left = exprStack.removeLast();
          currExpr = left - right;
          break;
        case TokenType.TIMES:
          right = exprStack.removeLast();
          left = exprStack.removeLast();
          currExpr = left * right;
          break;
        case TokenType.DIV:
          right = exprStack.removeLast();
          left = exprStack.removeLast();
          currExpr = left / right;
          break;
        case TokenType.POW:
          right = exprStack.removeLast();
          left = exprStack.removeLast();
          currExpr = left ^ right;
          break;
        case TokenType.SQRT:
          currExpr = new Sqrt(exprStack.removeLast());
          break;
        default:
          throw new ArgumentError('Unsupported token: $currToken');
      }

      exprStack.add(currExpr);
    }

    if (exprStack.length > 1) {
      throw new StateError('The input String is not a correct expression');
    }

    return exprStack.last;
  }
}

class Lexer {
  final Map<String, TokenType> keywords = <String, TokenType>{};

  String intBuffer = '';

  String varBuffer = '';

  Lexer() {
    keywords['+'] = TokenType.PLUS;
    keywords['-'] = TokenType.MINUS;
    keywords['_'] = TokenType.UNMINUS;
    keywords['*'] = TokenType.TIMES;
    keywords['/'] = TokenType.DIV;
    keywords['^'] = TokenType.POW;
    keywords['sqrt'] = TokenType.SQRT;
    keywords['('] = TokenType.LBRACE;
    keywords[')'] = TokenType.RBRACE;
    keywords[','] = TokenType.SEPAR;
  }

  List<Token> tokenize(String inputString) {
    final List<Token> tempTokenStream = <Token>[];
    final String clearedString = inputString.replaceAll(' ', '').trim();
    final RuneIterator iter = clearedString.runes.iterator;

    while (iter.moveNext()) {
      final String si = iter.currentAsString;

      if (keywords.containsKey(si)) {
        if (intBuffer.isNotEmpty) {
          _doIntBuffer(tempTokenStream);
        }
        if (varBuffer.isNotEmpty) {
          _doVarBuffer(tempTokenStream);
        }

        tempTokenStream.add(new Token(si, keywords[si]));
      } else {
        StringBuffer sb = new StringBuffer(intBuffer);
        try {
          int.parse(si);
          sb.write(si);
          intBuffer = sb.toString();
          if (varBuffer.isNotEmpty) {
            _doVarBuffer(tempTokenStream);
          }
        } on FormatException {
          if (si == '.') {
            sb.write(si);
            intBuffer = sb.toString();
            continue;
          }
          sb = new StringBuffer(varBuffer);
          if (intBuffer.isNotEmpty) {
            _doIntBuffer(tempTokenStream);
            sb.write(si);
            varBuffer = sb.toString();
          } else {
            sb.write(si);
            varBuffer = sb.toString();
          }
        }
      }
    }

    if (intBuffer.isNotEmpty) {
      _doIntBuffer(tempTokenStream);
    }
    if (varBuffer.isNotEmpty) {
      _doVarBuffer(tempTokenStream);
    }
    return tempTokenStream;
  }

  void _doIntBuffer(List<Token> stream) {
    stream.add(new Token(intBuffer, TokenType.VAL));
    intBuffer = '';
  }

  void _doVarBuffer(List<Token> stream) {
    if (keywords.containsKey(varBuffer)) {
      stream.add(new Token(varBuffer, keywords[varBuffer]));
    } else {
      stream.add(new Token(varBuffer, TokenType.VAR));
    }
    varBuffer = '';
  }

  List<Token> shuntingYard(List<Token> stream) {
    if (stream.isEmpty) {
      throw new ArgumentError('The given tokenStream was empty.');
    }

    final List<Token> outputStream = <Token>[];
    final List<Token> operatorBuffer = <Token>[];

    Token prevToken;

    for (Token curToken in stream) {
      if (curToken.type == TokenType.VAL || curToken.type == TokenType.VAR) {
        outputStream.add(curToken);
        prevToken = curToken;
        continue;
      }

      if (curToken.type.function) {
        operatorBuffer.add(curToken);
        prevToken = curToken;
        continue;
      }
      if (curToken.type == TokenType.MINUS &&
          (prevToken == null ||
              prevToken.type.operator ||
              prevToken.type == TokenType.LBRACE)) {
        final Token newToken = new Token(curToken.text, TokenType.UNMINUS);
        operatorBuffer.add(newToken);
        prevToken = newToken;
        continue;
      }

      if (curToken.type.operator) {
        while (operatorBuffer.isNotEmpty &&
            ((curToken.type.leftAssociative &&
                    curToken.type.priority <=
                        operatorBuffer.last.type.priority) ||
                (!curToken.type.leftAssociative &&
                    curToken.type.priority <
                        operatorBuffer.last.type.priority))) {
          outputStream.add(operatorBuffer.removeLast());
        }
        operatorBuffer.add(curToken);
        prevToken = curToken;
        continue;
      }

      if (curToken.type == TokenType.LBRACE) {
        operatorBuffer.add(curToken);
        prevToken = curToken;
        continue;
      }

      if (curToken.type == TokenType.RBRACE) {
        while (operatorBuffer.isNotEmpty &&
            operatorBuffer.last.type != TokenType.LBRACE) {
          outputStream.add(operatorBuffer.removeLast());
        }

        if (operatorBuffer.isEmpty ||
            operatorBuffer.removeLast().type != TokenType.LBRACE) {
          throw new StateError('Mismatched parenthesis.');
        }

        if (operatorBuffer.isNotEmpty && operatorBuffer.last.type.function) {
          outputStream.add(operatorBuffer.removeLast());
        }
      }
      prevToken = curToken;
    }

    while (operatorBuffer.isNotEmpty) {
      if (operatorBuffer.last.type == TokenType.LBRACE ||
          operatorBuffer.last.type == TokenType.RBRACE) {
        throw new StateError('Mismatched parenthesis.');
      }
      outputStream.add(operatorBuffer.removeLast());
    }

    return outputStream;
  }

  List<Token> tokenizeToRPN(String inputString) {
    final List<Token> infixStream = tokenize(inputString);
    return shuntingYard(infixStream);
  }
}

class Token {
  final String text;

  final TokenType type;

  Token(this.text, this.type);

  @override
  bool operator ==(Object token) =>
      (token is Token) &&
      (token.text == this.text) &&
      (token.type == this.type);

  @override
  int get hashCode {
    int result = 17;
    result = 37 * result + text.hashCode;
    result = 37 * result + type.hashCode;
    return result;
  }

  @override
  String toString() => '($type: $text)';
}

class TokenType {
  static const TokenType VAR = const TokenType._internal('VAR', 10);
  static const TokenType VAL = const TokenType._internal('VAL', 10);

  static const TokenType LBRACE = const TokenType._internal('LBRACE', -1);
  static const TokenType RBRACE = const TokenType._internal('RBRACE', -1);
  static const TokenType SEPAR = const TokenType._internal('SEPAR', -1);

  static const TokenType PLUS =
      const TokenType._internal('PLUS', 1, operator: true);
  static const TokenType MINUS =
      const TokenType._internal('MINUS', 1, operator: true);
  static const TokenType TIMES =
      const TokenType._internal('TIMES', 2, operator: true);
  static const TokenType DIV =
      const TokenType._internal('DIV', 2, operator: true);
  static const TokenType POW = const TokenType._internal('POW', 3,
      leftAssociative: false, operator: true);
  static const TokenType UNMINUS = const TokenType._internal('UNMINUS', 5,
      leftAssociative: false, operator: true);
  static const TokenType SQRT =
      const TokenType._internal('SQRT', 4, function: true);

  final String value;

  final int priority;

  final bool leftAssociative;

  final bool operator;

  final bool function;

  const TokenType._internal(this.value, this.priority,
      {this.leftAssociative = true,
      this.operator = false,
      this.function = false});

  @override
  String toString() => value;
}
