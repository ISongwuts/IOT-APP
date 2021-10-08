import 'package:flutter/material.dart';

class NoConnectionScreen extends StatelessWidget {
  const NoConnectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Icon(
              Icons.wifi_off,
              size: 150,
              color: Colors.pink,
          ),
          Text("No wifi connection",
            style: TextStyle(fontSize:20,fontWeight:FontWeight.bold,color: Colors.pink),
          ),
          Text("Please check your wifi connection and try again",
            style: TextStyle(fontSize:15,color: Colors.pink),
          ),
          
        ],
      ),
    ));
  }
}
