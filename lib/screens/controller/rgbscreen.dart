import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:color_convert/color_convert.dart';

class RgbScreen extends StatefulWidget {
  const RgbScreen({Key? key}) : super(key: key);

  @override
  _RgbScreenState createState() => _RgbScreenState();
}

class _RgbScreenState extends State<RgbScreen> {
  final dbRef = FirebaseDatabase.instance.reference();
  late Color currentColor = Color(int.parse("0xff"+_CurrentColor_fromDB!));
  late Type x;
  bool isLoading = true;
  late String? _CurrentColor_fromDB;
  late String? _StrColor;
  void changeColor(Color color) => setState(() => {
        _getCurrentColor(),
        currentColor = color,
        _StrColor = currentColor.toString().substring(10, 16),
        dbRef.child("RGB").child("Color").set(_StrColor),
      });

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

  Future<void> _getCurrentColor() async {
    await dbRef
        .child("RGB")
        .child("Color")
        .once()
        .then((DataSnapshot snapshot) {
      _CurrentColor_fromDB = snapshot.value;
      x = snapshot.runtimeType;
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _getCurrentColor();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text("RGB Light Controller",
              style: TextStyle(color: Colors.white)),
        ),
        backgroundColor: const Color(0xff131818),
        body: Center(
          child: isLoading
              ? const CircularProgressIndicator()
              : RefreshIndicator(
                  onRefresh: _getCurrentColor,
                  child: ListView(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.fromLTRB(0, 100, 0, 80),
                            child: Icon(
                              Icons.light_mode,
                              color: currentColor,
                              size: 250,
                            ),
                          ),
                          MaterialButton(
                            elevation: 0,
                            onPressed: () {
                              final textController = TextEditingController(
                                  text: "#$_CurrentColor_fromDB");
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    scrollable: true,
                                    titlePadding: const EdgeInsets.all(0.0),
                                    contentPadding: const EdgeInsets.all(0.0),
                                    content: Column(
                                      children: [
                                        ColorPicker(
                                          pickerColor: currentColor,
                                          onColorChanged: changeColor,
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
                                                icon: const Icon(Icons
                                                    .content_paste_rounded),
                                                onPressed: () async => {
                                                      copyToClipboard(
                                                          textController.text),
                                                      Fluttertoast.showToast(
                                                        msg:
                                                            "Copied to your clipboard",
                                                        gravity:
                                                            ToastGravity.TOP,
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
                              );
                            },
                            child: const Text('Pick the Color',style: TextStyle(fontWeight: FontWeight.bold),),
                            color: currentColor,
                            textColor: const Color(0xffffffff),
                            height: 50,
                            minWidth: 100,
                          ),
                        ],
                      ),
                    ],
                  ),
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
