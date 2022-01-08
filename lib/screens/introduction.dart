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
      globalBackgroundColor: Color(0xff131818),
      showNextButton: true,
      showDoneButton: true,
      next: const Icon(Icons.arrow_forward,color: Color(0xffabd8ed),),
      done: const Text(
        "SIGN IN",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Color(0xffabd8ed)
        ),
      ),
      dotsDecorator: DotsDecorator(
          size: const Size.square(10.0),
          activeSize: const Size(20.0, 10.0),
          activeColor: const Color(0xffabd8ed),
          color: Color(0xffaaaaaa),
          spacing: const EdgeInsets.symmetric(horizontal: 3.0),
          activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0))),
      pages: [
        PageViewModel(
          title: "Welcome",
          body: "ยินดีต้อนรับเหล่าผู้ใช้งาน",
          image: _ImagesBox('images/Photographic_Introduction_1.png'),
          decoration: _getPageDecoration_1(),
        ),
        PageViewModel(
          title: "Preface",
          body:
              "โปรเจกต์นี้เป็นส่วนหนึ่งของชิ้นงานวิชาโครงการ ซึ่งสร้างขึ้นเพื่อตอบสนองความต้องการของผู้ใช้งานที่ต้องการสั่งการไฟ ผ้าม่าน จากระยะไกล และเพื่อช่วยเพิ่มความสะดวกสบายในชีวิตประจำวันอีกด้วย ทั้งนี้ หากมีข้อผิดพลาดประการใด ทางคณะผู้จัดทำต้องขออภัยมา ณ ที่นี้ด้วย",
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
    child: ClipRRect(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Image.asset(
          path,
          fit: BoxFit.fitWidth,
          height: 300,
          width: double.infinity,
          alignment: Alignment.center,
        ),
      ),
    ),
  );
}

_getPageDecoration_1() => const PageDecoration(
      titleTextStyle: TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.bold,
        color: Color(0xffabd8ed)
      ),
      bodyTextStyle: TextStyle(
        fontSize: 15,
        color: Color(0xffeeeeee)
      ),
      titlePadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      descriptionPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      imagePadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
    );

_getPageDecoration_2() => const PageDecoration(
      titleTextStyle: TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.bold,
        color: Color(0xffabd8ed)
      ),
      bodyTextStyle: TextStyle(
        fontSize: 15,
        color: Color(0xffeeeeee)
      ),
      titlePadding: EdgeInsets.fromLTRB(0, 0, 0, 10),
      imagePadding: EdgeInsets.fromLTRB(0, 20, 0, 0),
    );

_getPageDecoration_3() => const PageDecoration(
      titleTextStyle: TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.bold,
        color: Color(0xffabd8ed)
      ),
      bodyTextStyle: TextStyle(fontSize: 15, color: Color(0xffeeeeee)),
      titlePadding: EdgeInsets.fromLTRB(0, 0, 0, 40),
      imagePadding: EdgeInsets.fromLTRB(0, 200, 0, 0),
    );
