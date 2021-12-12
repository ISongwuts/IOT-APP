import 'package:avatar_glow/avatar_glow.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:myapp/api/voice_recognition_api.dart';

class SpeechScreen extends StatefulWidget {
  const SpeechScreen({Key? key}) : super(key: key);

  @override
  _SpeechScreenState createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
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
  }

  @override
  void initState() {
    // TODO: implement initState
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
      backgroundColor: Color(0xff181818),
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
    if (text == "ไอ้แดงเปิดหน้าต่างด้านหน้า") {
        dbRef
            .child("Gadget")
            .child("Curtain")
            .child(curtain_childPath[0][0])
            .child(curtain_childPath[0][1])
            .set("1");

    }
    if (text == "ไอ้แดงปิดหน้าต่างด้านหน้า") {
        dbRef
            .child("Gadget")
            .child("Curtain")
            .child(curtain_childPath[0][0])
            .child(curtain_childPath[0][1])
            .set("0");

    }
    if (text == "ไอ้แดงเปิดหน้าต่างด้านข้าง") {
        dbRef
            .child("Gadget")
            .child("Curtain")
            .child(curtain_childPath[1][0])
            .child(curtain_childPath[0][1])
            .set("1");

    }
    if (text == "ไอ้แดงปิดหน้าต่างด้านข้าง") {
        dbRef
            .child("Gadget")
            .child("Curtain")
            .child(curtain_childPath[1][0])
            .child(curtain_childPath[0][1])
            .set("0");
    }
    if (text.trim() == "ไอ้แดงเปิดหน้าต่างทั้ง 2 ด้าน") {
      for(int index = 0; index<curtain_childPath.length; index++){
        dbRef
            .child("Gadget")
            .child("Curtain")
            .child(curtain_childPath[index][0])
            .child(curtain_childPath[0][1])
            .set("1");
      }
    }
    if (text.trim() == "ไอ้แดงปิดหน้าต่างทั้ง 2 ด้าน") {
      for(int index = 0; index<curtain_childPath.length; index++){
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
