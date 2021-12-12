import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurtainScreen extends StatefulWidget {
  const CurtainScreen({Key? key}) : super(key: key);

  @override
  _CurtainScreenState createState() => _CurtainScreenState();
}

class _CurtainScreenState extends State<CurtainScreen> {
  final dbRef = FirebaseDatabase.instance.reference();
  late var Curtain_arr = List<String>.filled(2, "", growable: false);
  bool isLoading = true;
  var childPath = [
    ["front_curtain", "curtain_state"],
    ["side_curtain", "curtain_state"]
  ];

  _getCurtainState() async {
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
  }

  @override
  void initState() {
    // TODO: implement initState
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
                    Curtain_arr[index] == "1"
                        ? dbRef
                            .child('Gadget')
                            .child('Curtain')
                            .child(childPath[index][0])
                            .child(childPath[index][1])
                            .set("STOP")
                        : null;
                  },
                  child: Text("STOP"),
                  style: ElevatedButton.styleFrom(
                    primary:
                        Curtain_arr[index] == "1" ? Colors.red : Colors.grey,
                  ),
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
      backgroundColor: Color(0xff181818),
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
                          CurtainControllBox("Front Curtain", 0),
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
