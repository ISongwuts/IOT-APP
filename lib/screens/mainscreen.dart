import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/screens/auth/loginscreen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Container(
          color: Colors.pink,
          child: ListView(
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  margin: EdgeInsets.all(13.5),
                  width: double.infinity,
                  color: Colors.pink,
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
                color: Colors.pink,
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  margin: EdgeInsets.all(13.5),
                  width: double.infinity,
                  color: Colors.pink,
                  child: Text("${auth.currentUser!.email}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 21.5,
                        fontWeight: FontWeight.bold,
                      )),
                ),
              ),
              Row(children: [
                Expanded(
                    child: Divider(
                  height: 35,
                  thickness: 1,
                  color: Colors.grey[300],
                  endIndent: 5,
                  indent: 5,
                )),
                Text(
                  "Features",
                  style: TextStyle(
                    color: Colors.grey[300],
                  ),
                ),
                Expanded(
                    child: Divider(
                  height: 35,
                  thickness: 1,
                  color: Colors.grey[300],
                  indent: 5,
                  endIndent: 5,
                )),
              ]),
              Column(
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                      width: double.infinity,
                      height: 50,
                      color: Colors.pink[600],
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
                      color: Colors.pink[600],
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
                  Divider(
                    height: 35,
                    thickness: 1,
                    color: Colors.grey[300],
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
                              color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            onPrimary: Colors.red,
                            shadowColor: Colors.black,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: const BorderSide(color: Colors.white))),
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
        centerTitle: true,
        elevation: 1,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Text("DASHBOARD"),
          ],
        ),
      ),
      backgroundColor: const Color(0xffbc2256),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: [
              Row(
                children: [
                  Expanded(
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.pink,
                              borderRadius: BorderRadius.circular(20.0),
                              border: Border.all(color: Colors.pink, width: 1)),
                          width: double.infinity,
                          height: 200,
                          child: Expanded(
                            child: Column(
                              children: [],
                            ),
                          ))),
                  
                ],
              ),Row(
                children: [
                  Expanded(
                          child: Container(
                              margin: EdgeInsets.fromLTRB(0, 15, 7.5, 5),
                              decoration: BoxDecoration(
                                  color: Colors.pink,
                                  borderRadius: BorderRadius.circular(20.0),
                                  border: Border.all(color: Colors.pink, width: 1)),
                              width: double.infinity,
                              height: 100,
                              child: Expanded(
                                child: Column(
                                  children: [],
                                ),
                              ))),
                  Expanded(
                          child: Container(
                              margin: EdgeInsets.fromLTRB(7.5, 15, 0, 5),
                              decoration: BoxDecoration(
                                  color: Colors.pink,
                                  borderRadius: BorderRadius.circular(20.0),
                                  border: Border.all(color: Colors.pink, width: 1)),
                              width: double.infinity,
                              height: 100,
                              child: Expanded(
                                child: Column(
                                  children: [],
                                ),
                              ))),
                ],
              ),
              Row(
                children: [
                  Expanded(
                          child: Container(
                              margin: EdgeInsets.fromLTRB(0, 5, 7.5, 15),
                              decoration: BoxDecoration(
                                  color: Colors.pink,
                                  borderRadius: BorderRadius.circular(20.0),
                                  border: Border.all(color: Colors.pink, width: 1)),
                              width: double.infinity,
                              height: 100,
                              child: Expanded(
                                child: Column(
                                  children: [],
                                ),
                              ))),
                  Expanded(
                          child: Container(
                              margin: EdgeInsets.fromLTRB(7.5, 5, 0, 15),
                              decoration: BoxDecoration(
                                  color: Colors.pink,
                                  borderRadius: BorderRadius.circular(20.0),
                                  border: Border.all(color: Colors.pink, width: 1)),
                              width: double.infinity,
                              height: 100,
                              child: Expanded(
                                child: Column(
                                  children: [],
                                ),
                              ))),
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.pink,
                              borderRadius: BorderRadius.circular(20.0),
                              border: Border.all(color: Colors.pink, width: 1)),
                          width: double.infinity,
                          height: 200,
                          child: Expanded(
                            child: Column(
                              children: [],
                            ),
                          ))),
                  
                ],
              ),
        
            ],
          ),
        ),
      ),
    );
  }
}
