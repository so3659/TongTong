import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:tongtong/restaurant/restaurant_postMainPage.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoMain extends StatefulWidget {
  const InfoMain({super.key});

  @override
  State<InfoMain> createState() => InfoMainState();
}

class InfoMainState extends State<InfoMain> {
  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //     theme: ThemeData(
    //         fontFamily: 'SunflowerMedium',
    //         colorScheme:
    //             ColorScheme.fromSeed(seedColor: (Colors.lightBlue[200])!)),
    //     debugShowCheckedModeBanner: false,
    //     home:
    return Scaffold(
        body: SizedBox.expand(
            child: Column(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(10, 20, 10, 0),
          height: 30,
          width: 370,
          decoration: BoxDecoration(
            color: Colors.grey[350],
            borderRadius: BorderRadius.circular(38.5),
          ),
          child: const Center(
            child: Text(
              '정보 공유',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontFamily: 'SunflowerMedium'),
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                      margin: const EdgeInsets.fromLTRB(10, 40, 10, 20),
                      child: SizedBox(
                        height: 170,
                        width: 170,
                        child: FloatingActionButton(
                          heroTag: 'restaurant',
                          backgroundColor: Colors.white,
                          onPressed: () {
                            GoRouter.of(context).push('/restaurant');
                          },
                          child: const Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image(
                                  image: AssetImage(
                                      'assets/images/restaurant.png'),
                                  height: 100,
                                  width: 100,
                                ),
                                Text('맛집 추천')
                              ]),
                        ),
                      )),
                  Container(
                    margin: const EdgeInsets.fromLTRB(10, 40, 10, 20),
                    child: SizedBox(
                      height: 170,
                      width: 170,
                      child: FloatingActionButton(
                        heroTag: 'shop',
                        backgroundColor: Colors.white,
                        onPressed: () {
                          GoRouter.of(context).push('/repair');
                        },
                        child: const Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image(
                                image: AssetImage('assets/images/shop.png'),
                                height: 80,
                                width: 80,
                              ),
                              Text('기타 수리점 추천')
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
                    margin: const EdgeInsets.fromLTRB(10, 40, 10, 20),
                    child: SizedBox(
                      height: 170,
                      width: 170,
                      child: FloatingActionButton(
                        heroTag: 'guitar',
                        backgroundColor: Colors.white,
                        onPressed: () {
                          GoRouter.of(context).push('/knowhow');
                        },
                        child: const Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image(
                                image: AssetImage('assets/images/guitar.png'),
                                height: 100,
                                width: 100,
                              ),
                              Text('기타 노하우')
                            ]),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(10, 40, 10, 20),
                    child: SizedBox(
                      height: 170,
                      width: 170,
                      child: FloatingActionButton(
                        heroTag: 'lightning',
                        backgroundColor: Colors.white,
                        onPressed: () {
                          GoRouter.of(context).push('/lighting');
                        },
                        child: const Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image(
                                image:
                                    AssetImage('assets/images/lightning.png'),
                                height: 100,
                                width: 100,
                              ),
                              Text('번개 추천/후기')
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
    )));
  }
}
