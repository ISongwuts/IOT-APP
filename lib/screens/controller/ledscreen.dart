import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class LedScreen extends StatefulWidget {
  const LedScreen({Key? key}) : super(key: key);

  @override
  _LedScreenState createState() => _LedScreenState();
}

class _LedScreenState extends State<LedScreen> {
  late TutorialCoachMark tutorialCoachMark_led;
  List<TargetFocus> targets_led = <TargetFocus>[];

  GlobalKey keyButton6 = GlobalKey();
  GlobalKey keyButton7 = GlobalKey();
  GlobalKey keyButton8 = GlobalKey();

  bool isKnowTutorial = false;
  final dbRef = FirebaseDatabase.instance.reference();
  var childPath = [
    ["light_bedroom", "light_state", "light_rgb_color"],
    ["light_livingroom", "light_state", "light_rgb_color"],
    ["light_bathroom", "light_state", "light_rgb_color"],
    ["light_kitchen", "light_state", "light_rgb_color"],
    ["light_rooftop", "light_state", "light_rgb_color"],
  ];
  late List<int> ledState_arr = [];
  late List<String> currentColor_arr = [];
  bool isLoading = true;
  late String? _StrColor;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Widget Control_Light(String title, int index) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  alignment: Alignment.center,
                  width: 50,
                  height: 50,
                  child: Image(
                    image: ledState_arr[index] == 1
                        ? AssetImage("images/lbon.png")
                        : AssetImage("images/lboff.png"),
                  ),
                ),
                Container(
                    margin: EdgeInsets.fromLTRB(15, 22, 20, 20),
                    child: Text(title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Color(0xffabd8ed)))),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MaterialButton(
                  elevation: 0,
                  onPressed: () {
                    final textController = TextEditingController(
                        text: "#${currentColor_arr[index]}");
                    ledState_arr[index] == 1
                        ? showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                scrollable: true,
                                titlePadding: const EdgeInsets.all(0.0),
                                contentPadding: const EdgeInsets.all(0.0),
                                content: Column(
                                  children: [
                                    ColorPicker(
                                      pickerColor: Color(int.parse(
                                          "0xff" + currentColor_arr[index])),
                                      onColorChanged: (color) {
                                        changeColor(color, index);
                                      },
                                      colorPickerWidth: 300.0,
                                      pickerAreaHeightPercent: 0.7,
                                      enableAlpha:
                                          true, // hexInputController will respect it too.
                                      displayThumbColor: true,
                                      showLabel: true,
                                      paletteType: PaletteType.hsv,
                                      pickerAreaBorderRadius:
                                          const BorderRadius.only(
                                        topLeft: Radius.circular(10.0),
                                        topRight: Radius.circular(10.0),
                                      ),
                                      hexInputController:
                                          textController, // <- here
                                      portraitOnly: true,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: CupertinoTextField(
                                        controller: textController,
                                        prefix: const Padding(
                                          padding: EdgeInsets.only(left: 8),
                                          child: Icon(Icons.tag),
                                        ),
                                        suffix: IconButton(
                                            icon: const Icon(
                                                Icons.content_paste_rounded),
                                            onPressed: () async => {
                                                  copyToClipboard(
                                                      textController.text),
                                                  Fluttertoast.showToast(
                                                    msg:
                                                        "Copied to your clipboard",
                                                    gravity: ToastGravity.TOP,
                                                  ),
                                                }),
                                        autofocus: true,
                                        maxLength: 9,
                                        inputFormatters: [
                                          UpperCaseTextFormatter(),
                                          FilteringTextInputFormatter.allow(
                                              RegExp(kValidHexPattern)),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          )
                        : null;
                  },
                  child: const Text(
                    'Pick RGB',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                  ),
                  color: ledState_arr[index] == 1
                      ? Color(int.parse("0xff" + currentColor_arr[index]))
                      : Colors.grey,
                  textColor: const Color(0xffffffff),
                  height: 40,
                  minWidth: 30,
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                  child: Transform.scale(
                    scale: 1,
                    child: Switch(
                      onChanged: (value) {
                        if (ledState_arr[index] == 1) {
                          dbRef
                              .child('Gadget')
                              .child('Light')
                              .child(childPath[index][0])
                              .child('light_state')
                              .set(0);
                          setState(() {
                            ledState_arr[index] = 0;
                          });
                        } else {
                          dbRef
                              .child('Gadget')
                              .child('Light')
                              .child(childPath[index][0])
                              .child('light_state')
                              .set(1);
                          setState(() {
                            ledState_arr[index] = 1;
                          });
                        }
                      },
                      value: ledState_arr[index] == 1 ? true : false,
                      activeColor: const Color(0xffabd8ed),
                      activeTrackColor: const Color(0xffabd8ed),
                      inactiveThumbColor: Colors.grey,
                      inactiveTrackColor: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget Control_Light_Tutorial(String title, int index) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  alignment: Alignment.center,
                  width: 50,
                  height: 50,
                  child: Image(
                    key: keyButton6,
                    image: ledState_arr[index] == 1
                        ? AssetImage("images/lbon.png")
                        : AssetImage("images/lboff.png"),
                  ),
                ),
                Container(
                    margin: EdgeInsets.fromLTRB(15, 22, 20, 20),
                    child: Text(title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Color(0xffabd8ed)))),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MaterialButton(
                  key: keyButton7,
                  elevation: 0,
                  onPressed: () {
                    final textController = TextEditingController(
                        text: "#${currentColor_arr[index]}");
                    ledState_arr[index] == 1
                        ? showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                scrollable: true,
                                titlePadding: const EdgeInsets.all(0.0),
                                contentPadding: const EdgeInsets.all(0.0),
                                content: Column(
                                  children: [
                                    ColorPicker(
                                      pickerColor: Color(int.parse(
                                          "0xff" + currentColor_arr[index])),
                                      onColorChanged: (color) {
                                        changeColor(color, index);
                                      },
                                      colorPickerWidth: 300.0,
                                      pickerAreaHeightPercent: 0.7,
                                      enableAlpha:
                                          true, // hexInputController will respect it too.
                                      displayThumbColor: true,
                                      showLabel: true,
                                      paletteType: PaletteType.hsv,
                                      pickerAreaBorderRadius:
                                          const BorderRadius.only(
                                        topLeft: Radius.circular(10.0),
                                        topRight: Radius.circular(10.0),
                                      ),
                                      hexInputController:
                                          textController, // <- here
                                      portraitOnly: true,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: CupertinoTextField(
                                        controller: textController,
                                        prefix: const Padding(
                                          padding: EdgeInsets.only(left: 8),
                                          child: Icon(Icons.tag),
                                        ),
                                        suffix: IconButton(
                                            icon: const Icon(
                                                Icons.content_paste_rounded),
                                            onPressed: () async => {
                                                  copyToClipboard(
                                                      textController.text),
                                                  Fluttertoast.showToast(
                                                    msg:
                                                        "Copied to your clipboard",
                                                    gravity: ToastGravity.TOP,
                                                  ),
                                                }),
                                        autofocus: true,
                                        maxLength: 9,
                                        inputFormatters: [
                                          UpperCaseTextFormatter(),
                                          FilteringTextInputFormatter.allow(
                                              RegExp(kValidHexPattern)),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          )
                        : null;
                  },
                  child: const Text(
                    'Pick RGB',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                  ),
                  color: ledState_arr[index] == 1
                      ? Color(int.parse("0xff" + currentColor_arr[index]))
                      : Colors.grey,
                  textColor: const Color(0xffffffff),
                  height: 40,
                  minWidth: 30,
                ),
                Container(
                  key: keyButton8,
                  margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                  child: Transform.scale(
                    scale: 1,
                    child: Switch(
                      onChanged: (value) {
                        if (ledState_arr[index] == 1) {
                          dbRef
                              .child('Gadget')
                              .child('Light')
                              .child(childPath[index][0])
                              .child('light_state')
                              .set(0);
                          setState(() {
                            ledState_arr[index] = 0;
                          });
                        } else {
                          dbRef
                              .child('Gadget')
                              .child('Light')
                              .child(childPath[index][0])
                              .child('light_state')
                              .set(1);
                          setState(() {
                            ledState_arr[index] = 1;
                          });
                        }
                      },
                      value: ledState_arr[index] == 1 ? true : false,
                      activeColor: const Color(0xffabd8ed),
                      activeTrackColor: const Color(0xffabd8ed),
                      inactiveThumbColor: Colors.grey,
                      inactiveTrackColor: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  changeColor(Color color, int index) => {
        _getCurrentColor(index),
        _StrColor = color.toString().substring(10, 16),
        dbRef
            .child("Gadget")
            .child("Light")
            .child(childPath[index][0])
            .child("light_rgb_color")
            .set(_StrColor),
      };

  // Just an example of how to use/interpret/format text input's result.
  Future<void> copyToClipboard(String input) async {
    late String textToCopy;
    final hex = input.toUpperCase();
    if (hex.startsWith('FF') && hex.length == 8) {
      textToCopy = hex.replaceFirst('', '');
    } else {
      textToCopy = hex;
    }
    await Clipboard.setData(ClipboardData(text: '#$textToCopy'));
  }

  _getCurrentColor(int index) async {
    await dbRef
        .child("Gadget")
        .child("Light")
        .child(childPath[index][0])
        .child(childPath[index][2])
        .once()
        .then((DataSnapshot snapshot) =>
            {currentColor_arr[index] = snapshot.value});
    setState(() {
      isLoading = false;
    });
  }

  Future<void> getStatus() async {
    readData();
    for (int index_of_stLoop = 0;
        index_of_stLoop < childPath.length;
        index_of_stLoop++) {
      await dbRef
          .child("Gadget")
          .child("Light")
          .child(childPath[index_of_stLoop][0])
          .child(childPath[index_of_stLoop][1])
          .once()
          .then((DataSnapshot snapshot) => {
                setState(() {
                  print(childPath[index_of_stLoop][0]+ " State is: " + snapshot.value.toString());
                  ledState_arr.add(snapshot.value);
                })
              });
      await dbRef
          .child("Gadget")
          .child("Light")
          .child(childPath[index_of_stLoop][0])
          .child(childPath[index_of_stLoop][2])
          .once()
          .then((DataSnapshot snapshot) =>
              {currentColor_arr.add(snapshot.value)});
    }
    
    setState(() {
      isLoading = false;
    });

    Future.delayed(Duration(seconds: 2), showTutorial);
  }

  void initTarget() {
    targets_led.add(
        TargetFocus(identify: "Target 5", keyTarget: keyButton6, contents: [
      TargetContent(
          child: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text("หลอดไฟแสดงสถานะของอุปกรณ์",
                      style: TextStyle(
                          color: Color(0xffabd8ed),
                          fontSize: 25,
                          fontWeight: FontWeight.bold)),
                  Text(
                      "ผู้ใชังานสามารถเช็คว่าไฟเปิด-ปิดอยู่หรือไม่ด้วยการสังเกตที่ภาพหลอดไฟ",
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
    targets_led.add(
        TargetFocus(identify: "Target 6", keyTarget: keyButton7, contents: [
      TargetContent(
          child: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text("ฟังก์ชันเปลี่ยนสีหลอดไฟ",
                      style: TextStyle(
                          color: Color(0xffabd8ed),
                          fontSize: 25,
                          fontWeight: FontWeight.bold)),
                  Text("ผู้ใชังานสามารถเลือกพาเลตสีเพื่อเปลี่ยนแสงไฟได้",
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
    targets_led.add(TargetFocus(
        identify: "Target 7",
        keyTarget: keyButton8,
        contents: [
          TargetContent(
              child: Container(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text("ปุ่มเปิด-ปิดหลอดไฟ",
                          style: TextStyle(
                              color: Color(0xffabd8ed),
                              fontSize: 25,
                              fontWeight: FontWeight.bold)),
                      Text("ผู้ใชังานสามารถเปิด - ปิดหลอดไฟด้วยการกดปุ่มนี้",
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
        enableOverlayTab: true));
  }

  saveData() async {
    SharedPreferences share_prefs = await SharedPreferences.getInstance();
    share_prefs.setBool('isKnowTutorial-led', true);
  }

  readData() async {
    SharedPreferences share_prefs = await SharedPreferences.getInstance();
    setState(() {
      isKnowTutorial = share_prefs.getBool('isKnowTutorial-led')!;
    });
    print(isKnowTutorial);
  }

  void showTutorial() async {
    saveData();
    if (isKnowTutorial == true) {
      print("yes");
    } else {
      tutorialCoachMark_led = TutorialCoachMark(context,
          targets: targets_led,
          colorShadow: Color(0xff131818),
          opacityShadow: 1)
        ..show();
    }
  }

  @override
  void initState() {
    initTarget();
    getStatus();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text("Light Controller"),
      ),
      backgroundColor: const Color(0xff131818),
      body: Center(
        child: RefreshIndicator(
          backgroundColor: const Color(0xff131818),
          color: const Color(0xffabd8ed),
          onRefresh: () => getStatus(),
          child: isLoading
              ? CircularProgressIndicator(
                  color: const Color(0xffabd8ed),
                )
              : ListView(
                  children: [
                    Container(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Control_Light_Tutorial("Bedroom", 0),
                            Control_Light("Living room", 1),
                            Control_Light("Bathroom", 2),
                            Control_Light("Kitchen", 3),
                            Control_Light("Rooftop", 4),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(_, TextEditingValue nv) =>
      TextEditingValue(text: nv.text.toUpperCase(), selection: nv.selection);
}
