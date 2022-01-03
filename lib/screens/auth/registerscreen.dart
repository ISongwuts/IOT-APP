import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:myapp/screens/auth/loginscreen.dart';
import 'package:myapp/screens/auth/verifyscreen.dart';
import 'package:myapp/screens/mainscreen.dart';
import 'package:myapp/screens/model/profile.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String firebaseErrMsg = "";
  bool passIsHide = true;
  bool passIsTheSame = true;
  bool firebaseErr = false;
  Profile profile = Profile(
    email: '',
    password: '',
    confirmPassword: '',
  );

  final formKey = GlobalKey<FormState>();

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
                  "ลงทะเบียน",
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
              body: Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
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
                                style:
                                    const TextStyle(color: Color(0xffabd8ed)),
                                cursorColor: Color(0xff292a2a),
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
                                    labelStyle:
                                        TextStyle(color: Color(0xffabd8ed)),
                                    hintStyle:
                                        TextStyle(color: Color(0xffabd8ed)),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          width: 1, color: Color(0xffabd8ed)),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          width: 3, color: Color(0xffabd8ed)),
                                      borderRadius: BorderRadius.circular(15),
                                    ))),
                          ),
                          TextForm("Password"),
                          Container(
                            margin: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                            child: TextFormField(
                                style:
                                    const TextStyle(color: Color(0xffabd8ed)),
                                cursorColor: Color(0xff292a2a),
                                validator: MultiValidator([
                                  RequiredValidator(
                                      errorText: "Please insert the password."),
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
                                          width: 1, color: Color(0xffabd8ed)),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          width: 3, color: Color(0xffabd8ed)),
                                      borderRadius: BorderRadius.circular(15),
                                    ))),
                          ),
                          TextForm("Confirm Password"),
                          Container(
                            margin: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                            child: TextFormField(
                                style:
                                    const TextStyle(color: Color(0xffabd8ed)),
                                cursorColor: Color(0xff292a2a),
                                validator: MultiValidator([
                                  RequiredValidator(
                                      errorText: "Please insert the password."),
                                ]),
                                onChanged: (String? confirmpassword) {
                                  profile.confirmPassword = confirmpassword!;
                                },
                                onSaved: (String? confirmpassword) {
                                  profile.confirmPassword = confirmpassword!;
                                },
                                obscureText: passIsHide ? true : false,
                                decoration: InputDecoration(
                                    labelStyle:
                                        TextStyle(color: Color(0xffabd8ed)),
                                    labelText: 'Confirm Password',
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          width: 1, color: Color(0xffabd8ed)),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          width: 3, color: Color(0xffabd8ed)),
                                      borderRadius: BorderRadius.circular(15),
                                    ))),
                          ),
                          Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                            child: SizedBox(
                              height: 50,
                              width: 150,
                              child: ElevatedButton(
                                child: const Text("Register",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Color(0xff292a2a))),
                                onPressed: () async {
                                  print(
                                      "pass = ${profile.password} | conPass = ${profile.confirmPassword}");
                                  if (formKey.currentState!.validate() &&
                                      profile.password.toString() ==
                                          profile.confirmPassword.toString()) {
                                    formKey.currentState!.save();
                                    passIsTheSame = true;
                                    try {
                                      await FirebaseAuth.instance
                                          .createUserWithEmailAndPassword(
                                              email: profile.email,
                                              password: profile.password)
                                          .then((value) => {
                                                Fluttertoast.showToast(
                                                  msg: "ลงทะเบียนเสร็จสิ้น",
                                                  gravity: ToastGravity.TOP,
                                                ),
                                                formKey.currentState!.reset(),
                                                firebaseErr = false,
                                                Future.delayed(
                                                    const Duration(seconds: 1),
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
                                                              scale: animation,
                                                              child: child);
                                                        },
                                                        pageBuilder: (context,
                                                            animation,
                                                            animationTime) {
                                                          return const VerifyScreen();
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
                                        firebaseErrMsg = e.message!;
                                        firebaseErr = true;
                                      });
                                    }
                                  } else {
                                    setState(() {
                                      passIsTheSame = false;
                                    });
                                  }
                                  passIsTheSame
                                      ? null
                                      : Fluttertoast.showToast(
                                          msg: "Password is not the same",
                                          gravity: ToastGravity.CENTER,
                                        );
                                },
                                style: ElevatedButton.styleFrom(
                                    primary: Color(0xffabd8ed),
                                    onPrimary: Color(0xffabd8ed),
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
                                text: "หากมีบัญชีอยู่แล้ว ",
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
                                              animation, animationTime, child) {
                                            animation = CurvedAnimation(
                                                parent: animation,
                                                curve: Curves.linearToEaseOut);
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
                        ],
                      ),
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
