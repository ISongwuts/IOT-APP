import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LedScreen extends StatefulWidget {
  const LedScreen({Key? key}) : super(key: key);

  @override
  _LedScreenState createState() => _LedScreenState();
}

class _LedScreenState extends State<LedScreen> {
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
    if(mounted) {
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
    for (int index_of_stLoop = 0;
        index_of_stLoop < childPath.length;
        index_of_stLoop++) {
      await dbRef
          .child("Gadget")
          .child("Light")
          .child(childPath[index_of_stLoop][0])
          .child(childPath[index_of_stLoop][1])
          .once()
          .then((DataSnapshot snapshot) => {ledState_arr.add(snapshot.value)});
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
  }

  @override
  void initState() {
    // TODO: implement initState
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
                            Control_Light("Bedroom", 0),
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
