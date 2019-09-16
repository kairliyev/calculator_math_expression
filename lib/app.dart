import 'package:calculator_math_expression/main.dart';
import 'package:calculator_math_expression/src/calculator/ui/calculator_page.dart';
import 'package:calculator_math_expression/src/utils/choose_widget.dart';
import 'package:calculator_math_expression/src/wolfram/ui/wolfram_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

ThemeData CalculatorAppTheme = ThemeData(
    textTheme: TextTheme(
      headline: TextStyle(
          fontFamily: 'UbuntuRegular',
          color: Colors.black,
          fontSize: 26,
          fontWeight: FontWeight.bold),
      title: TextStyle(
          fontFamily: 'UbuntuBold',
          color: Color(0xFF6284FF),
          fontSize: 22,
          fontWeight: FontWeight.bold),
      display1: TextStyle(
          fontFamily: 'UbuntuBoldItalic',
          color: Colors.black,
          fontSize: 22,
          fontWeight: FontWeight.w600),
      // Default text style
      body1: TextStyle(
          fontFamily: 'UbuntuMedium',
          color: Colors.white,
          letterSpacing: 0,
          fontSize: 24,
          fontWeight: FontWeight.w500),
      body2: TextStyle(
          fontFamily: 'UbuntuLight',
          color: Colors.red,
          letterSpacing: 0,
          fontSize: 24,
          fontWeight: FontWeight.w500),
      // TextField text style
      subhead: TextStyle(
          fontFamily: 'UbuntuMediumItalic',
          color: Colors.black.withOpacity(0.65),
          fontSize: 22,
          fontWeight: FontWeight.w500),
      display2: TextStyle(
          fontFamily: 'UbuntuRegular',
          color: Colors.black,
          fontSize: 22,
          fontWeight: FontWeight.w500),
      display4: TextStyle(
          fontFamily: 'UbuntuLight', color: Colors.white, fontSize: 22),
      display3: TextStyle(
          fontFamily: 'UbuntuRegular',
          color: Colors.black,
          fontSize: 22,
          fontWeight: FontWeight.w500),
      // Subtitle text style
      subtitle: TextStyle(
          fontFamily: 'UbuntuRegular',
          color: Colors.black.withOpacity(0.6),
          fontSize: 22,
          letterSpacing: 0),
      // Button text style
      button: TextStyle(
          fontFamily: 'SFProText-Medium',
          fontSize: 22,
          color: Colors.white,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.2),
    ),
    accentColor: const Color(0xFF00845E),
    primaryColor: const Color(0xFF06D397),
    primaryColorLight: Color(0xFF9291A9),
    backgroundColor: const Color(0xFFFFFFFF),
    buttonColor: const Color(0xFF06D397),
    canvasColor: const Color(0xFF9291A9));

class App extends StatefulWidget {
  App({Key key}) : super(key: key);

  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: CalculatorAppTheme,
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => ChoosePage(),
        '/calculator': (BuildContext context) => CalculatorPage(),
        '/wolfram': (BuildContext context) => WolframPage(),
      },
    );
  }
}

class ChoosePage extends StatefulWidget {
  ChoosePage({Key key}) : super(key: key);

  _ChoosePageState createState() => _ChoosePageState();
}

class _ChoosePageState extends State<ChoosePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Calculator Math Function",
                style: Theme.of(context).textTheme.headline,
              ),
              Center(
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ChooseType(
                          title: "Calculator",
                          url:
                              "https://avatars.mds.yandex.net/get-pdb/1598943/5693b06f-ed1d-4e37-acbb-4f2b624b9127/s1200"),
                      ChooseType(
                          title: "Wolfram",
                          url:
                              "https://i.pinimg.com/originals/b7/3b/b1/b73bb1040628f115c1776f6caab71aea.png")
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
