import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class CurtainScreen extends StatefulWidget {
  const CurtainScreen({Key? key}) : super(key: key);

  @override
  _CurtainScreenState createState() => _CurtainScreenState();
}

class _CurtainScreenState extends State<CurtainScreen> {
  late TutorialCoachMark tutorialCoachMark_curtain;
  List<TargetFocus> targets_curtain = <TargetFocus>[];

  GlobalKey keyButton9 = GlobalKey();
  GlobalKey keyButton10 = GlobalKey();

  bool isKnowTutorial = false;
  final dbRef = FirebaseDatabase.instance.reference();
  late var Curtain_arr = List<String>.filled(2, "", growable: false);
  bool isLoading = true;
  var childPath = [
    ["front_curtain", "curtain_state"],
    ["side_curtain", "curtain_state"]
  ];

  _getCurtainState() async {
    readData();
    for (int index = 0; index < childPath.length; index++) {
      await dbRef
          .child("Gadget")
          .child("Curtain")
          .child(childPath[index][0])
          .child(childPath[index][1])
          .once()
          .then(
              (DataSnapshot snapshot) => {Curtain_arr[index] = snapshot.value});
    }
    setState(() {
      isLoading = false;
    });
    showTutorial();
  }

  void initTarget() {
    targets_curtain.add(
        TargetFocus(identify: "Target 8", keyTarget: keyButton9, contents: [
      TargetContent(
          child: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text("ปุ่มเลื่อนผ้าม่าน",
                      style: TextStyle(
                          color: Color(0xffabd8ed),
                          fontSize: 25,
                          fontWeight: FontWeight.bold)),
                  Text(
                      "ผู้ใชังานสามารถเช็คว่าไฟเปิด-ปิดผ้าม่านด้วยการกดปุ่มนี้",
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
    targets_curtain.add(
        TargetFocus(identify: "Target 9", keyTarget: keyButton10, contents: [
      TargetContent(
          child: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text("ปุ่มหยุดเลื่อนผ้าม่าน",
                      style: TextStyle(
                          color: Color(0xffabd8ed),
                          fontSize: 25,
                          fontWeight: FontWeight.bold)),
                  Text(
                      "หากผู้ใชัเลื่อนผ้าม่านถึงจุดที่เหมาะสมสามารถกดปุ่มนี้เพื่อหยุดเลื่อนได้",
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
  }

  saveData() async {
    SharedPreferences share_prefs = await SharedPreferences.getInstance();
    share_prefs.setBool('isKnowTutorial-curtain', true);
  }

  readData() async {
    SharedPreferences share_prefs = await SharedPreferences.getInstance();
    setState(() {
      isKnowTutorial = share_prefs.getBool('isKnowTutorial-curtain')!;
    });
    print(isKnowTutorial);
  }

  void showTutorial() async {
    saveData();
    if (isKnowTutorial == true) {
      print("yes");
    } else {
      tutorialCoachMark_curtain = TutorialCoachMark(context,
          targets: targets_curtain,
          colorShadow: Color(0xff131818),
          opacityShadow: 1)
        ..show();
      print("end");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    initTarget();
    _getCurtainState();
    super.initState();
  }

  Widget CurtainControllBox(String title, int index) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                alignment: Alignment.center,
                width: 50,
                height: 50,
                child: Icon(Icons.festival_outlined,
                    color: Color(0xffabd8ed), size: 30),
              ),
              Container(
                  margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Color(0xffabd8ed)))),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Transform.scale(
                  scale: 1,
                  child: Switch(
                    onChanged: (value) {
                      if (Curtain_arr[index] == "1") {
                        dbRef
                            .child('Gadget')
                            .child('Curtain')
                            .child(childPath[index][0])
                            .child(childPath[index][1])
                            .set("0");
                        setState(() {
                          Curtain_arr[index] = "0";
                        });
                      } else {
                        dbRef
                            .child('Gadget')
                            .child('Curtain')
                            .child(childPath[index][0])
                            .child(childPath[index][1])
                            .set("1");
                        setState(() {
                          Curtain_arr[index] = "1";
                        });
                      }
                    },
                    value: Curtain_arr[index] == "1" ? true : false,
                    activeColor: const Color(0xffabd8ed),
                    activeTrackColor: const Color(0xffabd8ed),
                    inactiveThumbColor: Colors.grey,
                    inactiveTrackColor: Colors.grey,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: ElevatedButton(
                  onPressed: () {
                    dbRef
                        .child('Gadget')
                        .child('Curtain')
                        .child(childPath[index][0])
                        .child(childPath[index][1])
                        .set("STOP");
                  },
                  child: Text("STOP"),
                  style: ElevatedButton.styleFrom(primary: Colors.red),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget CurtainControllBox_Tutorial(String title, int index) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                alignment: Alignment.center,
                width: 50,
                height: 50,
                child: Icon(Icons.festival_outlined,
                    color: Color(0xffabd8ed), size: 30),
              ),
              Container(
                  margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Color(0xffabd8ed)))),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                key: keyButton9,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Transform.scale(
                  scale: 1,
                  child: Switch(
                    onChanged: (value) {
                      if (Curtain_arr[index] == "1") {
                        dbRef
                            .child('Gadget')
                            .child('Curtain')
                            .child(childPath[index][0])
                            .child(childPath[index][1])
                            .set("0");
                        setState(() {
                          Curtain_arr[index] = "0";
                        });
                      } else {
                        dbRef
                            .child('Gadget')
                            .child('Curtain')
                            .child(childPath[index][0])
                            .child(childPath[index][1])
                            .set("1");
                        setState(() {
                          Curtain_arr[index] = "1";
                        });
                      }
                    },
                    value: Curtain_arr[index] == "1" ? true : false,
                    activeColor: const Color(0xffabd8ed),
                    activeTrackColor: const Color(0xffabd8ed),
                    inactiveThumbColor: Colors.grey,
                    inactiveTrackColor: Colors.grey,
                  ),
                ),
              ),
              Container(
                key: keyButton10,
                margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: ElevatedButton(
                  onPressed: () {
                    dbRef
                        .child('Gadget')
                        .child('Curtain')
                        .child(childPath[index][0])
                        .child(childPath[index][1])
                        .set("STOP");
                  },
                  child: Text("STOP"),
                  style: ElevatedButton.styleFrom(primary: Colors.red),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Curtain Controller"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Color(0xff131818),
      body: Center(
        child: RefreshIndicator(
          color: const Color(0xffabd8ed),
          backgroundColor: const Color(0xff181818),
          onRefresh: () => _getCurtainState(),
          child: isLoading
              ? CircularProgressIndicator()
              : ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          CurtainControllBox_Tutorial("Front Curtain", 0),
                          CurtainControllBox("Side Curtain", 1),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
