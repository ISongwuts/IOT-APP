import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/screens/auth/verifyscreen.dart';
import 'package:myapp/screens/mainscreen.dart';
import 'package:myapp/screens/model/profile.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:connectivity/connectivity.dart';
import 'package:myapp/screens/introduction.dart';
import 'package:myapp/screens/noconnection.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool isConnected = false;
  late StreamSubscription sub;
  final dbRef = FirebaseDatabase.instance.reference();
  bool isLoading = false;
  
  void detectUser() async {
    FirebaseAuth _auth1 = await FirebaseAuth.instance;

    if (_auth1.currentUser != null) {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => VerifyScreen(),
        ),
      );
      setState(() {
        isLoading = true;
      });
    } 
  }

  @override
  void initState() {
    super.initState();
    detectUser();
    sub = Connectivity().onConnectivityChanged.listen((result) => {
          setState(() => {isConnected = (result != ConnectivityResult.none)}),
        });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 2,
      navigateAfterSeconds:
          isLoading ? CircularProgressIndicator : const OnBoardingPage(),
      image: Image.asset('images/logoTrans.png'),
      backgroundColor: const Color(0xff131818),
      styleTextUnderTheLoader: const TextStyle(color: Color(0xffabd8ed)),
      photoSize: 150,
      loaderColor: const Color(0xffabd8ed),
    );
  }
}
