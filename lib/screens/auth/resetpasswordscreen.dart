import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:myapp/screens/model/profile.dart';

class RSPScreen extends StatefulWidget {
  const RSPScreen({Key? key}) : super(key: key);

  @override
  _RSPScreenState createState() => _RSPScreenState();
}

class _RSPScreenState extends State<RSPScreen> {
  final formKey = GlobalKey<FormState>();
  Profile profile = Profile(
    email: '',
    password: '',
    confirmPassword: '',
  );
  Widget TextForm(String title) {
    return Text(title,
        style: const TextStyle(
            fontSize: 15,
            color: Color(0xffabd8ed),
            fontWeight: FontWeight.bold));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "ลืมรหัสผ่าน",
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
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextForm("Email"),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                    child: TextFormField(
                        cursorColor: Color(0xffabd8ed),
                        validator: MultiValidator([
                          RequiredValidator(
                              errorText: "Please insert the email."),
                          EmailValidator(
                              errorText: "Invalid email type please try again.")
                        ]),
                        onChanged: (String? email) {
                          profile.email = email!;
                        },
                        onSaved: (String? email) {
                          profile.email = email!;
                        },
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(color: Color(0xffabd8ed)),
                        decoration: InputDecoration(
                            labelText: 'Enter E-mail',
                            hintText: 'Example@gmail.com',
                            labelStyle: TextStyle(color: Color(0xffabd8ed)),
                            hintStyle: TextStyle(color: Color(0xffd2dfe5)),
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
                    margin: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                    child: SizedBox(
                      height: 50,
                      width: 100,
                      child: ElevatedButton(
                        child: const Text("Send",
                            style: TextStyle(
                                fontSize: 20, color: Color(0xff292a2a))),
                        onPressed: () async {
                          await FirebaseAuth.instance
                              .sendPasswordResetEmail(email: profile.email);
                          Fluttertoast.showToast(
                            msg: "Mail has been sent",
                            gravity: ToastGravity.CENTER,
                          );
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Color(0xffabd8ed),
                            onPrimary: Colors.blue,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: const BorderSide(
                                    color: Color(0xffabd8ed)))),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
