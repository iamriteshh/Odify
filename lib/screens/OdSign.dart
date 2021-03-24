import 'package:flutter/material.dart';
import 'upperUserMenu.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'utility/StudDetail.dart';
import 'package:slider_button/slider_button.dart';
import 'utility/ODConvention.dart';
import 'utility/BlockDesign.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'createOD.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:cool_alert/cool_alert.dart';

class ODdata {
  String xEventName;
  String xOdLimit;
  String xCoord;
  String xDepartmentName;
  String xOdUID;
  List<String> xstudName = [];
  List<String> xstudRegNumber = [];
  List<String> xstudYearSection = [];
  List<String> xstudDepartment = [];
}

class SignOD extends StatefulWidget {
  @override
  _SignODState createState() => _SignODState();
}

class _SignODState extends State<SignOD> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PermitOD(),
    );
  }
}

class PermitOD extends StatefulWidget {
  @override
  _PermitODState createState() => _PermitODState();
}

class _PermitODState extends State<PermitOD> {
  final _fireStore = Firestore.instance;
  final _auth = FirebaseAuth.instance;
  String userName = " ";
  String userLevel = " ";
  String userPost = " ";
  bool isLoading = true;
  bool isRevoke = false;
  String userDepartment = " ";
  // OD Data Variables

  List<ODdata> xodDetails = [];

  //End Of OD Data Variables
  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  Future<void> getData() async {
    setState(() {
      isLoading = true;
    });
    if (userLevel == "2") {
      try {
        await _fireStore
            .collection("od")
            .getDocuments()
            .then((QuerySnapshot snapshot) {
          snapshot.documents.forEach((f) {
            if (f.data["level 1"] == true &&
                f.data["level 3"] == false &&
                f.data["level 2"] == false &&
                f.data["OD Department"] == userDepartment) {
              //Getting And Adding OD Data
              setState(() {
                ODdata obj = new ODdata();
                obj.xEventName = f.data["Event Name"];
                obj.xOdUID = f.documentID.toString();
                obj.xCoord = f.data["Event Coordinator"];
                obj.xDepartmentName = "CSE";
                obj.xOdLimit = f.data["OD Limit"];

                //End Of Getting And Adding OD Data
                //Getting Student Data
                f.data["Name"].forEach((name) {
                  obj.xstudName.add(name);
                });
                f.data["Department"].forEach((dept) {
                  obj.xstudDepartment.add(dept);
                });
                f.data["Register Number"].forEach((reg) {
                  obj.xstudRegNumber.add(reg);
                });
                f.data["Year Section"].forEach((ysec) {
                  obj.xstudYearSection.add(ysec);
                });
                xodDetails.add(obj);
              });
            }
          });
        });
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
    } else if (userLevel == "3") {
      try {
        await _fireStore
            .collection("od")
            .getDocuments()
            .then((QuerySnapshot snapshot) {
          snapshot.documents.forEach((f) {
            if ((f.data["level 1"] == true &&
                    f.data["level 2"] == true &&
                    f.data["level 3"] == false &&
                    f.data["OD Department"] == userDepartment) ||
                (f.data["level 1"] == false &&
                    f.data["level 2"] == true &&
                    f.data["level 3"] == false &&
                    f.data["OD Department"] == userDepartment)) {
              //Getting And Adding OD Data
              setState(() {
                ODdata obj = new ODdata();
                obj.xEventName = f.data["Event Name"];
                obj.xOdUID = f.documentID.toString();
                obj.xCoord = f.data["Event Coordinator"];
                obj.xDepartmentName = f.data["Event Department"];
                obj.xOdLimit = f.data["OD Limit"];

                //End Of Getting And Adding OD Data
                //Getting Student Data
                f.data["Name"].forEach((name) {
                  obj.xstudName.add(name);
                });
                f.data["Department"].forEach((dept) {
                  obj.xstudDepartment.add(dept);
                });
                f.data["Register Number"].forEach((reg) {
                  obj.xstudRegNumber.add(reg);
                });
                f.data["Year Section"].forEach((ysec) {
                  obj.xstudYearSection.add(ysec);
                });
                xodDetails.add(obj);
              });
            }
          });
        });
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
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      final v = await _fireStore.collection('users').document(user.uid).get();
      setState(() {
        userName = v.data["Name"].toString();
        userLevel = v.data["Level"];
        userPost = v.data["Post"].toString();
        userDepartment = v.data["Department"].toString();
        print(userDepartment);
      });
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
    getData();
  }

  void signOD({final id, int index}) async {
    setState(() {
      isLoading = true;
    });
    //Update Signature
    try {
      var doc = _fireStore.collection("od").document(id);
      String admin = "level " + userLevel.toString();
      await doc.updateData({admin: true});

      if (userLevel == "3") {
        await Firestore.instance
            .collection("verifiedRA")
            .document('RlAXhnbbsuYV7Ebkbnfv')
            .updateData({
          "RA": FieldValue.arrayUnion(xodDetails[index].xstudRegNumber)
        });
      }

      xodDetails.removeAt(index);
      xodDetails.clear();
    } catch (e) {
      Alert(
              context: context,
              title: 'Error Occurred',
              type: AlertType.error,
              desc: e.toString())
          .show();
    }

    //Update Signature
    setState(() {
      getData();
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        xodDetails.clear();
        return getCurrentUser();
      },
      child: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              color: Color(0xfff21253E),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    UpperMenu(),
                    DisplayUser(
                      name: userName,
                      post: userPost,
                    ),
                    SizedBox(
                      height: 17,
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
                      height: 8,
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
                              onTap: () {},
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
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (conext) {
                                  return CreateOD();
                                }));
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
                                              borderSide: BorderSide(
                                                  color: Colors.black),
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
                                        onPressed: () {
                                          setState(() {
                                            isRevoke = true;
                                          });
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          "Revoke OD",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
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
                      height: 18,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 15),
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Row(
                            children: <Widget>[
                              Text(
                                'OD To Verify ',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900),
                              ),
                              Spacer(),
                              Text(
                                'Tap On Numeric Data\nTo Directly Sign OD',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w200),
                              )
                            ],
                          )),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ODConventionMarquee(),
                    SizedBox(
                      height: 10,
                    ),
                    xodDetails.length == 0
                        ? Container(
                            height: 320,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'All Done !! ',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontWeight: FontWeight.w700),
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                Text(
                                  'Pull Down To Get New Task ',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400),
                                )
                              ],
                            ),
                          )
                        : Container(
                            padding:
                                EdgeInsets.only(left: 15, right: 15, top: 10),
                            height: 350,
                            child: new ListView.builder(
                                itemCount: xodDetails.length,
                                itemBuilder: (BuildContext ctxt, int index) {
                                  return Column(
                                    children: <Widget>[
                                      Column(children: [
                                        ExpansionTileCard(
                                          leading: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                signOD(
                                                    id: xodDetails[index]
                                                        .xOdUID,
                                                    index: index);
                                              });
                                            },
                                            child: CircleAvatar(
                                                child: Text(
                                                    (index + 1).toString())),
                                          ),
                                          title: Text(
                                              xodDetails[index].xEventName),
                                          subtitle:
                                              Text(xodDetails[index].xOdUID),
                                          baseColor: Colors.blue[50],
                                          children: <Widget>[
                                            Divider(
                                              thickness: 1.0,
                                              height: 1.0,
                                            ),
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 16.0,
                                                    vertical: 8.0,
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text(
                                                          '✦ Event/Workshop :-' +
                                                              xodDetails[index]
                                                                  .xEventName),
                                                      SizedBox(
                                                        height: 6,
                                                      ),
                                                      Text('✦ OD Limit :- ' +
                                                          xodDetails[index]
                                                              .xOdLimit),
                                                      SizedBox(
                                                        height: 6,
                                                      ),
                                                      Text('✦ Coordinator:- ' +
                                                          xodDetails[index]
                                                              .xCoord),
                                                      SizedBox(
                                                        height: 6,
                                                      ),
                                                      Text('✦ Club/Department Name :- ' +
                                                          xodDetails[index]
                                                              .xDepartmentName),
                                                      SizedBox(
                                                        height: 6,
                                                      ),
                                                      Align(
                                                        alignment:
                                                            Alignment.topCenter,
                                                        child: Text(
                                                          '\nStudent Details (Scroll To See More)',
                                                          style: TextStyle(
                                                              fontSize: 16),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 6,
                                                      ),
                                                      Container(
                                                        height: 140,
                                                        child: ListView.builder(
                                                            itemCount: xodDetails[
                                                                    index]
                                                                .xstudRegNumber
                                                                .length,
                                                            itemBuilder:
                                                                (BuildContext
                                                                        ctxt,
                                                                    int i) {
                                                              return StudentDetails(
                                                                name: xodDetails[
                                                                        index]
                                                                    .xstudName[i],
                                                                yearSection:
                                                                    xodDetails[
                                                                            index]
                                                                        .xstudYearSection[i],
                                                                regNumber: xodDetails[
                                                                        index]
                                                                    .xstudRegNumber[i],
                                                                department:
                                                                    xodDetails[
                                                                            index]
                                                                        .xstudDepartment[i],
                                                              );
                                                            }),
                                                      ),
                                                    ],
                                                  )),
                                            ),
                                            ButtonBar(
                                                alignment: MainAxisAlignment
                                                    .spaceAround,
                                                buttonHeight: 52.0,
                                                buttonMinWidth: 90.0,
                                                children: <Widget>[
                                                  SliderButton(
                                                    vibrationFlag: false,
                                                    action: () {
                                                      setState(() {
                                                        signOD(
                                                            id: xodDetails[
                                                                    index]
                                                                .xOdUID,
                                                            index: index);
                                                      });
                                                    },

                                                    ///Put label over here
                                                    label: Text(
                                                      "Slide to Sign OD !",
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xff4a4a4a),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 22),
                                                    ),
                                                    icon: Center(
                                                        child: Icon(
                                                      Icons.done,
                                                      color: Colors.white,
                                                      size: 40.0,
                                                      semanticLabel: '',
                                                    )),

                                                    ///Change All the color and size from here.
                                                    width: 290,
                                                    radius: 50,
                                                    buttonColor:
                                                        Colors.green[400],
                                                    backgroundColor:
                                                        Colors.blue[400],
                                                    highlightedColor:
                                                        Colors.white,
                                                    baseColor: Colors.white38,
                                                  ),
                                                ]),
                                          ],
                                        ),
                                      ]),
                                      SizedBox(
                                        height: 11,
                                      ),
                                    ],
                                  );
                                })),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
