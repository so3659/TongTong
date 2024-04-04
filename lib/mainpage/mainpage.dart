import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class Mainpage extends StatefulWidget {
  const Mainpage({super.key});

  @override
  State<Mainpage> createState() => MainpageState();
}

class MainpageState extends State<Mainpage> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
        body: Center(
            child: SizedBox.expand(
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
                    margin: EdgeInsets.fromLTRB(
                        10, screenSize.height * 0.05, 10, 20),
                    child: SizedBox(
                      height: screenSize.height * 0.25, // 전체 화면 높이의 25%를 높이로 설정
                      width: screenSize.width * 0.4, // 전체 화면 너비의 40%를 너비로 설정
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
                        child: const Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image(
                                image: AssetImage('assets/images/insta.png'),
                                height: 100,
                                width: 100,
                              ),
                              Text('인스타그램')
                            ]),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(
                        10, screenSize.height * 0.05, 10, 20),
                    child: SizedBox(
                      height: screenSize.height * 0.25, // 전체 화면 높이의 25%를 높이로 설정
                      width: screenSize.width * 0.4, // 전체 화면 너비의 40%를 너비로 설정
                      child: FloatingActionButton(
                        heroTag: 'booking',
                        backgroundColor: Colors.white,
                        onPressed: () {
                          GoRouter.of(context).push('/practice_room');
                        },
                        child: const Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image(
                                image: AssetImage('assets/images/booking.png'),
                                height: 100,
                                width: 100,
                              ),
                              Text('연습실 추천')
                            ]),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(
                        10, screenSize.height * 0.05, 10, 20),
                    child: SizedBox(
                      height: screenSize.height * 0.25, // 전체 화면 높이의 25%를 높이로 설정
                      width: screenSize.width * 0.4, // 전체 화면 너비의 40%를 너비로 설정
                      child: FloatingActionButton(
                        heroTag: 'community',
                        backgroundColor: Colors.white,
                        onPressed: () {
                          GoRouter.of(context).push('/memo');
                        },
                        child: const Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image(
                                image:
                                    AssetImage('assets/images/community.png'),
                                height: 100,
                                width: 100,
                              ),
                              Text('자유게시판')
                            ]),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(
                        10, screenSize.height * 0.05, 10, 20),
                    child: SizedBox(
                      height: screenSize.height * 0.25, // 전체 화면 높이의 25%를 높이로 설정
                      width: screenSize.width * 0.4, // 전체 화면 너비의 40%를 너비로 설정
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
                        child: const Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image(
                                image:
                                    AssetImage('assets/images/navercafe.png'),
                                height: 100,
                                width: 100,
                              ),
                              Text('네이버 카페')
                            ]),
                      ),
                    ),
                  ),
                ],
              ),
            ])
          ],
        )
      ],
    ))));
  }
}
