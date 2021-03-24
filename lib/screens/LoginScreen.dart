import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'upperUserMenu.dart';
import 'utility/Footer.dart';
import 'utility/BlockDesign.dart';
import 'OdSign.dart';
import 'utility/ODConvention.dart';
import 'createOD.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:cool_alert/cool_alert.dart';
import 'SearchOD.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoggedScreen(),
    );
  }
}

class LoggedScreen extends StatefulWidget {
  @override
  _LoggedScreenState createState() => _LoggedScreenState();
}

class _LoggedScreenState extends State<LoggedScreen> {
  final _fireStore = Firestore.instance;
  final _auth = FirebaseAuth.instance;
  String userName = " ";
  String userLevel = " ";
  String userPost = " ";
  bool isLoading = true;
  String regNumber = " ";
  bool verified = false;
  String odID;
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  // All Functions -- Area 51
  Future<void> getCurrentUser() async {
    setState(() {
      isLoading = true;
    });
    try {
      final user = await _auth.currentUser();
      final v = await _fireStore.collection('users').document(user.uid).get();
      setState(() {
        userName = v.data["Name"].toString();
        userLevel = v.data["Level"];
        userPost = v.data["Post"].toString();
      });
      //userPost = v.data["Post"].toString();

    } catch (e) {
      CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        title: 'Unexpected Error',
        text:
            "Probably Due To Internet Connection.Kindly Report The Error To Developer \n" +
                e.toString(),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> verifyRA(String reg) async {
    try {
      setState(() {
        isLoading = true;
      });
      final v = await _fireStore
          .collection('verifiedRA')
          .document('RlAXhnbbsuYV7Ebkbnfv')
          .get();
      await v.data["RA"].forEach((value) {
        if (reg == value) {
          setState(() {
            verified = true;
          });
        }
      });
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> revokeOD(String id) async {
    try {
      final v = await _fireStore.collection('od').document(id).get();
      if (v.exists) {
        final docOD = await _fireStore.collection('od').document(id).get();

        List<String> regNumber = [];
        await docOD.data["Register Number"].forEach((value) {
          regNumber.add(value.toString());
        });

        try {
          await Firestore.instance
              .collection("verifiedRA")
              .document('RlAXhnbbsuYV7Ebkbnfv')
              .updateData({"RA": FieldValue.arrayRemove(regNumber)});
        } catch (e) {
          print(e);
        }
        await _fireStore.collection('od').document(id).delete();
        Alert(
          closeFunction: () {},
          type: AlertType.success,
          context: context,
          title: 'Revoked',
          desc: 'Successfully',
        ).show();
      } else {
        Alert(
          closeFunction: () {},
          type: AlertType.warning,
          context: context,
          title: 'OD Not Found/Deleted',
          desc: 'Check UID Number',
        ).show();
      }
    } catch (e) {
      Alert(
        closeFunction: () {},
        type: AlertType.error,
        context: context,
        title: 'Error',
        desc: e.toString() + '\nReport To Developers',
      ).show();
    }
  }

// End Of All Functions -- Area 51
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        return getCurrentUser();
      },
      child: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: SingleChildScrollView(
          child: SafeArea(
            child: Container(
              width: double.infinity,
              color: Color(0xfff21253E),
              child: Column(
                children: <Widget>[
                  UpperMenu(),
                  DisplayUser(
                    name: userName,
                    post: userPost,
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 15),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'My Options',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white)),
                      padding: EdgeInsets.only(left: 15, top: 5, bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          //Sign Od Start
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return SignOD();
                              }));
                            },
                            child: BlockOption(
                              kcolorGrad1: 0xfffFB9683,
                              kcolorGrad2: 0xfffFC5B7E,
                              ktitle: 'Sign OD',
                              ksubTitle: '3 New',
                              ktitleFontSize: 18.0,
                              ksubTitileFontsize: 12.0,
                              kicon: Icons.check_circle,
                            ),
                          ),
                          SizedBox(width: 18),
                          //End Of Sign Od

                          //Check OD Start
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return SearchOD();
                              }));
                            },
                            child: BlockOption(
                              kcolorGrad1: 0xfffFF5EBB,
                              kcolorGrad2: 0xfffFF78B2,
                              ktitle: 'Check OD',
                              ksubTitle: '130 Total',
                              ktitleFontSize: 18.0,
                              ksubTitileFontsize: 12.0,
                              kicon: Icons.album,
                            ),
                          ),
                          SizedBox(width: 18),
                          //End of check od

                          //Start of Create OD
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (conext) {
                                    return CreateOD();
                                  },
                                ),
                              );
                            },
                            child: BlockOption(
                              kcolorGrad1: 0xfffA231FB,
                              kcolorGrad2: 0xfff7D2FFF,
                              ktitle: 'Create OD',
                              ksubTitle: 'New OD',
                              ktitleFontSize: 18.0,
                              ksubTitileFontsize: 12.0,
                              kicon: Icons.open_in_browser,
                            ),
                          ),
                          SizedBox(width: 18),
                          //End of Create OD

                          //Start of Revoke OD
                          GestureDetector(
                            onTap: () {
                              Alert(
                                  closeFunction: () {},
                                  context: context,
                                  title: 'Revoke OD',
                                  desc: 'Delete OD From Database',
                                  type: AlertType.error,
                                  content: Column(
                                    children: <Widget>[
                                      SizedBox(
                                        height: 14,
                                      ),
                                      TextField(
                                        onChanged: (value) {
                                          odID = value;
                                        },
                                        style: TextStyle(color: Colors.black),
                                        cursorColor: Colors.white,
                                        decoration: InputDecoration(
                                          labelText: 'Enter OD UID',
                                          labelStyle: TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.w300),
                                          hintText: 'UX12345FG',
                                          hintStyle: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w300),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.orange),
                                          ),
                                          border: UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.black),
                                          ),
                                          prefixIcon: Icon(
                                            Icons.input,
                                            color: Colors.green[200],
                                          ),
                                          focusColor: Colors.black,
                                          hoverColor: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  buttons: [
                                    DialogButton(
                                      onPressed: () async {
                                        Navigator.pop(context);
                                        setState(() {
                                          isLoading = true;
                                        });
                                        if (odID.length > 0)
                                          await revokeOD(odID);
                                        print(odID);
                                        setState(() {
                                          isLoading = false;
                                        });
                                      },
                                      child: Text(
                                        "Revoke OD",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                    )
                                  ]).show();
                            },
                            child: BlockOption(
                              kcolorGrad1: 0xfff3C66FA,
                              kcolorGrad2: 0xfff4A4DAC,
                              ktitle: 'Revoke OD',
                              ksubTitle: 'Delete OD',
                              ktitleFontSize: 16.0,
                              ksubTitileFontsize: 12.0,
                              kicon: Icons.delete,
                            ),
                          ),
                          //End Of Revoke OD
                          SizedBox(width: 18)
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 15, top: 10, bottom: 2),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Verify Student OD',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 15, top: 4, right: 15),
                    child: TextField(
                      onChanged: (value) {
                        regNumber = value;
                      },
                      style: TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                          labelText: 'Enter Register Number',
                          labelStyle: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.w300),
                          hintText: 'RA1811003020013',
                          hintStyle: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w300),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.orange),
                          ),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          prefixIcon: Icon(
                            Icons.input,
                            color: Colors.green[200],
                          ),
                          focusColor: Colors.white,
                          hoverColor: Colors.red,
                          suffix: GestureDetector(
                            onTap: () async {
                              if (regNumber.length > 0) {
                                regNumber = regNumber.toUpperCase();
                                await verifyRA(regNumber);
                                if (verified == true) {
                                  setState(() {
                                    verified = false;
                                  });
                                  Alert(
                                    context: context,
                                    title: 'On OD',
                                    type: AlertType.success,
                                    desc: regNumber +
                                        ' is on OD , click on \'Check OD\' to get descripton of the OD',
                                  ).show();
                                } else {
                                  Alert(
                                      context: context,
                                      title: 'No OD',
                                      type: AlertType.warning,
                                      desc: regNumber +
                                          ' Is Not Found In Database',
                                      buttons: [
                                        DialogButton(
                                          onPressed: () {
                                            setState(() {
                                              //do Something
                                            });
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            "Ok",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20),
                                          ),
                                        )
                                      ]).show();
                                }
                              }
                            },
                            child: Container(
                              child: Icon(
                                Icons.search,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                          )),
                    ),
                  ),
                  ODConvention(),
                  ODConventionMarquee(),
                  SizedBox(
                    height: 30,
                  ),
                  Footer()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
