import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:myapp/screens/auth/registerscreen.dart';


class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {


  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return SafeArea(
        child: IntroductionScreen(
      showNextButton: true,
      showDoneButton: true,
      next: const Icon(Icons.arrow_forward),
      done: const Text(
        "SIGN IN",
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      dotsDecorator: DotsDecorator(
          size: const Size.square(10.0),
          activeSize: const Size(20.0, 10.0),
          activeColor: const Color(0xffabd8ed),
          color: Colors.black26,
          spacing: const EdgeInsets.symmetric(horizontal: 3.0),
          activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0))),
      pages: [
        PageViewModel(
          title: "WELCOME",
          body: "ยินดีต้อนรับเหล่าผู้ใช้งาน",
          image: _ImagesBox('images/Photographic_Introduction_1.png'),
          decoration: _getPageDecoration_1(),
        ),
        PageViewModel(
          title: "PREFACE",
          body:
              "โปรเจกต์นี้สร้างขึันมาเพื่อตอบสนองความต้องการของผู้ใช้งานที่ขี้เกียจ :-; หากมีข้อผิดพลาดประการใดพวกเราต้องขออภัยมา ณ ที่นี้ด้วย",
          image: _ImagesBox('images/Photographic_Introduction_2.png'),
          decoration: _getPageDecoration_2(),
        ),
        PageViewModel(
            title: "เริ่มกันเลย",
            body: "โปรดลงทะเบียนเพื่อเริ่มต้นใช้งาน Product ของเรา",
            image: _ImagesBox('images/Photographic_Introduction_3.png'),
            decoration: _getPageDecoration_3()),
      ],
      onDone: () {
        Navigator.push(
          context,
          PageRouteBuilder(
              transitionDuration: Duration(milliseconds: 500),
              transitionsBuilder: (context, animation, animationTime, child) {
                animation = CurvedAnimation(
                    parent: animation, curve: Curves.linearToEaseOut);
                return ScaleTransition(
                    alignment: Alignment.center,
                    scale: animation,
                    child: child);
              },
              pageBuilder: (context, animation, animationTime) {
                return const RegisterScreen();
              }),
        );
      },
    ));
  }
}

Widget _ImagesBox(String path) {
  return Center(
    child: Image.asset(
      path,
      fit: BoxFit.cover,
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.center,
    ),
  );
}

_getPageDecoration_1() => const PageDecoration(
      titleTextStyle: TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.bold,
      ),
      bodyTextStyle: TextStyle(
        fontSize: 15,
      ),
      titlePadding: EdgeInsets.fromLTRB(0, 0, 0, 40),
      descriptionPadding: EdgeInsets.fromLTRB(0, 0, 0, 30),
      imagePadding: EdgeInsets.fromLTRB(0, 250, 0, 0),
    );

_getPageDecoration_2() => const PageDecoration(
      titleTextStyle: TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.bold,
      ),
      bodyTextStyle: TextStyle(
        fontSize: 15,
      ),
      titlePadding: EdgeInsets.fromLTRB(0, 0, 0, 40),
      imagePadding: EdgeInsets.fromLTRB(0, 20, 0, 0),
    );

_getPageDecoration_3() => const PageDecoration(
      titleTextStyle: TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.bold,
      ),
      bodyTextStyle: TextStyle(fontSize: 15, color: Colors.pink),
      titlePadding: EdgeInsets.fromLTRB(0, 0, 0, 40),
      imagePadding: EdgeInsets.fromLTRB(0, 200, 0, 0),
    );
