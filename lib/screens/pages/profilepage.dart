import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      Container(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset('images/logoTrans.png',
                          width: double.infinity, height: 200),
                    ),
                  ),
                ],
              ),
              Container(
                child: Padding(
                    padding: EdgeInsets.all(15),
                    child: DividerBetween("ทีมผู้พัฒนาแอปฯ")),
              ),
              Column(
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset('images/Prim.png',
                            fit: BoxFit.cover, width: 100, height: 150),
                      ),
                      infoContent("นางสาวมณิสร สมานกุล:",
                          " หน้าที่ผู้ออกแบบแอปพลิเคชันทั้ง User Experience, User Interface (Ux/Ui) และ Layout ต่าง ๆ"),
                    ],
                  )
                ],
              ),
              Column(
                children: [
                  Row(
                    children: [
                      infoContent("นายทรงวุฒิ มะลิศรี:",
                          " หน้าที่สร้างแอปพลิเคชันตามแบบที่ดีไซน์ และ Roadmap ที่เขียนเอาไว้ (Frontend/Backend)"),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset('images/Ice.png',
                            fit: BoxFit.cover, width: 100, height: 150),
                      ),
                    ],
                  )
                ],
              ),
              Column(
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset('images/Boss.png',
                            fit: BoxFit.cover, width: 100, height: 150),
                      ),
                      infoContent("นายณัฐพัชร์ ศรีพิสุทธิสกุล:",
                          " หน้าที่วางแผนการดำเนินการต่าง ๆ ในการสร้างแอปพลิเคชัน เช่น Roadmap, Er Diagram, Usecase"),
                    ],
                  )
                ],
              ),
              Container(
                child: Padding(
                    padding: EdgeInsets.all(15),
                    child: DividerBetween("ช่องทางการติดต่อ")),
              ),
              Column(
                children: [
                  contactUs(
                      Icon(
                        Icons.phone,
                        color: Color(0xffabd8ed),
                      ),
                      "094-427-1168"),
                  contactUs(
                      Icon(
                        Icons.mail,
                        color: Color(0xffabd8ed),
                      ),
                      "ISongwut.me@gmail.com"),
                  contactUs(
                      Icon(
                        Icons.facebook,
                        color: Color(0xffabd8ed),
                      ),
                      "ไอซ์ ทรงวุฒิ"),
                ],
              ),
              Container(
                child: Padding(
                    padding: EdgeInsets.all(15),
                    child: DividerBetween("เกี่ยวกับแอปฯ")),
              ),
              Column(
                children: [
                  Row(
                    children: [
                      AppContent("แอปพลิเคชัน",
                          " นี้สร้างขึ้นโดยใช้ Flutter Framework ซึ่งใช้ภาษา Dart ในการเขียนและพัฒนาแอปพลิเคชัน และ ใช้ realtime database ของ Firebase ในการสั่งการเปิด-ปิดไฟ โดยหลักการทำงานคือการรับค่าจากปุ่มแต่ละปุ่มแบบ realtime และส่งค่าขึ้นไปยัง realtime database และอุปกรณ์ที่เราเขียนโปรแกรมไว้จะทำการดึงค่าแบบ realtime ไปใช้งานและสั่งงานอุปกรณ์ต่าง ๆ ตามที่ต่อและเขียนโปรแกรมไว้"),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    ]);
  }
}

Widget contactUs(Icon icon, String des) {
  return (Row(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 5),
        child: Expanded(child: icon),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 5),
        child: Expanded(
          child: Text(
            des,
            style: TextStyle(color: Color(0xffabd8ed)),
          ),
        ),
      )
    ],
  ));
}

Widget AppContent(String name, String content) {
  return (Container(
    child: Flexible(
        child: Padding(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
              text: name,
              style: TextStyle(color: Color(0xffabd8ed), fontSize: 25),
              children: [
                TextSpan(
                  text: content,
                  style: TextStyle(color: Color(0xffdddddd), fontSize: 15),
                ),
              ])),
    )),
  ));
}

Widget infoContent(String name, String content) {
  return (Container(
    child: Flexible(
        child: Padding(
      padding: EdgeInsets.all(10),
      child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
              text: name,
              style: TextStyle(color: Color(0xffabd8ed), fontSize: 18),
              children: [
                TextSpan(
                  text: content,
                  style: TextStyle(color: Color(0xffdddddd), fontSize: 14),
                ),
              ])),
    )),
  ));
}

Widget DividerBetween(String title) {
  return Row(children: [
    const Expanded(
        child: Divider(
      height: 35,
      thickness: 0,
      color: Color(0xffd0d0d0),
      endIndent: 5,
      indent: 5,
    )),
    Text(
      title,
      style: const TextStyle(
        color: Color(0xffd0d0d0),
        fontSize: 15,
      ),
    ),
    const Expanded(
        child: Divider(
      height: 35,
      thickness: 0,
      color: Color(0xffd0d0d0),
      indent: 5,
      endIndent: 5,
    )),
  ]);
}
