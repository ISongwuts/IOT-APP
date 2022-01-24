import 'dart:io';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/screens/controller/curtainscreen.dart';
import 'package:myapp/screens/controller/ledscreen.dart';
import 'package:myapp/screens/controller/speechscreen.dart';
import 'package:myapp/screens/pages/covidreport.dart';
import 'package:myapp/screens/pages/profilepage.dart';
import 'package:myapp/screens/pages/settingpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:carousel_slider/carousel_slider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late TutorialCoachMark tutorialCoachMark;
  List<TargetFocus> targets = <TargetFocus>[];

  GlobalKey keyButton = GlobalKey();
  GlobalKey keyButton1 = GlobalKey();
  GlobalKey keyButton2 = GlobalKey();
  GlobalKey keyButton3 = GlobalKey();
  GlobalKey keyButton4 = GlobalKey();

  final _navigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  var childPath = [
    ["light_bedroom", "light_state", "light_rgb_color"],
    ["light_livingroom", "light_state", "light_rgb_color"],
    ["light_bathroom", "light_state", "light_rgb_color"],
    ["light_kitchen", "light_state", "light_rgb_color"],
    ["light_rooftop", "light_state", "light_rgb_color"],
  ];
  var curtain_childPath = [
    ["front_curtain", "curtain_state"],
    ["side_curtain", "curtain_state"]
  ];
  late var ledState_arr = List<int>.filled(5, 0, growable: false);
  late var currentColor_arr = List<String>.filled(5, "", growable: false);
  late var curtainstate_arr = List<String>.filled(3, "", growable: false);
  final dbRef = FirebaseDatabase.instance.reference();
  final auth = FirebaseAuth.instance;
  final user = FirebaseAuth.instance.currentUser!;
  final sliderImages = [
    'images/Slider/1.png',
    'images/Slider/2.png',
    'images/Slider/3.png'
  ];

  bool userFromGg = false;
  int index = 0;
  int previousPage = 0;
  bool isSlide = false;
  bool isLoading = false;
  bool isKnowTutorial = false;

  saveData() async {
    SharedPreferences share_prefs = await SharedPreferences.getInstance();
    share_prefs.setBool('isKnowTutorial', true);
  }

  readData() async {
    SharedPreferences share_prefs = await SharedPreferences.getInstance();
    setState(() {
      isKnowTutorial = share_prefs.getBool('isKnowTutorial')!;
    });
    print(isKnowTutorial);
  }

  void checkUser() async {
    if (user.photoURL! == null) {
      userFromGg = false;
    } else {
      userFromGg = true;
    }
  }

  final BottomBarItems = <Widget>[
    const Icon(Icons.dashboard, size: 30),
    const Icon(Icons.new_releases, size: 30),
    const Icon(Icons.contact_support, size: 30),
    const Icon(Icons.settings, size: 30),
  ];

  Future<void> _requestPermission() async {
    var micStatus = await Permission.storage.status;
    if (!micStatus.isGranted) {
      await Permission.microphone.request();
    }
  }

  Future _getStatus() async {
    readData();
    checkUser();
    for (int index_of_stLoop = 0;
        index_of_stLoop < childPath.length;
        index_of_stLoop++) {
      await dbRef
          .child("Gadget")
          .child("Light")
          .child(childPath[index_of_stLoop][0])
          .child(childPath[index_of_stLoop][1])
          .once()
          .then((DataSnapshot snapshot) =>
              ledState_arr[index_of_stLoop] = snapshot.value);
      await dbRef
          .child("Gadget")
          .child("Light")
          .child(childPath[index_of_stLoop][0])
          .child(childPath[index_of_stLoop][2])
          .once()
          .then((DataSnapshot snapshot) => {
                setState(() {
                  currentColor_arr[index_of_stLoop] = snapshot.value;
                })
              });
    }
    for (int index = 0; index < curtain_childPath.length; index++) {
      await dbRef
          .child("Gadget")
          .child("Curtain")
          .child(curtain_childPath[index][0])
          .child(curtain_childPath[index][1])
          .once()
          .then((DataSnapshot snapshot) => {
                setState(() {
                  curtainstate_arr[index] = snapshot.value;
                })
              });
    }
    setState(() {
      isLoading = false;
    });
  }

  final title = <Widget>[
    const Text("DASHBOARD"),
    Text("COVID 19"),
    Text("ABOUT"),
    Text("LOGOUT"),
  ];

  final pages = <Widget>[
    MainScreen(),
    CovidReport(),
    ProfilePage(),
    SettingPage(),
  ];

  void initTarget() async {
    targets
        .add(TargetFocus(identify: "Target 1", keyTarget: keyButton, contents: [
      TargetContent(
          child: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text("ฟังก์ชันควบคุมหลอดไฟ",
                      style: TextStyle(
                          color: Color(0xffabd8ed),
                          fontSize: 25,
                          fontWeight: FontWeight.bold)),
                  Text(
                      "ผู้ใชังานสามารถเปิด - ปิดหลอดไฟได้ด้วยการกดเข้าไปในฟังก์ชันนี้",
                      style: TextStyle(
                        color: Color(0xffeeeeee),
                        fontSize: 15,
                      ))
                ],
              ),
            ),
          ],
        ),
      ))
    ]));
    targets.add(
        TargetFocus(identify: "Target 2", keyTarget: keyButton2, contents: [
      TargetContent(
          child: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text("ฟังก์ชันควบคุมผ้าม่าน",
                      style: TextStyle(
                          color: Color(0xffabd8ed),
                          fontSize: 25,
                          fontWeight: FontWeight.bold)),
                  Text(
                      "ผู้ใชังานสามารถเปิด - ปิดผ้าม่านได้ด้วยการกดเข้าไปในฟังก์ชันนี้",
                      style: TextStyle(
                        color: Color(0xffeeeeee),
                        fontSize: 15,
                      ))
                ],
              ),
            ),
          ],
        ),
      ))
    ]));
    targets.add(
        TargetFocus(identify: "Target 3", keyTarget: keyButton3, contents: [
      TargetContent(
          child: Container(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text("ฟังก์ชันควบคุมอุปกรณ์ผ่านเสียง",
                      style: TextStyle(
                          color: Color(0xffabd8ed),
                          fontSize: 25,
                          fontWeight: FontWeight.bold)),
                  Text(
                      "ผู้ใชังานสามารถเปิด - ปิดหลอดไฟและผ้าม่านผ่านเสียงได้ด้วยการกดเข้าไปในฟังก์ชันนี้",
                      style: TextStyle(
                        color: Color(0xffeeeeee),
                        fontSize: 15,
                      ))
                ],
              ),
            ),
          ],
        ),
      ))
    ]));
    targets.add(TargetFocus(
        identify: "Target 4",
        keyTarget: keyButton4,
        contents: [
          TargetContent(
              align: ContentAlign.top,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Text("ฟังก์ชันแสดงสถานะของอุปกรณ์",
                              style: TextStyle(
                                  color: Color(0xffabd8ed),
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold)),
                          Text(
                              "ผู้ใชังานสามารถดูสถานะของอุปกรณ์ได้ว่าปิดอยู่หรือเปิดอยู่หรือไม่",
                              style: TextStyle(
                                color: Color(0xffeeeeee),
                                fontSize: 15,
                              ))
                        ],
                      ),
                    ),
                  ],
                ),
              ))
        ],
        alignSkip: Alignment.topRight));
  }

  void showTutorial() async {
    saveData();
    if (isKnowTutorial == true) {
      print("yes");
    } else {
      tutorialCoachMark = TutorialCoachMark(context,
          targets: targets, colorShadow: Color(0xff131818), opacityShadow: 1)
        ..show();
      print("end");
    }
  }

  @override
  void initState() {
    _getStatus();
    initTarget();
    Future.delayed(Duration(seconds: 2), showTutorial);
    super.initState();
  }

  Widget HorizontalBox(
      Widget Screen, Icon icon, String title, double TextSize, GlobalKey key) {
    return GestureDetector(
      key: key,
      onTap: () {
        _requestPermission();
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
        margin: EdgeInsets.fromLTRB(0, 0, 10, 5),
        height: 85,
        width: 130.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(child: icon),
            Container(
              child: Text(title,
                  style: TextStyle(
                    fontSize: TextSize,
                    fontWeight: FontWeight.bold,
                  )),
            )
          ],
        ),
        decoration: BoxDecoration(
            color: Color(0xffabd8ed),
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: Color(0xffabd8ed), width: 0)),
      ),
    );
  }

  Widget ShowStatus_light(String title, int index) {
    return Column(
      children: [
        Row(
          children: [
            Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                child:
                    Text(title, style: TextStyle(fontWeight: FontWeight.bold))),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                margin: EdgeInsets.fromLTRB(20, 0, 10, 5),
                child: Text(" - Light Status", style: TextStyle(fontSize: 13))),
            const Expanded(
                child: Divider(
              height: 10,
              thickness: 1,
              color: Color(0xffd0d0d0),
            )),
            Container(
                margin: EdgeInsets.fromLTRB(20, 0, 10, 5),
                child: Text(ledState_arr[index] == 1 ? "ติด" : "ดับ",
                    style: TextStyle(fontSize: 13))),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                margin: EdgeInsets.fromLTRB(20, 0, 10, 0),
                child: Text(" - RGB Color", style: TextStyle(fontSize: 13))),
            const Expanded(
                child: Divider(
              height: 10,
              thickness: 1,
              color: Color(0xffd0d0d0),
            )),
            Container(
                margin: EdgeInsets.fromLTRB(20, 0, 10, 0),
                child: Text("#" + currentColor_arr[index],
                    style: TextStyle(
                        fontSize: 13,
                        color: Color(
                            int.parse("0xff" + currentColor_arr[index]))))),
          ],
        ),
      ],
    );
  }

  Widget ShowStatus_curtain(String title, int index) {
    return Column(
      children: [
        Row(
          children: [
            Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                child:
                    Text(title, style: TextStyle(fontWeight: FontWeight.bold))),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                margin: EdgeInsets.fromLTRB(20, 0, 10, 5),
                child: Text(
                    index == 0
                        ? " - Front Curtain Status"
                        : "  - Side Curtain Status",
                    style: TextStyle(fontSize: 13))),
            const Expanded(
                child: Divider(
              height: 10,
              thickness: 1,
              color: Color(0xffd0d0d0),
            )),
            Container(
                margin: EdgeInsets.fromLTRB(20, 0, 10, 5),
                child: Text(curtainstate_arr[index] == "1" ? "เปิด" : "ปิด",
                    style: TextStyle(fontSize: 13))),
          ],
        ),
      ],
    );
  }

  Widget _WidgetStatus(Icon icon, String title, int key) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Column(
                children: [
                  Row(children: [
                    Container(
                      child: Icon(icon.icon),
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    ),
                    Text(
                      title,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ]),
                ],
              ),
            ),
          ],
        ),
        key == 0
            ? Column(
                children: [
                  Container(
                      margin: EdgeInsets.fromLTRB(30, 0, 0, 10),
                      child: ShowStatus_light(childPath[0][0], 0)),
                  Container(
                      margin: EdgeInsets.fromLTRB(30, 0, 0, 10),
                      child: ShowStatus_light(childPath[1][0], 1)),
                  Container(
                      margin: EdgeInsets.fromLTRB(30, 0, 0, 10),
                      child: ShowStatus_light(childPath[2][0], 2)),
                  Container(
                      margin: EdgeInsets.fromLTRB(30, 0, 0, 10),
                      child: ShowStatus_light(childPath[3][0], 3)),
                  Container(
                      margin: EdgeInsets.fromLTRB(30, 0, 0, 10),
                      child: ShowStatus_light(childPath[4][0], 4)),
                ],
              )
            : Column(
                children: [
                  Container(
                      margin: EdgeInsets.fromLTRB(30, 0, 0, 10),
                      child: ShowStatus_curtain(curtain_childPath[0][0], 0)),
                  Container(
                      margin: EdgeInsets.fromLTRB(30, 0, 0, 10),
                      child: ShowStatus_curtain(curtain_childPath[1][0], 1)),
                ],
              )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: isLoading
          ? const CircularProgressIndicator()
          : Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.transparent,
                centerTitle: true,
                elevation: 0,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    title[isSlide ? previousPage : index],
                    Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                      CircleAvatar(
                        radius: 15,
                        backgroundImage: userFromGg
                            ? NetworkImage(user.photoURL!)
                            : AssetImage('images/Unknown.png') as ImageProvider,
                      )
                    ])
                  ],
                ),
              ),
              backgroundColor: const Color(0xff131818),
              body: index == 0
                  ? RefreshIndicator(
                      color: Color(0xffabd8ed),
                      backgroundColor: const Color(0xff131818),
                      onRefresh: () => _getStatus(),
                      child: Center(
                        child: ListView(
                          children: [
                            Container(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      15, 20, 15, 10),
                                              child: CarouselSlider.builder(
                                                  itemCount:
                                                      sliderImages.length,
                                                  itemBuilder: (context, index,
                                                      realIndex) {
                                                    final thisImage =
                                                        sliderImages[index];
                                                    return buildSlider(
                                                        thisImage, index);
                                                  },
                                                  options: CarouselOptions(
                                                      height: 170,
                                                      autoPlay: true,
                                                      enlargeCenterPage: true,
                                                      aspectRatio: 16 / 9,
                                                      viewportFraction: 0.8,
                                                      autoPlayInterval:
                                                          Duration(
                                                              seconds: 3))))),
                                    ],
                                  ),
                                  DividerBetween("Widget For Controller"),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        HorizontalBox(
                                            LedScreen(),
                                            Icon(Icons.lightbulb_outlined,
                                                size: 40),
                                            "Light",
                                            20,
                                            keyButton),
                                        HorizontalBox(
                                            CurtainScreen(),
                                            Icon(Icons.festival_outlined,
                                                size: 40),
                                            "Curtain",
                                            20,
                                            keyButton2),
                                        HorizontalBox(
                                            SpeechScreen(),
                                            Icon(Icons.mic, size: 40),
                                            "Speech",
                                            20,
                                            keyButton3),
                                      ],
                                    ),
                                  ),
                                  DividerBetween("Widget Status"),
                                  Container(
                                    key: keyButton4,
                                    margin: EdgeInsets.fromLTRB(15, 5, 15, 35),
                                    width: double.infinity,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(20.0),
                                        topLeft: Radius.circular(20.0),
                                        bottomRight: Radius.circular(20.0),
                                        bottomLeft: Radius.circular(20.0),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          16.0, 16, 16, 8),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                alignment: Alignment.topLeft,
                                                child: const Text("อุปกรณ์",
                                                    style: TextStyle(
                                                        fontSize: 19,
                                                        color:
                                                            Color(0xff181818),
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ),
                                              Container(
                                                alignment: Alignment.topRight,
                                                child: const Text("สถานะ",
                                                    style: TextStyle(
                                                        fontSize: 19,
                                                        color:
                                                            Color(0xff181818),
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            margin: const EdgeInsets.fromLTRB(
                                                15, 10, 15, 10),
                                            child: Column(
                                              children: [
                                                _WidgetStatus(
                                                    Icon(Icons
                                                        .lightbulb_outline),
                                                    "LIGHT",
                                                    0),
                                                _WidgetStatus(
                                                    Icon(Icons
                                                        .festival_outlined),
                                                    " Curtain",
                                                    1),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : pages[isSlide ? previousPage : index],
              bottomNavigationBar: CurvedNavigationBar(
                key: _bottomNavigationKey,
                index: 0,
                height: 52.0,
                items: BottomBarItems,
                color: Color(0xffabd8ed),
                buttonBackgroundColor: Color(0xffabd8ed),
                backgroundColor: Colors.transparent,
                animationCurve: Curves.easeInOut,
                animationDuration: Duration(milliseconds: 500),
                onTap: (index) {
                  setState(() {
                    this.index = index;
                    previousPage = index;
                  });
                },
                letIndexChange: (index) => true,
              ),
              extendBody: true,
            ),
    );
  }

  void onChangedTab(int index) {
    setState(() => {this.index = index, isSlide = false});
  }

  Widget buildSlider(String thisImage, int index) {
    return Container(

      width: 600,
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Image(image: AssetImage(thisImage),fit: BoxFit.fitWidth)
    );
  }
}

Widget DividerBetween(String title) {
  return Row(children: [
    const Expanded(
        child: Divider(
      height: 35,
      thickness: 0,
      color: Color(0xffd0d0d0),
      endIndent: 5,
      indent: 5,
    )),
    Text(
      title,
      style: const TextStyle(
        color: Color(0xffd0d0d0),
        fontSize: 10,
      ),
    ),
    const Expanded(
        child: Divider(
      height: 35,
      thickness: 0,
      color: Color(0xffd0d0d0),
      indent: 5,
      endIndent: 5,
    )),
  ]);
}

Widget CustomDivider() {
  return const Divider(
    height: 35,
    thickness: 0,
    color: Color(0xffd0d0d0),
    indent: 5,
    endIndent: 5,
  );
}
