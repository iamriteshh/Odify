import 'package:flutter/material.dart';
import 'upperUserMenu.dart';
import 'package:floating_action_row/floating_action_row.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';
import 'package:cool_alert/cool_alert.dart';

//Text Field Controller
final TextEditingController upperEventController = new TextEditingController();
final TextEditingController upperCoordController = new TextEditingController();
final TextEditingController upperDepartmentController =
    new TextEditingController();
final TextEditingController upperODLimitController =
    new TextEditingController();

final TextEditingController lowerNameController = new TextEditingController();
final TextEditingController lowerYearSecController =
    new TextEditingController();
final TextEditingController lowerRegController = new TextEditingController();
final TextEditingController lowerDepartmentController =
    new TextEditingController();

class CreateOD extends StatefulWidget {
  @override
  _CreateODState createState() => _CreateODState();
}

class _CreateODState extends State<CreateOD> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ODcreate(),
    );
  }
}

class ODcreate extends StatefulWidget {
  @override
  _ODcreateState createState() => _ODcreateState();
}

class _ODcreateState extends State<ODcreate> {
  String xeventName = " ";
  String xeventCordinatorName = " ";
  String xEventDepartment = " ";
  String xODTimeLimit = "FH";
  String xStudentName = " ";
  String xYearSection = " ";
  String xRegNumber = " ";
  String xStudDepartment = "Computer Science";
  String xodUID = " ";
  String xOdDepartment = "Computer Science";

  List<String> qStudName = [];
  List<String> qYearSection = [];
  List<String> qRegNumber = [];
  List<String> qDepartment = [];

  final _fireStore = Firestore.instance;
  final _auth = FirebaseAuth.instance;
  String userName = " ";
  String userLevel = " ";
  String userPost = " ";
  String userSigned = " ";
  bool isLoading = true;

  void initState() {
    super.initState();
    getCurrentUser();
  }

  //Function Arear --Area 51
  void allControllerClear() {
    setState(() {
      lowerNameController.clear();
      lowerYearSecController.clear();
      lowerRegController.clear();
      lowerDepartmentController.clear();
      upperEventController.clear();
      upperCoordController.clear();
      upperDepartmentController.clear();
      upperODLimitController.clear();
    });
  }

  void lowerControllerClear() {
    lowerNameController.clear();
    lowerYearSecController.clear();
    lowerRegController.clear();
    lowerDepartmentController.clear();
  }

  void upperControllerClear() {
    upperEventController.clear();
    upperCoordController.clear();
    upperDepartmentController.clear();
    upperODLimitController.clear();
  }

  void dataClear() {
    setState(() {
      qStudName.clear();
      qYearSection.clear();
      qRegNumber.clear();
      qDepartment.clear();
    });
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      final v = await _fireStore.collection('users').document(user.uid).get();
      setState(() {
        userSigned = user.uid;
        userName = v.data["Name"].toString();
        userLevel = v.data["Level"];
        userPost = v.data["Post"].toString();
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
  }

  void addData() {
    qStudName.add(xStudentName);
    qYearSection.add(xYearSection);
    qRegNumber.add(xRegNumber);
    qDepartment.add(xStudDepartment);
  }
  //End Of Function Arear --Area 51

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: SafeArea(
        child: SingleChildScrollView(
          child: SafeArea(
            child: Container(
              color: Color(0xfff21253E),
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Column(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    UpperMenu(),
                    DisplayUser(
                      name: userName,
                      post: userPost,
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 17, left: 16),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Create OD',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Container(
                      height: 65,
                      padding: EdgeInsets.only(left: 15, top: 4, right: 15),
                      child: Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.orange)),
                        child: DropdownButton(
                          dropdownColor: Color(0xfff21253E),
                          style: new TextStyle(
                            color: Colors.white,
                          ),
                          isExpanded: true,
                          underline: SizedBox(),
                          value: xOdDepartment,
                          items: [
                            'Computer Science',
                            'Mechanical',
                            'Electronics & Communication',
                            'Civil',
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              xOdDepartment = value;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    // Start Of Event Name
                    Container(
                      width: double.infinity,
                      height: 65,
                      padding: EdgeInsets.only(left: 15, top: 4, right: 15),
                      child: TextField(
                        controller: upperEventController,
                        onChanged: (value) {
                          xeventName = value.trim();
                        },
                        style: TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          labelText: 'Enter Event Name',
                          labelStyle: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.w300),
                          hintText: 'Data Strcture & Algo',
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
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    //End Of Event Name

                    //Start Of Event Coordinator Name
                    Container(
                      width: double.infinity,
                      height: 65,
                      padding: EdgeInsets.only(left: 15, top: 4, right: 15),
                      child: TextField(
                        controller: upperCoordController,
                        onChanged: (value) {
                          xeventCordinatorName = value.trim();
                        },
                        style: TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          labelText: 'Event Coordinator Name',
                          labelStyle: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.w300),
                          hintText: 'Prof Ritesh Singh',
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
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    //End Of  Event Coordinator Name

                    // Start Of Department And OD Limit
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 220,
                            height: 65,
                            padding:
                                EdgeInsets.only(left: 15, top: 4, right: 15),
                            child: TextField(
                              controller: upperDepartmentController,
                              onChanged: (value) {
                                xEventDepartment = value.toUpperCase().trim();
                              },
                              style: TextStyle(color: Colors.white),
                              cursorColor: Colors.white,
                              decoration: InputDecoration(
                                labelText: 'Dept/Club/Org',
                                labelStyle: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w300),
                                hintText: 'Agrim Lab',
                                hintStyle: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300),
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
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Container(
                            width: 180,
                            height: 65,
                            padding:
                                EdgeInsets.only(left: 15, top: 4, right: 15),
                            child: Container(
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.orange)),
                              child: DropdownButton(
                                dropdownColor: Color(0xfff21253E),
                                style: new TextStyle(
                                  color: Colors.white,
                                ),
                                isExpanded: true,
                                underline: SizedBox(),
                                value: xODTimeLimit,
                                items: [
                                  'FH',
                                  'SH',
                                  'FD',
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    xODTimeLimit = value;
                                  });
                                },
                              ),
                            ),
                          ),

                          // Container(
                          //   width: 180,
                          //   height: 65,
                          //   padding:
                          //       EdgeInsets.only(left: 15, top: 4, right: 15),
                          //   child: TextField(
                          //     controller: upperODLimitController,
                          //     onChanged: (value) {
                          //       xODTimeLimit = value;
                          //     },
                          //     style: TextStyle(color: Colors.white),
                          //     cursorColor: Colors.white,
                          //     decoration: InputDecoration(
                          //       labelText: 'OD Limit',
                          //       labelStyle: TextStyle(
                          //           color: Colors.blue,
                          //           fontWeight: FontWeight.w300),
                          //       hintText: 'First Half / Second Half / Full Day',
                          //       hintStyle: TextStyle(
                          //           color: Colors.white,
                          //           fontWeight: FontWeight.w300),
                          //       enabledBorder: OutlineInputBorder(
                          //         borderSide: BorderSide(color: Colors.orange),
                          //       ),
                          //       border: UnderlineInputBorder(
                          //         borderSide: BorderSide(color: Colors.white),
                          //       ),
                          //       prefixIcon: Icon(
                          //         Icons.input,
                          //         color: Colors.green[200],
                          //       ),
                          //       focusColor: Colors.white,
                          //       hoverColor: Colors.red,
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 22,
                    ),
                    // End Of Department And od Limit

                    //Sart of Student Data
                    Text(
                      'Enter Student\'s Data',
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                    SizedBox(
                      height: 12,
                    ),

                    //Start Of Student Name And Year Sec
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          // Start of Name of Student
                          Container(
                            width: 225,
                            height: 65,
                            padding:
                                EdgeInsets.only(left: 15, top: 4, right: 15),
                            child: TextField(
                              controller: lowerNameController,
                              onChanged: (value) {
                                xStudentName = value.toUpperCase().trim();
                              },
                              style: TextStyle(color: Colors.white),
                              cursorColor: Colors.white,
                              decoration: InputDecoration(
                                labelText: 'Name',
                                labelStyle: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300),
                                hintText: 'Shubham Kumar',
                                hintStyle: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.lime),
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
                              ),
                            ),
                          ),
                          //End Of Name Of Student

                          //Start of Year/Section
                          Container(
                            width: 180,
                            height: 65,
                            padding:
                                EdgeInsets.only(left: 15, top: 4, right: 15),
                            child: TextField(
                              controller: lowerYearSecController,
                              onChanged: (value) {
                                xYearSection = value.toUpperCase().trim();
                              },
                              style: TextStyle(color: Colors.white),
                              cursorColor: Colors.white,
                              decoration: InputDecoration(
                                labelText: 'Year/Sec',
                                labelStyle: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300),
                                hintText: '3A',
                                hintStyle: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.lime),
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
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    //End of Student Name And Year Sec

                    //Start Of Register Number
                    Container(
                      width: double.infinity,
                      height: 65,
                      padding: EdgeInsets.only(left: 15, top: 4, right: 15),
                      child: TextField(
                        controller: lowerRegController,
                        onChanged: (value) {
                          xRegNumber = value.toUpperCase().trim();
                        },
                        style: TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          labelText: 'Register Number',
                          labelStyle: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w300),
                          hintText: 'RA1811003020013',
                          hintStyle: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w300),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.lime),
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
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    //End Of Register Number
                    //Start Of Department
                    Container(
                      height: 65,
                      padding: EdgeInsets.only(left: 15, top: 4, right: 15),
                      child: Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.lime)),
                        child: DropdownButton(
                          dropdownColor: Color(0xfff21253E),
                          style: new TextStyle(
                            color: Colors.white,
                          ),
                          isExpanded: true,
                          underline: SizedBox(),
                          value: xStudDepartment,
                          items: [
                            'Computer Science',
                            'Mechanical',
                            'Electronics & Communication',
                            'Civil',
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              xStudDepartment = value;
                            });
                          },
                        ),
                      ),
                    ),
                    // //Start Of Department
                    // Container(
                    //   width: double.infinity,
                    //   height: 65,
                    //   padding: EdgeInsets.only(left: 15, top: 4, right: 15),
                    //   child: TextField(
                    //     controller: lowerDepartmentController,
                    //     onChanged: (value) {
                    //       xStudDepartment = value;
                    //     },
                    //     style: TextStyle(color: Colors.white),
                    //     cursorColor: Colors.white,
                    //     decoration: InputDecoration(
                    //       labelText: 'Department',
                    //       labelStyle: TextStyle(
                    //           color: Colors.white, fontWeight: FontWeight.w300),
                    //       hintText: 'Computer Science',
                    //       hintStyle: TextStyle(
                    //           color: Colors.white, fontWeight: FontWeight.w300),
                    //       enabledBorder: OutlineInputBorder(
                    //         borderSide: BorderSide(color: Colors.lime),
                    //       ),
                    //       border: UnderlineInputBorder(
                    //         borderSide: BorderSide(color: Colors.white),
                    //       ),
                    //       prefixIcon: Icon(
                    //         Icons.input,
                    //         color: Colors.green[200],
                    //       ),
                    //       focusColor: Colors.white,
                    //       hoverColor: Colors.red,
                    //     ),
                    //   ),
                    // ),
                    SizedBox(
                      height: 25,
                    ),
                    //End Of Department
                    FloatingActionRow(
                      color: Colors.blueAccent,
                      children: <Widget>[
                        FloatingActionRowButton(
                            icon: Icon(Icons.add),
                            onTap: () {
                              setState(() {
                                if (xeventName != " " &&
                                    xeventCordinatorName != " " &&
                                    xEventDepartment != " " &&
                                    xODTimeLimit != " " &&
                                    xStudentName != " " &&
                                    xYearSection != " " &&
                                    xRegNumber != " " &&
                                    xStudDepartment != " ") {
                                  addData();
                                } else {
                                  Alert(
                                    closeFunction: () {},
                                    context: context,
                                    type: AlertType.warning,
                                    title: "Incomplete Data",
                                    desc: "Please Fill All The Data",
                                    buttons: [
                                      DialogButton(
                                        child: Text(
                                          "Ok",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                        onPressed: () => Navigator.pop(context),
                                        width: 120,
                                      )
                                    ],
                                  ).show();
                                }
                              });
                            }),
                        FloatingActionRowDivider(),
                        FloatingActionRowButton(
                            icon: Icon(Icons.clear),
                            onTap: () {
                              setState(() {
                                lowerControllerClear();
                              });
                            }),
                        FloatingActionRowDivider(),
                        FloatingActionRowButton(
                            icon: Icon(Icons.change_history),
                            onTap: () {
                              setState(() {
                                upperControllerClear();
                              });
                            }),
                        FloatingActionRowDivider(),
                        FloatingActionRowButton(
                            icon: Icon(Icons.clear_all),
                            onTap: () {
                              setState(() {
                                dataClear();
                                lowerNameController.clear();
                                lowerYearSecController.clear();
                                lowerRegController.clear();
                                lowerDepartmentController.clear();
                                upperEventController.clear();
                                upperCoordController.clear();
                                upperDepartmentController.clear();
                                upperODLimitController.clear();
                              });
                            }),
                        FloatingActionRowDivider(),
                        FloatingActionRowButton(
                            icon: Icon(Icons.arrow_forward),
                            onTap: () async {
                              //Adding Data To Database
                              if (qStudName.length > 0 &&
                                  qRegNumber.length > 0 &&
                                  qDepartment.length > 0 &&
                                  qYearSection.length > 0) {
                                setState(() {
                                  isLoading = true;
                                });
                                //Adding Event Data
                                try {
                                  await _fireStore.collection('od').add({
                                    "Event Name": xeventName,
                                    "Event Coordinator": xeventCordinatorName,
                                    "Event Department": xEventDepartment,
                                    "OD Limit": xODTimeLimit,
                                    "User Signed": userSigned,
                                    "OD Department": xOdDepartment,
                                    "level 3": userLevel == "3" ? true : false,
                                    "level 2": userLevel == "2" ? true : false,
                                    "level 1": userLevel == "1" ? true : false,
                                  }).then((value) {
                                    setState(() {
                                      xodUID = value.documentID.toString();
                                      allControllerClear();
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
                                //End Of Event Data
                                // Adding Student Data To Database
                                try {
                                  var doc = _fireStore
                                      .collection("od")
                                      .document(xodUID);
                                  var doc2 = _fireStore
                                      .collection("verifiedRA")
                                      .document("RlAXhnbbsuYV7Ebkbnfv");
                                  await doc.updateData({"Name": qStudName});
                                  await doc.updateData(
                                      {"Year Section": qYearSection});
                                  await doc.updateData(
                                      {"Register Number": qRegNumber});
                                  await doc
                                      .updateData({"Department": qDepartment});
                                  await doc2.updateData({"RA": qRegNumber});
                                } catch (e) {
                                  Alert(
                                          closeFunction: () {},
                                          context: context,
                                          title: "Error Occurred",
                                          desc: e.toString(),
                                          type: AlertType.error)
                                      .show();
                                }
                                setState(() {
                                  isLoading = false;
                                });
                                //End Of Adding Data to Database
                                //Showing Success Result
                                Alert(
                                  closeFunction: () {},
                                  context: context,
                                  type: AlertType.success,
                                  title: "OD Created Successfully",
                                  desc: "OD UID Number\n$xodUID",
                                  buttons: [
                                    DialogButton(
                                      child: Text(
                                        "Ok",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                      onPressed: () => Navigator.pop(context),
                                      width: 120,
                                    ),
                                    DialogButton(
                                      child: Text(
                                        "Share ODUID",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                      onPressed: () async {
                                        WcFlutterShare.share(
                                            sharePopupTitle: 'OD Detail',
                                            subject: 'OD UID Info',
                                            text: '*OD Details*\n\n*Name Of Event*:-' +
                                                xeventName +
                                                '\n*OD Limit*:-' +
                                                xODTimeLimit +
                                                '\n\nYour ODUID Number Is\n\n*' +
                                                xodUID +
                                                '*\n\nUse ODUID Number To Track Your Verification Status On App' +
                                                '\n\n\nODIFY \n(Developed & Designed By Agrim Lab)',
                                            mimeType: 'text/plain');
                                      },
                                      width: 120,
                                    )
                                  ],
                                ).show();
                                //Showing Success Result

                                //Clearning Text Field Controller
                                setState(() {
                                  //All Controller Clear
                                  allControllerClear();
                                  //End Of All Controller Clear
                                  //Clearing Student Clear
                                  dataClear();
                                  // End Of Student Clear Data
                                });
                              } else {
                                Alert(
                                  closeFunction: () {},
                                  context: context,
                                  type: AlertType.error,
                                  title: "No / Improper Data",
                                  desc: "Please Provide Correct Data",
                                  buttons: [
                                    DialogButton(
                                      child: Text(
                                        "Ok",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                      onPressed: () => Navigator.pop(context),
                                      width: 120,
                                    )
                                  ],
                                ).show();
                              }
                            })
                      ],
                    ),
                    SizedBox(
                      height: 18,
                    ),

                    Row(
                      children: <Widget>[
                        Container(
                            padding: EdgeInsets.all(15.0),
                            child: Text(
                              'List Of Student(s)',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800),
                            )),
                        Spacer(),
                        Container(
                            padding: EdgeInsets.all(15.0),
                            child: Text(
                              'Scroll To View',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w300),
                            )),
                      ],
                    ),

                    qStudName.length <= 0
                        ? SizedBox(
                            height: 18,
                          )
                        : Container(
                            height: 250.0,
                            child: new ListView.builder(
                                itemCount:
                                    qStudName.length > 0 ? qStudName.length : 0,
                                itemBuilder: (BuildContext ctxt, int index) {
                                  return Container(
                                      padding: EdgeInsets.only(
                                          left: 15, right: 15, top: 5),
                                      child: Column(children: <Widget>[
                                        ExpansionTileCard(
                                          leading: CircleAvatar(
                                              child:
                                                  Text((index + 1).toString())),
                                          title: Text(qStudName[index]),
                                          subtitle: Text(qRegNumber[index]),
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
                                                  child: SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Align(
                                                          alignment:
                                                              Alignment.topLeft,
                                                          child: Text(
                                                            "Department - " +
                                                                qDepartment[
                                                                    index],
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ),
                                                        Align(
                                                          alignment:
                                                              Alignment.topLeft,
                                                          child: Text(
                                                              "Year/Section - " +
                                                                  qYearSection[
                                                                      index],
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500)),
                                                        ),
                                                      ],
                                                    ),
                                                  )),
                                            ),
                                          ],
                                        ),
                                      ]));
                                }),
                          )
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
