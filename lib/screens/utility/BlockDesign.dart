import 'package:flutter/material.dart';

class BlockOption extends StatelessWidget {
  final kcolorGrad1;
  final kcolorGrad2;
  final kicon;
  final ktitle;
  final ksubTitle;
  final ktitleFontSize;
  final ksubTitileFontsize;

  const BlockOption(
      {@required this.kcolorGrad1,
      @required this.kcolorGrad2,
      @required this.kicon,
      @required this.ktitle,
      @required this.ksubTitle,
      @required this.ktitleFontSize,
      @required this.ksubTitileFontsize});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 125,
      width: 125,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
          gradient:
              LinearGradient(colors: [Color(kcolorGrad1), Color(kcolorGrad2)])),
      child: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          children: <Widget>[
            Icon(
              kicon,
              color: Colors.white,
              size: 54,
            ),
            Text(
              ktitle,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: ktitleFontSize),
            ),
            SizedBox(
              height: 2,
            ),
            Text(
              ksubTitle,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                  fontSize: ksubTitileFontsize),
            )
          ],
        ),
      ),
    );
  }
}
