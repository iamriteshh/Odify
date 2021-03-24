import 'package:flutter/material.dart';
import 'upperUserMenu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:slimy_card/slimy_card.dart';

class SearchOD extends StatefulWidget {
  @override
  _SearchODState createState() => _SearchODState();
}

class _SearchODState extends State<SearchOD> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff21253E),
      body: ODShow(),
    );
  }
}

class ODShow extends StatefulWidget {
  @override
  _ODShowState createState() => _ODShowState();
}

class _ODShowState extends State<ODShow> {
  final _fireStore = Firestore.instance;
  final _auth = FirebaseAuth.instance;
  String userName = " ";
  String userLevel = " ";
  String userPost = " ";
  bool isLoading = true;
  String xodUID = " ";
  String regNumber = " ";

  //Od Details
  String xEventName = " ";
  String xOdLimit = " ";
  String xCoord = " ";
  String xDepartmentName = " ";
  bool verificationPending = false;
  String verificationMessage;
  bool odFound = false;
  String odID = " ";
  var data;
  // End Of OD Details

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

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

  Future<void> getODDetails(String id) async {
    setState(() {
      isLoading = true;
    });
    try {
      final v = await _fireStore
          .collection('od')
          .document(id.toString().trim())
          .get();
      if (v.exists) {
        setState(() {
          odFound = true;
          odID = v.documentID;
        });
        if (v.data["level 3"] == true) {
          print("Found");
          setState(() {
            verificationPending = false;
            xEventName = v.data["Event Name"];
            xDepartmentName = v.data["Event Department"];
            xCoord = v.data["Event Coordinator"];
            xOdLimit = v.data["OD Limit"];
          });
        } else {
          if (v.data["level 1"] == true && v.data["level 2"] == true) {
            setState(() {
              verificationMessage = "Only L-3";
              xEventName = v.data["Event Name"];
              xDepartmentName = v.data["Event Department"];
              xCoord = v.data["Event Coordinator"];
              xOdLimit = v.data["OD Limit"];
            });
          } else if (v.data["level 1"] == false && v.data["level 2"] == true) {
            setState(() {
              verificationMessage = "Only L-3";
              xEventName = v.data["Event Name"];
              xDepartmentName = v.data["Event Department"];
              xCoord = v.data["Event Coordinator"];
              xOdLimit = v.data["OD Limit"];
            });
          } else {
            setState(() {
              verificationMessage = "L-2 , L-3";
              xEventName = v.data["Event Name"];
              xDepartmentName = v.data["Event Department"];
              xCoord = v.data["Event Coordinator"];
              xOdLimit = v.data["OD Limit"];
            });
          }
          setState(() {
            verificationPending = true;
          });
        }
      } else {
        setState(() {
          odFound = false;
          CoolAlert.show(
              context: context,
              type: CoolAlertType.warning,
              title: 'Invalid ODUID',
              text: "Kindly Cross Check The ODUID");
        });
        print("Not Found");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
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
    setState(() {
      isLoading = true;
    });
    try {
      bool found = false;
      final v = await _fireStore.collection('od').document(odID).get();
      v.data["Register Number"].forEach((ra) {
        if (ra == reg) {
          found = true;
        }
      });
      if (found == true) {
        CoolAlert.show(
            animType: CoolAlertAnimType.rotate,
            context: context,
            type: CoolAlertType.success,
            title: 'Student Is On OD',
            text: reg + "\nis present in this OD.\nOD Limit Is - " + xOdLimit);
      } else {
        CoolAlert.show(
            animType: CoolAlertAnimType.rotate,
            context: context,
            type: CoolAlertType.error,
            title: 'Student Is Not On OD',
            text: reg + "\nis not present in this OD.");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
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

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            //padding: EdgeInsets.only(top: 15),
            child: Column(
              children: <Widget>[
                UpperMenu(),
                DisplayUser(
                  name: userName,
                  post: userPost,
                ),
                SizedBox(
                  height: 12,
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  child: TextField(
                    onChanged: (value) {
                      xodUID = value;
                    },
                    style: TextStyle(color: Colors.white),
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                        labelText: 'Enter ODUID ',
                        labelStyle: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w300),
                        hintText: 'enCdFSrYofdBTRfgCKAR',
                        hintStyle: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w300),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
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
                            if (xodUID.length == 0) {
                              setState(() {
                                odFound = false;
                              });
                            }
                            await getODDetails(xodUID);
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
                odFound
                    ? Container(
                        padding: EdgeInsets.all(15),
                        child: SlimyCard(
                          color: Color(0xfff2979FF),
                          width: MediaQuery.of(context).size.width,
                          topCardHeight: 290,
                          bottomCardHeight: 125,
                          borderRadius: 15,
                          topCardWidget: Container(
                            padding:
                                EdgeInsets.only(top: 15, left: 15, right: 15),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  height: 65,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(50)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        verificationPending
                                            ? Icons.info
                                            : Icons.check_box,
                                        color: verificationPending
                                            ? Colors.pink
                                            : Colors.green,
                                        size: 40,
                                      ),
                                      Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          verificationPending
                                              ? verificationMessage + ' Pending'
                                              : 'OD IS VERIFIED',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 30,
                                              fontWeight: FontWeight.w800),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Container(
                                    padding: EdgeInsets.all(15),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            '◉ Event/Workshop :- ' + xEventName,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 7,
                                        ),
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            '◉ Department/Club :- ' +
                                                xDepartmentName,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 7,
                                        ),
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            '◉ OD Limit :- ' + xOdLimit,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 7,
                                        ),
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            '◉ Coordinator :- ' + xCoord,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Text(
                                  'Tap To Search For Register Number',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w200),
                                )
                              ],
                            ),
                          ),
                          bottomCardWidget: Container(
                            padding: EdgeInsets.all(15),
                            child: TextField(
                              textCapitalization: TextCapitalization.sentences,
                              onChanged: (value) {
                                regNumber = value.toUpperCase();
                              },
                              style: TextStyle(color: Colors.white),
                              cursorColor: Colors.white,
                              decoration: InputDecoration(
                                  labelText: 'Enter Register Number',
                                  labelStyle: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w300),
                                  hintText: 'RA1811003020013',
                                  hintStyle: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w300),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(18),
                                    borderSide:
                                        BorderSide(color: Colors.orange),
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
                                    onTap: () {
                                      String ra = regNumber.toUpperCase();
                                      verifyRA(ra);
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
                          slimeEnabled: true,
                        ),
                      )
                    : Container()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
