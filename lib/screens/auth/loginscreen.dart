import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:myapp/screens/auth/authvalidation.dart';
import 'package:myapp/screens/auth/registerscreen.dart';
import 'package:myapp/screens/auth/resetpasswordscreen.dart';
import 'package:myapp/screens/auth/verifyscreen.dart';
import 'package:myapp/screens/mainscreen.dart';
import 'package:myapp/screens/model/profile.dart';
import 'package:provider/provider.dart';

import 'googleauth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool firebaseErr = false;
  final formKey = GlobalKey<FormState>();
  Profile profile = Profile(
    email: '',
    password: '',
    confirmPassword: '',
  );
  bool passIsHide = true;
  void visibilityHandler() {
    setState(() {
      passIsHide = !passIsHide;
    });
  }

  Widget TextForm(String title) {
    return Text(title,
        style: const TextStyle(
            fontSize: 15,
            color: Color(0xffabd8ed),
            fontWeight: FontWeight.bold));
  }

  final Future<FirebaseApp> firebase = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: FutureBuilder(
          future: firebase,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return AlertDialog(
                title: const Text("Error"),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: [
                      Text("${snapshot.error}"),
                    ],
                  ),
                ),
              );
            }
            if (snapshot.connectionState == ConnectionState.done) {
              return Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  centerTitle: true,
                  title: const Text(
                    "เข้าสู่ระบบ",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  iconTheme: const IconThemeData(
                    color: Colors.white,
                  ),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),
                backgroundColor: const Color(0xff131818),
                body: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 20, 15, 15),
                  child: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              alignment: Alignment.topCenter,
                              margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                              child: const Text("IoTFSH",
                                  style: TextStyle(
                                      fontSize: 50,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xffabd8ed))),
                            ),
                            Container(
                              alignment: Alignment.topCenter,
                              margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                              child: RichText(
                                  text: const TextSpan(
                                      text: "Internet of Things For ",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                      children: [
                                    TextSpan(
                                        text: "Smart Home",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xffabd8ed))),
                                  ])),
                            ),
                            TextForm("Email"),
                            Container(
                              margin: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                              child: TextFormField(
                                  cursorColor: Color(0xffabd8ed),
                                  validator: MultiValidator([
                                    RequiredValidator(
                                        errorText:
                                            "Please insert the email."),
                                    EmailValidator(
                                        errorText:
                                            "Invalid email type please try again.")
                                  ]),
                                  onChanged: (String? email) {
                                    profile.email = email!;
                                  },
                                  onSaved: (String? email) {
                                    profile.email = email!;
                                  },
                                  keyboardType: TextInputType.emailAddress,
                                  style: const TextStyle(
                                      color: Color(0xffabd8ed)),
                                  decoration: InputDecoration(
                                      labelText: 'Enter E-mail',
                                      hintText: 'Example@gmail.com',
                                      labelStyle:
                                          TextStyle(color: Color(0xffabd8ed)),
                                      hintStyle:
                                          TextStyle(color: Color(0xffd2dfe5)),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            width: 1,
                                            color: Color(0xffabd8ed)),
                                        borderRadius:
                                            BorderRadius.circular(15),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            width: 3,
                                            color: Color(0xffabd8ed)),
                                        borderRadius:
                                            BorderRadius.circular(15),
                                      ))),
                            ),
                            TextForm("Password"),
                            Container(
                              margin: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                              child: TextFormField(
                                  style: const TextStyle(
                                      color: Color(0xffabd8ed)),
                                  cursorColor: Color(0xffabd8ed),
                                  validator: MultiValidator([
                                    RequiredValidator(
                                        errorText:
                                            "Please insert the password."),
                                  ]),
                                  onChanged: (String? password) {
                                    profile.password = password!;
                                  },
                                  onSaved: (String? password) {
                                    profile.password = password!;
                                  },
                                  obscureText: passIsHide ? true : false,
                                  decoration: InputDecoration(
                                      suffixIcon: IconButton(
                                        color: Color(0xffabd8ed),
                                        icon: passIsHide
                                            ? const Icon(Icons.visibility_off)
                                            : const Icon(Icons.visibility),
                                        onPressed: visibilityHandler,
                                      ),
                                      labelText: 'Enter Password',
                                      labelStyle:
                                          TextStyle(color: Color(0xffabd8ed)),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            width: 1,
                                            color: Color(0xffabd8ed)),
                                        borderRadius:
                                            BorderRadius.circular(15),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            width: 3,
                                            color: Color(0xffabd8ed)),
                                        borderRadius:
                                            BorderRadius.circular(15),
                                      ))),
                            ),
                            Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                              child: SizedBox(
                                height: 50,
                                width: 100,
                                child: ElevatedButton(
                                  child: const Text("Login",
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Color(0xff292a2a))),
                                  onPressed: () async {
                                    if (formKey.currentState!.validate()) {
                                      try {
                                        await FirebaseAuth.instance
                                            .signInWithEmailAndPassword(
                                                email: profile.email,
                                                password: profile.password)
                                            .then((value) => {
                                                  Fluttertoast.showToast(
                                                    msg: "ลงทะเบียนเรียบร้อย",
                                                    gravity:
                                                        ToastGravity.CENTER,
                                                  ),
                                                  formKey.currentState!
                                                      .reset(),
                                                  Future.delayed(
                                                      const Duration(
                                                          seconds: 1),
                                                      () async {
                                                    await Navigator
                                                        .pushReplacement(
                                                      context,
                                                      PageRouteBuilder(
                                                          transitionDuration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      500),
                                                          transitionsBuilder:
                                                              (context,
                                                                  animation,
                                                                  animationTime,
                                                                  child) {
                                                            animation = CurvedAnimation(
                                                                parent:
                                                                    animation,
                                                                curve: Curves
                                                                    .linearToEaseOut);
                                                            return ScaleTransition(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                scale:
                                                                    animation,
                                                                child: child);
                                                          },
                                                          pageBuilder: (context,
                                                              animation,
                                                              animationTime) {
                                                            return const AuthValidation();
                                                          }),
                                                    );
                                                  })
                                                });
                                      } on FirebaseAuthException catch (e) {
                                        Fluttertoast.showToast(
                                          msg: e.message,
                                          gravity: ToastGravity.CENTER,
                                        );
                                        print(e.message);
                                        setState(() {
                                          firebaseErr = true;
                                        });
                                      }
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                      primary: Color(0xffabd8ed),
                                      onPrimary: Colors.blue,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                          side: const BorderSide(
                                              color: Color(0xffabd8ed)))),
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              child: RichText(
                                  text: TextSpan(children: [
                                const TextSpan(
                                  text: "ยังไม่ได้สมัครสมาชิกใช่หรือไม่ ",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                TextSpan(
                                  text: "กดที่นี่",
                                  style: const TextStyle(
                                    color: Color(0xffabd8ed),
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                            transitionDuration:
                                                Duration(milliseconds: 500),
                                            transitionsBuilder: (context,
                                                animation,
                                                animationTime,
                                                child) {
                                              animation = CurvedAnimation(
                                                  parent: animation,
                                                  curve:
                                                      Curves.linearToEaseOut);
                                              return ScaleTransition(
                                                  alignment: Alignment.center,
                                                  scale: animation,
                                                  child: child);
                                            },
                                            pageBuilder: (context, animation,
                                                animationTime) {
                                              return const RegisterScreen();
                                            }),
                                      );
                                    },
                                ),
                              ])),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                              alignment: Alignment.center,
                              child: RichText(
                                text: TextSpan(
                                  text: "ลืมรหัสผ่าน?",
                                  style: const TextStyle(
                                    color: Color(0xffabd8ed),
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                            transitionDuration:
                                                Duration(milliseconds: 500),
                                            transitionsBuilder: (context,
                                                animation,
                                                animationTime,
                                                child) {
                                              animation = CurvedAnimation(
                                                  parent: animation,
                                                  curve:
                                                      Curves.linearToEaseOut);
                                              return ScaleTransition(
                                                  alignment: Alignment.center,
                                                  scale: animation,
                                                  child: child);
                                            },
                                            pageBuilder: (context, animation,
                                                animationTime) {
                                              return const RSPScreen();
                                            }),
                                      );
                                    },
                                ),
                              ),
                            ),
                            Row(children: const [
                              Expanded(
                                  child: Divider(
                                height: 35,
                                thickness: 1,
                                color: Color(0xffd0d0d0),
                                endIndent: 5,
                              )),
                              Text(
                                "หรือ",
                                style: TextStyle(
                                  color: Color(0xffd0d0d0),
                                ),
                              ),
                              Expanded(
                                  child: Divider(
                                height: 35,
                                thickness: 1,
                                color: Color(0xffd0d0d0),
                                indent: 5,
                              )),
                            ]),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  MaterialButton(
                                    onPressed: () async {
                                      final _provider =
                                          Provider.of<GoogleSignInProvider>(
                                              context,
                                              listen: false);
                                      await _provider.googleLogin();
                                      await Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                            transitionDuration:
                                                Duration(milliseconds: 500),
                                            transitionsBuilder: (context,
                                                animation,
                                                animationTime,
                                                child) {
                                              animation = CurvedAnimation(
                                                  parent: animation,
                                                  curve:
                                                      Curves.linearToEaseOut);
                                              return ScaleTransition(
                                                  alignment: Alignment.center,
                                                  scale: animation,
                                                  child: child);
                                            },
                                            pageBuilder: (context, animation,
                                                animationTime) {
                                              return const AuthValidation();
                                            }),
                                      );
                                    },
                                    color: Color(0xffffffff),
                                    textColor: Colors.white,
                                    child: FaIcon(
                                      FontAwesomeIcons.google,
                                      size: 24,
                                      color: Color(0xff181818),
                                    ),
                                    padding: EdgeInsets.all(16),
                                    shape: CircleBorder(),
                                  ),
                                ],
                              ),
                            )
                          ]),
                    ),
                  ),
                ),
              );
            }
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }),
    );
  }
}
