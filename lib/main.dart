import 'package:flutter/material.dart';
import 'package:srmob/screens/LoginScreen.dart';
import 'screens/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  runApp(SRMOB());
}

class SRMOB extends StatefulWidget {
  @override
  _SRMOBState createState() => _SRMOBState();
}

class _SRMOBState extends State<SRMOB> {
  final _auth = FirebaseAuth.instance;
  bool isLogin = false;
  @override
  void initState() {
    checkLogin();
    super.initState();
  }

  void checkLogin() async {
    await getUser();
  }

  Future<void> getUser() async {
    final v = await _auth.currentUser();
    if (v != null) {
      setState(() {
        isLogin = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SRM ODIFY',
      home: isLogin ? LoginScreen() : Welcome(),
    );
  }
}
