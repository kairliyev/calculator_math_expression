import 'package:calculator_math_expression/src/wolfram/model/plot.dart';
import 'package:calculator_math_expression/src/wolfram/repository/wolfram_api_provider.dart';

class WolframRepository {
  Future<Plot> getPlotFunction(String from, String to, String exp) async =>
      await WolframApiProvider().getPlotFunction(from, to, exp);
}
