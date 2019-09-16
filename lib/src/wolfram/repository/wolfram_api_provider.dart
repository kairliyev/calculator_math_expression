import 'dart:convert';

import 'package:calculator_math_expression/src/wolfram/model/plot.dart';
import 'package:http/http.dart';

class WolframApiProvider {
  static var API_KEY = '3LEGAY-8E37AYJVAA';
  var baseUrl = 'https://api.wolframalpha.com/v2/query?';
  var suffixUrl = '&format=image&output=JSON&appid=$API_KEY';

  Future<Plot> getPlotFunction(from, to, exp) async {
    try {
      var encodedUrl = Plot().getEncodedCoreUrl(from, to, exp);

      var response = await get(baseUrl + encodedUrl + suffixUrl, headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
      });
      
      String body = utf8.decode(response.bodyBytes);

      Map plotMap = json.decode(body);
      Plot plot = Plot.fromJson(plotMap);

      return plot;
    } catch (error) {
      throw (error.toString());
    }
  }
}
