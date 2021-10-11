import 'package:flutter/material.dart';

class LedScreen extends StatefulWidget {
  const LedScreen({ Key? key }) : super(key: key);

  @override
  _LedScreenState createState() => _LedScreenState();
}

class _LedScreenState extends State<LedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text("LED Controller"),
      ),
      backgroundColor: const Color(0xff131818),
      body: Container(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Container(

          ),
        ),
      ),
    );
  }
}