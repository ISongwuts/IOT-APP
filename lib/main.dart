import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/screens/splashscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wiredash/wiredash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  const app = MyApp();
  runApp(app);
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final _navigatorKey = GlobalKey<NavigatorState>();
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return Wiredash(
      secret: "1zUGJh_xrzooCJ-NYybA-dd_KadO5Hl3",
      projectId: "iotfsh-c2kjs1q",
      navigatorKey: _navigatorKey,
      theme: WiredashThemeData(
        primaryBackgroundColor: Color(0xff181818),
        backgroundColor: Color(0xff181818),
        primaryTextColor: Color(0xffabd8ed),
        secondaryBackgroundColor: Color(0xff141414),
        primaryColor: Color(0xffabd8ed),
        secondaryColor: Color(0xffabd8ed),
        tertiaryTextColor: Color(0xffabd8ed),
      ),
      child: MaterialApp(
        navigatorKey: _navigatorKey,
        debugShowCheckedModeBanner: false,
        title: "IOT App",
        home: const Scaffold(
          body: SplashPage(),
        ),
        theme: ThemeData(
          primaryColor: const Color(0xff61dafb),
          backgroundColor: const Color(0xff292a2a),
        ),
      ),
    );
  }
}

