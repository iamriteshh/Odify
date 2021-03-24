import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:wave/wave.dart';
import 'package:wave/config.dart';
import 'package:slider_button/slider_button.dart';
import 'LoginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';

MaskFilter _blur;
final List<MaskFilter> _blurs = [
  null,
  MaskFilter.blur(BlurStyle.normal, 10.0),
  MaskFilter.blur(BlurStyle.inner, 10.0),
  MaskFilter.blur(BlurStyle.outer, 10.0),
  MaskFilter.blur(BlurStyle.solid, 16.0),
];
int _blurIndex = 0;
MaskFilter _nextBlur() {
  if (_blurIndex == _blurs.length - 1) {
    _blurIndex = 0;
  } else {
    _blurIndex = _blurIndex + 1;
  }
  _blur = _blurs[_blurIndex];
  return _blurs[_blurIndex];
}

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  String email = "";
  String password = "";
  String odUID = " fdd";
  bool showProgress = false;
  final _auth = FirebaseAuth.instance;
  final _fireStore = Firestore.instance;
  bool isLogin = false;

  Future<void> getStatus(String id) async {
    try {
      setState(() {
        showProgress = true;
      });
      final od = await _fireStore.collection('od').document(id).get();
      if (od.exists) {
        if (od.data["level 3"] == true) {
          CoolAlert.show(
            context: context,
            type: CoolAlertType.success,
            text: "Your OD is Verified!",
          );
          setState(() {
            showProgress = false;
          });
          //Alert().show();
        } else if (od.data["level 1"] == true && od.data["level 2"] == false) {
          CoolAlert.show(
            context: context,
            type: CoolAlertType.loading,
            title: 'Verification Pending',
            text:
                "Your OD Is Not Verified\nL-2 & L-3 Verification Pending.\n\nCheck After Sometime!",
          );
          setState(() {
            showProgress = false;
          });
        } else if (od.data["level 1"] == false && od.data["level 2"] == true) {
          CoolAlert.show(
            context: context,
            type: CoolAlertType.loading,
            title: 'Verification Pending',
            text:
                "Your OD Is Not Verified\nOnly L-3 Verification Pending.\n\nCheck After Sometime!",
          );
          setState(() {
            showProgress = false;
          });
        } else if (od.data["level 1"] == true &&
            od.data["level 2"] == true &&
            od.data["level 3"] == false) {
          CoolAlert.show(
            context: context,
            type: CoolAlertType.loading,
            title: 'Verification Pending',
            text:
                "Your OD Is Not Verified\n Only L-3 Verification Pending.\n\nCheck After Sometime!",
          );
          setState(() {
            showProgress = false;
          });
          setState(() {
            showProgress = false;
          });
        }
      } else {
        CoolAlert.show(
          context: context,
          type: CoolAlertType.error,
          title: 'No OD Found',
          text: "Kindly Check ODUID Again",
        );
        setState(() {
          showProgress = false;
        });
      }
    } catch (e) {
      CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        title: 'Unexpected Error',
        text:
            "Probably Due To Internet Connection.Kindly Report The Error To Developer \n" +
                e.toString(),
      );
      setState(() {
        showProgress = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showProgress,
      child: SafeArea(
        child: ListView(children: [
          Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(color: Colors.blue[800]),
                      height: 365,
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Welcome To',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold),
                          ),
                          Hero(
                            tag: 'logo',
                            child: Image(
                                image:
                                    AssetImage('assets/image/ODFIFY copy.png')),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            'Designed And Developed By Agrim Lab',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.0,
                                fontWeight: FontWeight.w200),
                          ),
                          SizedBox(
                            height: 35,
                          ),
                          Column(
                            children: <Widget>[
                              WaveWidget(
                                config: CustomConfig(
                                  colors: [
                                    Colors.blue[200],
                                    Colors.blue[400],
                                    Colors.blue[600],
                                    Colors.blue[800],
                                  ],
                                  durations: [32000, 21000, 18000, 5000],
                                  heightPercentages: [3.45, 3.76, 2.78, 2.14],
                                  blur: _blur,
                                ),
                                size: Size(double.infinity, 45),
                                waveAmplitude: 15,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 60,
                ),
                Container(
                  padding: EdgeInsets.only(left: 50, right: 50, top: 50),
                  child: TextField(
                    onChanged: (value) {
                      odUID = value;
                    },
                    decoration: InputDecoration(
                        suffixIcon: GestureDetector(
                            onTap: () async {
                              if (odUID.length != 0) await getStatus(odUID);
                            },
                            child: Icon(Icons.search)),
                        prefixIcon: Icon(Icons.input),
                        hintText: 'Enter ODUID To See Status'),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 50, right: 50, top: 10),
                  //color: Colors.white,
                  width: double.infinity,
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(10),
                        height: 45,
                        width: MediaQuery.of(context).size.width / 1.45,
                        decoration: BoxDecoration(color: Colors.white),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image(
                              image: AssetImage('assets/image/google.png'),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Text(
                              'Admin Credentials',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextField(
                        onChanged: (value) {
                          email = value.toString().trim();
                        },
                        decoration: InputDecoration(
                            suffixIcon: Icon(Icons.verified_user),
                            prefixIcon: Icon(Icons.input),
                            hintText: 'Enter Unique Id'),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      TextField(
                        onChanged: (value) {
                          password = value.toString().trim();
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                            suffixIcon: Icon(Icons.lock),
                            prefixIcon: Icon(Icons.input),
                            hintText: 'Enter Password'),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                SliderButton(
                  vibrationFlag: false,
                  dismissible: false,
                  shimmer: true,
                  boxShadow: BoxShadow(color: Colors.blue[800], blurRadius: 20),
                  action: () async {
                    if (email == "" ||
                        password == "" ||
                        email == null ||
                        password == null) {
                      Alert(
                        closeFunction: () {},
                        context: context,
                        title: 'Enter All Detail ',
                        desc: 'Enter All required Details To Proceed Login',
                        type: AlertType.warning,
                        buttons: [
                          DialogButton(
                            child: Text(
                              "OK",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            onPressed: () => Navigator.pop(context),
                            width: 120,
                          )
                        ],
                      ).show();
                    } else {
                      setState(() {
                        showProgress = true;
                      });
                      try {
                        final user = await _auth.signInWithEmailAndPassword(
                            email: email, password: password);

                        if (user != null) {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return LoginScreen();
                          }));

                          setState(() {
                            showProgress = false;
                          });
                        }
                      } catch (e) {
                        Alert(
                          closeFunction: () {},
                          context: context,
                          title: 'Invalid Credential',
                          desc: e.toString().split("(")[1].split(",")[0],
                          type: AlertType.warning,
                          buttons: [
                            DialogButton(
                              child: Text(
                                "OK",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              onPressed: () => Navigator.pop(context),
                              width: 120,
                            )
                          ],
                        ).show();

                        setState(() {
                          showProgress = false;
                        });
                      }
                    }
                  },

                  ///Put label over here
                  label: Text(
                    "Slide to Login !",
                    style: TextStyle(
                        color: Color(0xff4a4a4a),
                        fontWeight: FontWeight.w500,
                        fontSize: 22),
                  ),
                  icon: Center(
                      child: Icon(
                    Icons.person_outline,
                    color: Colors.white,
                    size: 40.0,
                    semanticLabel: 'Icon',
                  )),

                  ///Change All the color and size from here.
                  width: 290,
                  radius: 30,
                  buttonColor: Colors.blue[300],
                  backgroundColor: Colors.blue[700],
                  highlightedColor: Colors.white,
                  baseColor: Colors.white60,
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
