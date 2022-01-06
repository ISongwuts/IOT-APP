import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myapp/screens/mainscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({Key? key}) : super(key: key);

  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final dbRef = FirebaseDatabase.instance.reference();
  final user = FirebaseAuth.instance.currentUser!;
  bool userFromGg = false;
  late String? token_id;
  late String? check_token_id;
  bool isLoading = true;
  bool isVerified = false;
  bool justTrue = false;

  Future<void> _requestPermission() async {
    var storageStatus = await Permission.storage.status;
    if (!storageStatus.isGranted) {
      await Permission.storage.request();
    }
  }

  saveData() async {
    SharedPreferences share_prefs = await SharedPreferences.getInstance();
    share_prefs.setBool('isVerified', true);
  }

  readData() async {
    SharedPreferences share_prefs = await SharedPreferences.getInstance();
    setState(() {
      isVerified = share_prefs.getBool('isVerified')!;
      checkUser();
    });
  }

  _getToken_id() async {
    try {
      await dbRef
          .child('user')
          .child('token_id')
          .once()
          .then((DataSnapshot snapshot) => {check_token_id = snapshot.value});
      setState(() {
        isLoading = false;
      });
    } on Exception catch (e) {
      print(e);
    }
  }

  void checkUser() async {
    if (user.photoURL! == null) {
      userFromGg = false;
    } else {
      userFromGg = true;
    }
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  @override
  void initState() {
    // TODO: implement initState
    readData();
    _getToken_id();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget TextForm(String title) {
      return Text(title,
          style: const TextStyle(
              fontSize: 15,
              color: Color(0xffabd8ed),
              fontWeight: FontWeight.bold));
    }

    return Center(
      child: isLoading
          ? CircularProgressIndicator()
          : isVerified
              ? MainScreen()
              : Scaffold(
                  appBar: AppBar(
                    title: Text("VERIFICATION"),
                    automaticallyImplyLeading: false,
                    backgroundColor: Colors.transparent,
                    centerTitle: true,
                    elevation: 0,
                  ),
                  backgroundColor: const Color(0xff131818),
                  body: RefreshIndicator(
                    color: const Color(0xffabd8ed),
                    backgroundColor: const Color(0xff181818),
                    onRefresh: () => _getToken_id(),
                    child: Center(
                      child: ListView(
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(15, 25, 15, 15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 25),
                                  child: Container(
                                    width: 125.0,
                                    height: 125.0,
                                    decoration: BoxDecoration(
                                      color: const Color(0xff7c94b6),
                                      image: DecorationImage(
                                        image: userFromGg ? NetworkImage(user.photoURL!) : AssetImage('images/Unknown.png') as ImageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(65.0)),
                                      border: Border.all(
                                        color: Color(0xffabd8ed),
                                        width: 4.0,
                                      ),
                                    ),
                                  ),
                                ),
                                TextForm("Please enter verification token"),
                                Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(0, 15, 0, 15),
                                  child: TextFormField(
                                      style: const TextStyle(
                                          color: Color(0xffabd8ed)),
                                      cursorColor: Color(0xff292a2a),
                                      onChanged: (String token) {
                                        setState(() {
                                          token_id = token;
                                          print(token_id);
                                        });
                                      },
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: InputDecoration(
                                          labelText: 'Enter Token',
                                          hintText: '',
                                          labelStyle: TextStyle(
                                              color: Color(0xffabd8ed)),
                                          hintStyle: TextStyle(
                                              color: Color(0xffabd8ed)),
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
                                  width: 150,
                                  height: 45,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: Color(0xffabd8ed),
                                      ),
                                      onPressed: () async {
                                        _requestPermission();
                                        if (token_id == check_token_id) {
                                          Fluttertoast.showToast(
                                            msg: "Token ถูกต้อง",
                                            gravity: ToastGravity.TOP,
                                          );
                                          Navigator.pushReplacement(
                                              context,
                                              PageRouteBuilder(
                                                  transitionDuration:
                                                      const Duration(
                                                          milliseconds: 500),
                                                  transitionsBuilder: (context,
                                                      animation,
                                                      animationTime,
                                                      child) {
                                                    animation = CurvedAnimation(
                                                        parent: animation,
                                                        curve: Curves
                                                            .linearToEaseOut);
                                                    return ScaleTransition(
                                                        alignment:
                                                            Alignment.center,
                                                        scale: animation,
                                                        child: child);
                                                  },
                                                  pageBuilder: (context,
                                                      animation,
                                                      animationTime) {
                                                    return const MainScreen();
                                                  }));
                                          await saveData();
                                        } else {
                                          Fluttertoast.showToast(
                                            msg:
                                                "Token ไม่ถูกต้องโปรดลองอีกครั้ง",
                                            gravity: ToastGravity.TOP,
                                          );
                                        }
                                      },
                                      child: Row(
                                        children: [
                                          Container(
                                              child: Icon(
                                            Icons.verified_user,
                                            color: Color(0xff181818),
                                          )),
                                          Container(
                                            margin:
                                                EdgeInsets.fromLTRB(5, 0, 0, 0),
                                            child: Text("VERIFY NOW",
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
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }
}
