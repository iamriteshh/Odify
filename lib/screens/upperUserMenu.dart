import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'OdList.dart';

class DisplayUser extends StatefulWidget {
  String name;
  String post;
  DisplayUser({this.name, this.post});
  @override
  _DisplayUserState createState() => _DisplayUserState();
}

class _DisplayUserState extends State<DisplayUser> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 15),
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Hi , ' + widget.name,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(
            height: 3,
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              widget.post,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w200),
            ),
          ),
          SizedBox(
            height: 3,
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              DateFormat.yMMMMd('en_US').format(DateTime.now()).toString() +
                  ' (' +
                  DateFormat('EEEE').format(DateTime.now()).toString() +
                  ')',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w200),
            ),
          )
        ],
      ),
    );
  }
}

class UpperMenu extends StatefulWidget {
  @override
  _UpperMenuState createState() => _UpperMenuState();
}

class _UpperMenuState extends State<UpperMenu> {
  final _auth = FirebaseAuth.instance;
  String userUID = " ";
  String temp = " ";
  @override
  void initState() {
    getInput();
    super.initState();
  }

  logout() async {
    await _auth.signOut();
  }

  void getInput() async {
    final v = await _auth.currentUser();

    var response = await http.get(
        'https://api.openweathermap.org/data/2.5/weather?lat=13&lon=80&appid=a4f14d008a27f9440172070e3f5a52e1&units=metric');
    var data;
    data = jsonDecode(response.body);
    var tem = data['main']['temp'].toDouble();
    setState(() {
      userUID = v.uid;
      temp = tem.toStringAsFixed(1) + ' °C';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () {},
            child: AvatarGlow(
              glowColor: Colors.white,
              endRadius: 39,
              showTwoGlows: true,
              duration: Duration(milliseconds: 1000),
              child: Material(
                elevation: 55,
                shape: CircleBorder(),
                child: GestureDetector(
                  onTap: () {
                    Alert(
                        closeFunction: () {},
                        image:
                            Image(image: AssetImage('assets/image/user.png')),
                        context: context,
                        title: 'User Option',
                        desc: "See OD List Created By You",
                        buttons: [
                          DialogButton(
                              child: Text(
                                'Get List',
                                style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800),
                              ),
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return ODList();
                                }));
                              }),
                        ]).show();
                  },
                  child: CircleAvatar(
                    backgroundImage: AssetImage('assets/image/user.png'),
                  ),
                ),
              ),
            ),
          ),
          Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                DateFormat.Hm().format(DateTime.now()).toString() + ' Hours',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Text(
                  temp,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
