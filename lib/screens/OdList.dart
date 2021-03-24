import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'upperUserMenu.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'utility/StudDetail.dart';

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

class ODList extends StatefulWidget {
  @override
  _ODListState createState() => _ODListState();
}

class _ODListState extends State<ODList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Color(0xfff21253E), body: ShowList());
  }
}

class ShowList extends StatefulWidget {
  @override
  _ShowListState createState() => _ShowListState();
}

class _ShowListState extends State<ShowList> {
  final _fireStore = Firestore.instance;
  final _auth = FirebaseAuth.instance;
  String userName = " ";
  String userLevel = " ";
  String userPost = " ";
  bool isLoading = true;
  String userSigned = " ";
  List<ODdata> xodDetails = [];

  Future<void> getCurrentUser() async {
    setState(() {
      isLoading = true;
    });
    try {
      final user = await _auth.currentUser();
      final v = await _fireStore.collection('users').document(user.uid).get();
      setState(() {
        userSigned = user.uid;
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
    getData();
  }

  Future<void> getData() async {
    setState(() {
      isLoading = true;
    });
    if (userSigned.length > 2) {
      try {
        await _fireStore
            .collection("od")
            .getDocuments()
            .then((QuerySnapshot snapshot) {
          snapshot.documents.forEach((f) {
            if (f.data["User Signed"] == userSigned) {
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
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getCurrentUser();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Container(
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
                  padding: EdgeInsets.all(15),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'OD Created By You',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
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
                              'No OD Created By You!! ',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w700),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Text(
                              'Pull Down Refresh',
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
                        padding: EdgeInsets.only(left: 15, right: 15, top: 10),
                        height: 350,
                        child: new ListView.builder(
                            itemCount: xodDetails.length,
                            itemBuilder: (BuildContext ctxt, int index) {
                              return Column(
                                children: <Widget>[
                                  Column(children: [
                                    ExpansionTileCard(
                                      leading: GestureDetector(
                                        onTap: () {},
                                        child: CircleAvatar(
                                            child:
                                                Text((index + 1).toString())),
                                      ),
                                      title: Text(xodDetails[index].xEventName),
                                      subtitle: Text(xodDetails[index].xOdUID),
                                      baseColor: Colors.blue[50],
                                      children: <Widget>[
                                        Divider(
                                          thickness: 1.0,
                                          height: 1.0,
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 16.0,
                                                vertical: 8.0,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text('✦ Event/Workshop :-' +
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
                                                      xodDetails[index].xCoord),
                                                  SizedBox(
                                                    height: 6,
                                                  ),
                                                  Text(
                                                      '✦ Club/Department Name :- ' +
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
                                                    height: 200,
                                                    child: ListView.builder(
                                                        itemCount:
                                                            xodDetails[index]
                                                                .xstudRegNumber
                                                                .length,
                                                        itemBuilder:
                                                            (BuildContext ctxt,
                                                                int i) {
                                                          return StudentDetails(
                                                            name: xodDetails[
                                                                    index]
                                                                .xstudName[i],
                                                            yearSection: xodDetails[
                                                                    index]
                                                                .xstudYearSection[i],
                                                            regNumber: xodDetails[
                                                                    index]
                                                                .xstudRegNumber[i],
                                                            department: xodDetails[
                                                                    index]
                                                                .xstudDepartment[i],
                                                          );
                                                        }),
                                                  ),
                                                ],
                                              )),
                                        ),
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
    );
  }
}
