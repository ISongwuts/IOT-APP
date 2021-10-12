import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class LedScreen extends StatefulWidget {
  const LedScreen({Key? key}) : super(key: key);

  @override
  _LedScreenState createState() => _LedScreenState();
}

class _LedScreenState extends State<LedScreen> {
  final dbRef = FirebaseDatabase.instance.reference();
  late String? ledStatus = null;
  late int? ledState = null;
  bool isLoading = true;

  getLEDStatus() async {
    await dbRef
        .child('Status')
        .child('state')
        .once()
        .then((DataSnapshot snapshot) {
      ledState = snapshot.value;
    });
    await dbRef
        .child('Status')
        .child('status')
        .once()
        .then((DataSnapshot snapshot) {
      ledStatus = snapshot.value;
    });

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getLEDStatus();
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
          color: const Color(0xffabd8ed),
          onRefresh: () => getLEDStatus(),
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
                            ledState == 1
                                ? Container(
                                    margin: EdgeInsets.fromLTRB(0, 30, 0, 10),
                                    alignment: Alignment.center,
                                    width: double.infinity,
                                    child: const Image(
                                      image: AssetImage("images/lbon.png"),
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Container(
                                    margin: EdgeInsets.fromLTRB(0, 30, 0, 10),
                                    alignment: Alignment.center,
                                    width: double.infinity,
                                    child: const Image(
                                      image: AssetImage("images/lboff.png"),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                            ledState == 1
                                ? Container(
                                    margin: EdgeInsets.fromLTRB(0, 10, 0, 20),
                                    child: const Text("LIGHT IS ON",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 28,
                                            color: Color(0xffabd8ed))),
                                  )
                                : Container(
                                    margin: EdgeInsets.fromLTRB(0, 10, 0, 20),
                                    child: const Text("LIGHT IS OFF",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 28,
                                            color: Colors.grey)),
                                  ),
                            Transform.scale(
                              scale: 2,
                              child: Switch(
                                onChanged: (value) {
                                  if (ledState == 1) {
                                    dbRef.child('Status').child('state').set(0);
                                    dbRef
                                        .child('Status')
                                        .child('status')
                                        .set(" Off");
                                    setState(() {
                                      ledState = 0;
                                    });
                                  } else {
                                    dbRef.child('Status').child('state').set(1);
                                    dbRef
                                        .child('Status')
                                        .child('status')
                                        .set(" On");
                                    setState(() {
                                      ledState = 1;
                                    });
                                  }
                                },
                                value: ledState == 1 ? true : false,
                                activeColor: const Color(0xffabd8ed),
                                activeTrackColor: const Color(0xffabd8ed),
                                inactiveThumbColor: Colors.grey,
                                inactiveTrackColor: Colors.grey,
                              ),
                            ),
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

class LedStatus {
  late int? state = null;
  late String? status = null;
}
