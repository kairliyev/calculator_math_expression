import 'package:flutter/material.dart';

class ChooseType extends StatelessWidget {
  String title;
  String url;
  ChooseType({Key key, @required this.title, @required this.url})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (title == "Calculator") {
          Navigator.pushNamed(context, '/calculator');
        } else {
          Navigator.pushNamed(context, '/wolfram');
        }
      },
      child: Container(
        height: 300,
        width: MediaQuery.of(context).size.width / 2.5,
        margin: EdgeInsets.all(10),
        alignment: Alignment.bottomCenter,
        decoration: BoxDecoration(
            color: Colors.grey,
            image: DecorationImage(
                colorFilter: new ColorFilter.mode(
                    Colors.black.withOpacity(0.4), BlendMode.hardLight),
                image: NetworkImage(
                  url,
                ),
                fit: BoxFit.fitHeight),
            borderRadius: BorderRadius.all(new Radius.circular(17))),
        child: Center(
          child: Text(
            title,
            style: Theme.of(context).textTheme.body1,
          ),
        ),
      ),
    );
  }
}
