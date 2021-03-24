import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

class ODConventionMarquee extends StatelessWidget {
  const ODConventionMarquee({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 15, right: 15),
          height: 45,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xfff6AD7E8), Color(0xfff4D7AFB)]),
          ),
          child: Marquee(
            text:
                'FH :- 8:00 am to 11:30 am || SH :- 12:00 noon to 3:45 pm || FD :- 08:00 am to 3:45 pm || ',
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
          ),
        )
      ],
    );
  }
}

class ODConvention extends StatelessWidget {
  const ODConvention({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 15, top: 17),
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              'OD Validation Conventions Used',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w100,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
