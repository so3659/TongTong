import 'package:flutter/material.dart';
import 'package:tongtong/community/memoMainPage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:go_router/go_router.dart';

class Mainpage extends StatefulWidget {
  const Mainpage({Key? key}) : super(key: key);

  @override
  State<Mainpage> createState() => MainpageState();
}

class MainpageState extends State<Mainpage> {
  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //     debugShowCheckedModeBanner: false,
    //     theme: ThemeData(
    //       fontFamily: 'SunflowerMedium',
    //     ),
    //     home:
    return SizedBox.expand(
        child: Column(
      children: [
        SizedBox(
          child: Image.asset('assets/images/tong_top_logo.png'),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                    child: SizedBox(
                      height: 150,
                      width: 150,
                      child: FloatingActionButton(
                        heroTag: 'insta',
                        backgroundColor: Colors.white,
                        onPressed: () async {
                          final url = Uri.parse(
                              'https://www.instagram.com/t_tong.official/');
                          if (await canLaunchUrl(url)) {
                            launchUrl(url,
                                mode: LaunchMode.externalApplication);
                          }
                        },
                        child: const Image(
                          image: AssetImage('assets/images/insta.png'),
                          height: 100,
                          width: 100,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      height: 250,
                      width: 150,
                      child: FloatingActionButton(
                        heroTag: 'booking',
                        backgroundColor: Colors.white,
                        onPressed: () async {
                          final url = Uri.parse(
                              'https://www.spacecloud.kr/space/18120');
                          if (await canLaunchUrl(url)) {
                            launchUrl(url,
                                mode: LaunchMode.externalApplication);
                          }
                        },
                        child: const Image(
                          image: AssetImage('assets/images/booking.png'),
                          height: 100,
                          width: 100,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                    child: SizedBox(
                      height: 250,
                      width: 150,
                      child: FloatingActionButton(
                        heroTag: 'chat',
                        backgroundColor: Colors.white,
                        onPressed: () async {
                          context.push('/memo');
                        },
                        child: const Image(
                          image: AssetImage('assets/images/community.png'),
                          height: 100,
                          width: 100,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      height: 150,
                      width: 150,
                      child: FloatingActionButton(
                        heroTag: 'navercafe',
                        backgroundColor: Colors.white,
                        onPressed: () async {
                          final url =
                              Uri.parse('https://cafe.naver.com/tongtongkhu');
                          if (await canLaunchUrl(url)) {
                            launchUrl(url,
                                mode: LaunchMode.externalApplication);
                          }
                        },
                        child: const Image(
                          image: AssetImage('assets/images/navercafe.png'),
                          height: 100,
                          width: 100,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ])
          ],
        )
      ],
    ));
  }
}
