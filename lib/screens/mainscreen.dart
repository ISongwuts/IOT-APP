import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/screens/auth/loginscreen.dart';
import 'package:myapp/screens/controller/ledscreen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final auth = FirebaseAuth.instance;
  Widget HorizontalBox(Widget Screen) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
          context,
          PageRouteBuilder(
              transitionDuration: Duration(milliseconds: 500),
              transitionsBuilder: (context, animation, animationTime, child) {
                animation = CurvedAnimation(
                    parent: animation, curve: Curves.linearToEaseOut);
                return ScaleTransition(
                    alignment: Alignment.center,
                    scale: animation,
                    child: child);
              },
              pageBuilder: (context, animation, animationTime) {
                return Screen;
              }));
    },

    child: Container(
      margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
      height: 85,
      width: 130.0,
      decoration: BoxDecoration(
          /*gradient: const LinearGradient(colors: [
            Color(0xffabd8ed),
          ]),*/
          color: Color(0xffabd8ed),
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: Color(0xffabd8ed), width: 0)),
    ),
  );
}
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Container(
          color: const Color(0xff131818),
          child: ListView(
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  margin: EdgeInsets.all(13.5),
                  width: double.infinity,
                  color: const Color(0xff131818),
                  child: const Text("MENU",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 21.5,
                        fontWeight: FontWeight.bold,
                      )),
                ),
              ),
              Container(
                child: const DrawerHeader(
                    child: CircleAvatar(
                  backgroundImage: AssetImage(
                    "images/Unknown.png",
                  ),
                )),
                color: const Color(0xff131818),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  margin: EdgeInsets.all(13.5),
                  width: double.infinity,
                  color: const Color(0xff131818),
                  child: Text("${auth.currentUser!.email}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: const Color(0xffabd8ed),
                        fontSize: 21.5,
                        fontWeight: FontWeight.bold,
                      )),
                ),
              ),
              DividerBetween("Features"),
              Column(
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                      width: double.infinity,
                      height: 50,
                      color: const Color(0xff131818),
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Profile Setting",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[200]),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0, 2, 0, 0),
                      width: double.infinity,
                      height: 50,
                      color: const Color(0xff131818),
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "ABOUT",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[200]),
                        ),
                      ),
                    ),
                  ),
                  const Divider(
                    height: 35,
                    thickness: 0,
                    color: Color(0xffd0d0d0),
                    endIndent: 5,
                    indent: 5,
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    width: 150,
                    height: 50,
                    child: SizedBox(
                      child: ElevatedButton(
                        onPressed: () {
                          auth.signOut().then((value) => {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                      transitionDuration:
                                          Duration(milliseconds: 500),
                                      transitionsBuilder: (context, animation,
                                          animationTime, child) {
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
                                )
                              });
                        },
                        child: Text(
                          "LOGOUT",
                          style: TextStyle(
                              color: const Color(0xff131818),
                              fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                            primary: const Color(0xffabd8ed),
                            onPrimary: Colors.blue,
                            shadowColor: Colors.black,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: const BorderSide(
                                    color: const Color(0xffabd8ed)))),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Text("DASHBOARD"),
          ],
        ),
      ),
      backgroundColor: const Color(0xff131818),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 20, 15, 15),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        child: Container(
                      decoration: BoxDecoration(
                          color: Color(0xffabd8ed),
                          borderRadius: BorderRadius.circular(10.0),
                          border:
                              Border.all(color: Color(0xffabd8ed), width: 0)),
                      width: double.infinity,
                      height: 200,
                    )),
                  ],
                ),
                DividerBetween("Widget For Controller"),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      HorizontalBox(LedScreen()),
                    ],
                  ),
                ),
                Divider(
                  height: 35,
                  thickness: 0,
                  color: Color(0xffd0d0d0),
                  indent: 5,
                  endIndent: 5,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



Widget DividerBetween(String title) {
  return Row(children: [
    Expanded(
        child: Divider(
      height: 35,
      thickness: 0,
      color: Color(0xffd0d0d0),
      endIndent: 5,
      indent: 5,
    )),
    Text(
      title,
      style: TextStyle(
        color: Color(0xffd0d0d0),
        fontSize: 10,
      ),
    ),
    Expanded(
        child: Divider(
      height: 35,
      thickness: 0,
      color: Color(0xffd0d0d0),
      indent: 5,
      endIndent: 5,
    )),
  ]);
}