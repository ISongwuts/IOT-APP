import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/screens/splashscreen.dart';
void main() {
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
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "IOT App",
      home: const Scaffold(
        body: SplashPage(),
      ),
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
    );
  }
}

