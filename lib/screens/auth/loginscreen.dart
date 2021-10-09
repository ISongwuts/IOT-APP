import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:myapp/screens/mainscreen.dart';
import 'package:myapp/screens/model/profile.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool firebaseErr = false;
  final formKey = GlobalKey<FormState>();
  LoginCheck auth = LoginCheck();
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
            fontSize: 15, color: Colors.pink, fontWeight: FontWeight.bold));
  }

  final Future<FirebaseApp> firebase = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
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
                centerTitle: true,
                title: const Text(
                  "เข้าสู่ระบบ",
                  style: TextStyle(
                    color: Colors.pink,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                iconTheme: const IconThemeData(
                  color: Colors.pink,
                ),
                backgroundColor: Colors.white,
                elevation: 1,
              ),
              body: Container(
                child: Padding(
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
                              child: const Text("IOTFSH",
                                  style: TextStyle(
                                      fontSize: 50,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.pink)),
                            ),
                            Container(
                              alignment: Alignment.topCenter,
                              margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                              child: RichText(
                                  text: const TextSpan(
                                      text: "INTERNET OF THINGS FOR ",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                      children: [
                                    TextSpan(
                                        text: "SMART HOME",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.pink)),
                                  ])),
                            ),
                            TextForm("Email"),
                            Container(
                              margin: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                              child: TextFormField(
                                  validator: MultiValidator([
                                    RequiredValidator(
                                        errorText: "Please insert the email."),
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
                                  decoration: InputDecoration(
                                      labelText: 'Enter E-mail',
                                      hintText: 'Example@gmail.com',
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            width: 1, color: Colors.pink),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            width: 3, color: Colors.pink),
                                        borderRadius: BorderRadius.circular(15),
                                      ))),
                            ),
                            TextForm("Password"),
                            Container(
                              margin: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                              child: TextFormField(
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
                                        color: Colors.pink,
                                        icon: passIsHide
                                            ? const Icon(Icons.visibility_off)
                                            : const Icon(Icons.visibility),
                                        onPressed: visibilityHandler,
                                      ),
                                      labelText: 'Enter Password',
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            width: 1, color: Colors.pink),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            width: 3, color: Colors.pink),
                                        borderRadius: BorderRadius.circular(15),
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
                                      style: TextStyle(fontSize: 20)),
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
                                                  formKey.currentState!.reset(),
                                                  auth.hasLogin = true,
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
                                                            animation =
                                                                CurvedAnimation(
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
                                                            return const MainScreen();
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
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                          side: const BorderSide(
                                              color: Colors.red))),
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              child: RichText(
                                  text: TextSpan(children: [
                                const TextSpan(
                                  text: "ลืมรหัสผ่านใช่หรือไม่ ",
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text: "กดที่นี่",
                                  style: const TextStyle(
                                    color: Colors.pink,
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
                                              return const LoginScreen();
                                            }),
                                      );
                                    },
                                ),
                              ])),
                            ),
                            const Divider(
                              height: 35,
                              thickness: 1,
                              color: Colors.pink,
                              endIndent: 5,
                            ),
                          ]),
                    ),
                  ),
                ),
              ),
            );
          }
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        });
  }
}
