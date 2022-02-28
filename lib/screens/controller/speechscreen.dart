import 'package:avatar_glow/avatar_glow.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:myapp/api/voice_recognition_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class SpeechScreen extends StatefulWidget {
  const SpeechScreen({Key? key}) : super(key: key);

  @override
  _SpeechScreenState createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  late TutorialCoachMark tutorialCoachMark_speech;
  List<TargetFocus> targets_speech = <TargetFocus>[];

  GlobalKey keyButton11 = GlobalKey();
  GlobalKey keyButton12 = GlobalKey();

  bool isKnowTutorial = false;
  final dbRef = FirebaseDatabase.instance.reference();
  bool isLoading = true;
  bool isListening = false;
  late var Curtain_arr = List<String>.filled(2, "", growable: false);
  late List<int> ledState_arr = [];
  late List<String> currentColor_arr = [];
  String text = "Press the button to start speaking.";

  var curtain_childPath = [
    ["front_curtain", "curtain_state"],
    ["side_curtain", "curtain_state"]
  ];

  var light_childPath = [
    ["light_bedroom", "light_state", "light_rgb_color"],
    ["light_livingroom", "light_state", "light_rgb_color"],
    ["light_bathroom", "light_state", "light_rgb_color"],
    ["light_kitchen", "light_state", "light_rgb_color"],
    ["light_rooftop", "light_state", "light_rgb_color"],
  ];

  _getState() async {
    readData(); 
    for (int index = 0; index < curtain_childPath.length; index++) {
      await dbRef
          .child("Gadget")
          .child("Curtain")
          .child(curtain_childPath[index][0])
          .child(curtain_childPath[index][1])
          .once()
          .then(
              (DataSnapshot snapshot) => {Curtain_arr[index] = snapshot.value});
    }
    for (int index_of_stLoop = 0;
        index_of_stLoop < light_childPath.length;
        index_of_stLoop++) {
      await dbRef
          .child("Gadget")
          .child("Light")
          .child(light_childPath[index_of_stLoop][0])
          .child(light_childPath[index_of_stLoop][1])
          .once()
          .then((DataSnapshot snapshot) => {ledState_arr.add(snapshot.value)});
      await dbRef
          .child("Gadget")
          .child("Light")
          .child(light_childPath[index_of_stLoop][0])
          .child(light_childPath[index_of_stLoop][2])
          .once()
          .then((DataSnapshot snapshot) =>
              {currentColor_arr.add(snapshot.value)});
    }

    setState(() {
      isLoading = false;
    });
    showTutorial();
  }

  void initTarget() {
    targets_speech.add(
        TargetFocus(identify: "Target 10", keyTarget: keyButton11, contents: [
      TargetContent(
          child: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text("กล่องข้อความ",
                      style: TextStyle(
                          color: Color(0xffabd8ed),
                          fontSize: 25,
                          fontWeight: FontWeight.bold)),
                  Text(
                      "เราสามารถเช็คคำที่เราพูดได้ว่าทางแอปนั้นเข้าใจถูกหรือไม่",
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
    targets_speech.add(
        TargetFocus(identify: "Target 11", keyTarget: keyButton12, contents: [
      TargetContent(
          align: ContentAlign.top,
          child: Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text("ปุ่มพูด",
                          style: TextStyle(
                              color: Color(0xffabd8ed),
                              fontSize: 25,
                              fontWeight: FontWeight.bold)),
                      Text(
                          "ผู้ใชังานสารถกดที่ปุ่มนี้และพูดคีย์เวิร์ด ชื่อฟังก์ชัน - สถานะ - อุปกรณ์ - ห้อง เช่น ไอ้แดงเปิดไฟห้องนอน",
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
    share_prefs.setBool('isKnowTutorial-speech', true);
  }

  readData() async {
    SharedPreferences share_prefs = await SharedPreferences.getInstance();
    setState(() {
      isKnowTutorial = share_prefs.getBool('isKnowTutorial-speech')!;
    });
    print(isKnowTutorial);
  }

  void showTutorial() async {
    saveData();
    if (isKnowTutorial == true) {
      print("yes");
    } else {
      tutorialCoachMark_speech = TutorialCoachMark(context,
          targets: targets_speech,
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
    _getState();
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Speech To Control"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Color(0xff131818),
      body: Center(
        child: RefreshIndicator(
          color: const Color(0xffabd8ed),
          backgroundColor: const Color(0xff181818),
          onRefresh: () => _getState(),
          child: isLoading
              ? CircularProgressIndicator()
              : ListView(
                  children: [
                    Padding(
                      key: keyButton11,
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          DividerBetween("Text Area"),
                          Text(
                            text,
                            style: TextStyle(color: Colors.white),
                          ),
                          CustomDivider(),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
      floatingActionButton: AvatarGlow(
        key: keyButton12,
        animate: isListening,
        endRadius: 75,
        glowColor: Color(0xffabd8ed),
        child: FloatingActionButton(
          onPressed: toggleRecording,
          child: Icon(
            isListening ? Icons.mic : Icons.mic_none,
            color: const Color(0xff181818),
            size: 36,
          ),
          backgroundColor: const Color(0xffabd8ed),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Future toggleRecording() => SpeechApi.toggleRecording(onResult: (value) {
        setState(() {
          text = value;
          _scanText(text);
        });
      }, onListening: (isListening) {
        setState(() {
          this.isListening = isListening;
        });
      });
  _scanText(String text) {
    if (text == "ไอ้แดงเปิดไฟห้องนอน") {
      dbRef
          .child("Gadget")
          .child("Light")
          .child(light_childPath[0][0])
          .child(light_childPath[0][1])
          .set(1);
    }
    if (text == "ไอ้แดงปิดไฟห้องนอน") {
      dbRef
          .child("Gadget")
          .child("Light")
          .child(light_childPath[0][0])
          .child(light_childPath[0][1])
          .set(0);
    }
    if (text == "ไอ้แดงเปิดไฟห้องรับแขก") {
      dbRef
          .child("Gadget")
          .child("Light")
          .child(light_childPath[1][0])
          .child(light_childPath[0][1])
          .set(1);
    }
    if (text == "ไอ้แดงปิดไฟห้องรับแขก") {
      dbRef
          .child("Gadget")
          .child("Light")
          .child(light_childPath[1][0])
          .child(light_childPath[0][1])
          .set(0);
    }
    if (text == "ไอ้แดงเปิดไฟห้องน้ำ") {
      dbRef
          .child("Gadget")
          .child("Light")
          .child(light_childPath[2][0])
          .child(light_childPath[0][1])
          .set(1);
    }
    if (text == "ไอ้แดงปิดไฟห้องน้ำ") {
      dbRef
          .child("Gadget")
          .child("Light")
          .child(light_childPath[2][0])
          .child(light_childPath[0][1])
          .set(0);
    }
    if (text == "ไอ้แดงเปิดไฟห้องครัว") {
      dbRef
          .child("Gadget")
          .child("Light")
          .child(light_childPath[3][0])
          .child(light_childPath[0][1])
          .set(1);
    }
    if (text == "ไอ้แดงปิดไฟห้องครัว") {
      dbRef
          .child("Gadget")
          .child("Light")
          .child(light_childPath[3][0])
          .child(light_childPath[0][1])
          .set(0);
    }
    if (text == "ไอ้แดงเปิดไฟดาดฟ้า") {
      dbRef
          .child("Gadget")
          .child("Light")
          .child(light_childPath[4][0])
          .child(light_childPath[0][1])
          .set(1);
    }
    if (text == "ไอ้แดงปิดไฟดาดฟ้า") {
      dbRef
          .child("Gadget")
          .child("Light")
          .child(light_childPath[4][0])
          .child(light_childPath[0][1])
          .set(0);
    }
    if (text == "ไอ้แดงเปิดไฟทั้งหมด") {
      for (int index = 0; index < light_childPath.length; index++) {
        dbRef
            .child("Gadget")
            .child("Light")
            .child(light_childPath[index][0])
            .child(light_childPath[0][1])
            .set(1);
      }
    }
    if (text == "ไอ้แดงปิดไฟทั้งหมด") {
      for (int index = 0; index < light_childPath.length; index++) {
        dbRef
            .child("Gadget")
            .child("Light")
            .child(light_childPath[index][0])
            .child(light_childPath[0][1])
            .set(0);
      }
    }
    if (text == "ไอ้แดงเปิดหน้าต่างชั้นแรก") {
      dbRef
          .child("Gadget")
          .child("Curtain")
          .child(curtain_childPath[0][0])
          .child(curtain_childPath[0][1])
          .set("1");
    }
    if (text == "ไอ้แดงปิดหน้าต่างชั้นแรก") {
      dbRef
          .child("Gadget")
          .child("Curtain")
          .child(curtain_childPath[0][0])
          .child(curtain_childPath[0][1])
          .set("0");
    }
    if (text == "ไอ้แดงเปิดหน้าต่างชั้นสอง") {
      dbRef
          .child("Gadget")
          .child("Curtain")
          .child(curtain_childPath[1][0])
          .child(curtain_childPath[0][1])
          .set("1");
    }
    if (text == "ไอ้แดงปิดหน้าต่างชั้นสอง") {
      dbRef
          .child("Gadget")
          .child("Curtain")
          .child(curtain_childPath[1][0])
          .child(curtain_childPath[0][1])
          .set("0");
    }
    if (text.trim() == "ไอ้แดงเปิดหน้าต่างทั้ง 2 ชั้น") {
      for (int index = 0; index < curtain_childPath.length; index++) {
        dbRef
            .child("Gadget")
            .child("Curtain")
            .child(curtain_childPath[index][0])
            .child(curtain_childPath[0][1])
            .set("1");
      }
    }
    if (text.trim() == "ไอ้แดงปิดหน้าต่างทั้ง 2 ชั้น") {
      for (int index = 0; index < curtain_childPath.length; index++) {
        dbRef
            .child("Gadget")
            .child("Curtain")
            .child(curtain_childPath[index][0])
            .child(curtain_childPath[0][1])
            .set("0");
      }
    }
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
