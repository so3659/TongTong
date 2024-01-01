import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoMain extends StatefulWidget {
  const InfoMain({Key? key}) : super(key: key);

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
<<<<<<< HEAD
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
                          onPressed: () async {},
                          child: const Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image(
                                  image: AssetImage(
                                      'assets/images/restaurant.png'),
                                  height: 100,
                                  width: 100,
                                ),
                                Text('맛집추천')
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
                        onPressed: () {},
                        child: const Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image(
                                image: AssetImage('assets/images/shop.png'),
                                height: 100,
                                width: 100,
=======
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
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
                                  image:
                                      AssetImage('assets/images/booking.png'),
                                  height: 100,
                                  width: 100,
                                ),
>>>>>>> 97ca06a09e6687d7ffc036fe4aaf3af2cfaf7503
                              ),
                              Text('리페어 샵 추천')
                            ]),
                      ),
<<<<<<< HEAD
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
                        onPressed: () async {},
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
                        onPressed: () async {},
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
=======
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Container(
                          //   padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                          //   child: SizedBox(
                          //     height: 250,
                          //     width: 150,
                          //     child: FloatingActionButton(
                          //       heroTag: 'chat',
                          //       backgroundColor: Colors.white,
                          //       onPressed: () async {},
                          //       child: const Image(
                          //         image: AssetImage('assets/images/community.png'),
                          //         height: 100,
                          //         width: 100,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          Container(
                            padding: const EdgeInsets.all(10.0),
                            child: SizedBox(
                              height: 430,
                              width: 150,
                              child: FloatingActionButton(
                                heroTag: 'navercafe',
                                backgroundColor: Colors.white,
                                onPressed: () async {
                                  final url = Uri.parse(
                                      'https://cafe.naver.com/tongtongkhu');
                                  if (await canLaunchUrl(url)) {
                                    launchUrl(url,
                                        mode: LaunchMode.externalApplication);
                                  }
                                },
                                child: const Image(
                                  image:
                                      AssetImage('assets/images/navercafe.png'),
                                  height: 100,
                                  width: 100,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ])
                // Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                //   Column(
                //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //     children: [
                //       Container(
                //           margin: const EdgeInsets.fromLTRB(10, 40, 10, 20),
                //           child: SizedBox(
                //             height: 170,
                //             width: 170,
                //             child: FloatingActionButton(
                //               heroTag: 'restaurant',
                //               backgroundColor: Colors.white,
                //               onPressed: () async {},
                //               child: const Column(
                //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //                   children: [
                //                     Image(
                //                       image: AssetImage(
                //                           'assets/images/restaurant.png'),
                //                       height: 100,
                //                       width: 100,
                //                     ),
                //                     Text('맛집추천')
                //                   ]),
                //             ),
                //           )),
                //       Container(
                //         margin: const EdgeInsets.fromLTRB(10, 40, 10, 20),
                //         child: SizedBox(
                //           height: 170,
                //           width: 170,
                //           child: FloatingActionButton(
                //             heroTag: 'shop',
                //             backgroundColor: Colors.white,
                //             onPressed: () {},
                //             child: const Column(
                //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //                 children: [
                //                   Image(
                //                     image: AssetImage('assets/images/shop.png'),
                //                     height: 100,
                //                     width: 100,
                //                   ),
                //                   Text('리페어 샵 추천')
                //                 ]),
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                //   Column(
                //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //     children: [
                //       Container(
                //         margin: const EdgeInsets.fromLTRB(10, 40, 10, 20),
                //         child: SizedBox(
                //           height: 170,
                //           width: 170,
                //           child: FloatingActionButton(
                //             heroTag: 'guitar',
                //             backgroundColor: Colors.white,
                //             onPressed: () async {},
                //             child: const Column(
                //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //                 children: [
                //                   Image(
                //                     image: AssetImage('assets/images/guitar.png'),
                //                     height: 100,
                //                     width: 100,
                //                   ),
                //                   Text('기타 노하우')
                //                 ]),
                //           ),
                //         ),
                //       ),
                //       Container(
                //         margin: const EdgeInsets.fromLTRB(10, 40, 10, 20),
                //         child: SizedBox(
                //           height: 170,
                //           width: 170,
                //           child: FloatingActionButton(
                //             heroTag: 'lightning',
                //             backgroundColor: Colors.white,
                //             onPressed: () async {},
                //             child: const Column(
                //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //                 children: [
                //                   Image(
                //                     image:
                //                         AssetImage('assets/images/lightning.png'),
                //                     height: 100,
                //                     width: 100,
                //                   ),
                //                   Text('번개 추천/후기')
                //                 ]),
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ])
              ],
            )
>>>>>>> 97ca06a09e6687d7ffc036fe4aaf3af2cfaf7503
          ],
        )
      ],
    )));
  }
}
