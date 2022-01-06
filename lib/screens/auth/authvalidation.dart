import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/screens/auth/registerscreen.dart';
import 'package:myapp/screens/auth/verifyscreen.dart';
import 'package:myapp/screens/mainscreen.dart';

class AuthValidation extends StatefulWidget {
  const AuthValidation({Key? key}) : super(key: key);

  @override
  _AuthValidationState createState() => _AuthValidationState();
}

class _AuthValidationState extends State<AuthValidation> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            return VerifyScreen();
          } else if (snapshot.hasError) {
            return Center(
                child: Text("Error please try again",
                    style: TextStyle(color: Color(0xffeeeeee), fontSize: 18)));
          } else {
            return RegisterScreen();
          }
        });
  }
}
