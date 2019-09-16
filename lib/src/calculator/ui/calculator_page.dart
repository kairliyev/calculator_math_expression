import 'package:calculator_math_expression/src/calculator/bloc/bloc.dart';
import 'package:calculator_math_expression/src/calculator/plot/custom_plot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CalculatorPage extends StatefulWidget {
  CalculatorPage({Key key}) : super(key: key);

  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  TextEditingController _mathExpressionController = new TextEditingController();
  TextEditingController _mathExpressionFromController =
      new TextEditingController();
  TextEditingController _mathExpressionToController =
      new TextEditingController();

  var calculatorBloc = CalculatorBloc();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    calculatorBloc.dispose();
    _mathExpressionController.dispose();
    _mathExpressionFromController.dispose();
    _mathExpressionToController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Math Expression Calculator"),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                buildExpression(context),
                SizedBox(
                  height: 10,
                ),
                buildRowRangeWidgets(context),
                SizedBox(
                  height: 15,
                ),
                RaisedButton(
                  onPressed: () {
                    var exp = _mathExpressionController.text;
                    var from = _mathExpressionFromController.text;
                    var to = _mathExpressionToController.text;
                    calculatorBloc.dispatch(GetExpressionEvent(exp, from, to));
                  },
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "Calculate it",
                    style: Theme.of(context).textTheme.body1,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: BlocBuilder<CalculatorEvent, CalculatorState>(
                      bloc: calculatorBloc,
                      builder: (BuildContext context, CalculatorState state) {
                        if (state is InitialCalculatorState) {
                          return Container();
                        } else if (state is ExpressionLoadingState) {
                          return CircularProgressIndicator();
                        } else if (state is ExpressionLoadedState) {
                          return Card(
                            child: new Container(
                              child: new CustomPlot(
                                data: state.poindData,
                              ),
                            ),
                          );
                        } else if (state is ExpressionFailedState) {
                          return Center(
                              child: Container(
                            child: Text(
                              state.error,
                              style: Theme.of(context).textTheme.body2,
                            ),
                          ));
                        }
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row buildRowRangeWidgets(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(child: buildRangeFrom(context)),
        Expanded(
          child: SizedBox(
            width: 1,
          ),
        ),
        Expanded(child: buildRangeTo(context))
      ],
    );
  }

  Widget buildRangeFrom(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("[x] From", style: Theme.of(context).textTheme.title),
        SizedBox(
          height: 10,
        ),
        TextField(
          keyboardType: TextInputType.number,
          decoration: new InputDecoration.collapsed(hintText: '-5'),
          controller: _mathExpressionFromController,
        ),
        SizedBox(
          height: 10,
        ),
        Divider(
          height: 1,
          color: Colors.black,
        )
      ],
    );
  }

  Widget buildRangeTo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("To [x]", style: Theme.of(context).textTheme.title),
        SizedBox(
          height: 10,
        ),
        TextField(
          keyboardType: TextInputType.number,
          decoration: new InputDecoration.collapsed(hintText: '5'),
          controller: _mathExpressionToController,
        ),
        SizedBox(
          height: 10,
        ),
        Divider(
          height: 1,
          color: Colors.black,
        )
      ],
    );
  }

  Widget buildExpression(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Write an expression", style: Theme.of(context).textTheme.title),
        SizedBox(
          height: 10,
        ),
        TextField(
          decoration: new InputDecoration.collapsed(hintText: '(x^2) + x / 3'),
          controller: _mathExpressionController,
        ),
        SizedBox(
          height: 10,
        ),
        Divider(
          height: 1,
          color: Colors.black,
        ),
      ],
    );
  }
}
