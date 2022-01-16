import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:myapp/screens/auth/googleauth.dart';
import 'package:myapp/screens/auth/loginscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wiredash/wiredash.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final dbRef = FirebaseDatabase.instance.reference();
  final auth = FirebaseAuth.instance;
  late bool? langIsSwap = true;
  GoogleSignInProvider gp = new GoogleSignInProvider();
  swapLang(bool state) async {
    SharedPreferences share_prefs = await SharedPreferences.getInstance();
    share_prefs.setBool('langIsSwapped', state);
    langIsSwap = !langIsSwap!;
    print(state);
  }

  saveData() async {
    SharedPreferences share_prefs = await SharedPreferences.getInstance();
    share_prefs.setBool('isVerified', false);
    share_prefs.setBool('isKnowTutorial', false);
    share_prefs.setBool('isKnowTutorial-led', false);
    share_prefs.setBool('isKnowTutorial-speech', false);
    share_prefs.setBool('isKnowTutorial-curtain', false);
  }

  @override
  Widget build(BuildContext context) {
    final _navigatorKey = GlobalKey<NavigatorState>();
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Container(
        width: double.infinity,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
              width: 150,
              height: 50,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xffabd8ed),
                  ),
                  onPressed: () => {
                        Wiredash.of(context)!.setUserProperties(
                            userEmail: "ISongwut.me@gmail.com"),
                        Wiredash.of(context)!.show()
                      },
                  child: Row(
                    children: [
                      Container(
                          child: const Icon(
                        Icons.report,
                        color: Color(0xff181818),
                      )),
                      Container(
                        margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
                        child: const Text("รายงานปัญหา",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xff181818))),
                      )
                    ],
                  )),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
              width: 120,
              height: 50,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xffabd8ed),
                  ),
                  onPressed: () async {
                    await saveData();
                    gp.logout();
                    auth.signOut().then((value) => {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                                transitionDuration: Duration(milliseconds: 500),
                                transitionsBuilder:
                                    (context, animation, animationTime, child) {
                                  animation = CurvedAnimation(
                                      parent: animation,
                                      curve: Curves.linearToEaseOut);
                                  return ScaleTransition(
                                      alignment: Alignment.center,
                                      scale: animation,
                                      child: child);
                                },
                                pageBuilder:
                                    (context, animation, animationTime) {
                                  return const LoginScreen();
                                }),
                          ),
                        });
                  },
                  child: Row(
                    children: [
                      Container(
                          child: const Icon(
                        Icons.logout,
                        color: Color(0xff181818),
                      )),
                      Container(
                        margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
                        child: const Text("LOGOUT",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xff181818))),
                      )
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
