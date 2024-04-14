import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class Mainpage extends StatefulWidget {
  const Mainpage({super.key});

  @override
  State<Mainpage> createState() => MainpageState();
}

class MainpageState extends State<Mainpage> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  Timer? _timer;
  final List<String> _imageUrls = []; // 여기에 Firebase 이미지 URL을 추가합니다.

  @override
  void initState() {
    super.initState();
    // 이미지 URL을 Firebase에서 불러와서 _imageUrls에 할당하는 함수를 실행합니다.
    fetchImagesFromFirebase();
    startAutoSlide();
  }

  void startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (_currentPage < _imageUrls.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeIn,
        );
      }
    });
  }

  Future<void> fetchImagesFromFirebase() async {
    // Firestore에서 Banners 컬렉션의 첫 번째 문서를 가져옵니다.
    DocumentSnapshot bannerDoc = await FirebaseFirestore.instance
        .collection('Banners')
        .limit(1)
        .get()
        .then((snapshot) => snapshot.docs.first);

    // images 필드가 있는지 확인하고, 있다면 _imageUrls에 추가합니다.
    if (bannerDoc.exists && bannerDoc.data() is Map) {
      final data = bannerDoc.data() as Map<String, dynamic>;
      final imagesList = data['images'] as List<dynamic>;
      setState(() {
        _imageUrls.addAll(imagesList.cast<String>());
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
        body: ListView(children: [
      Center(
          child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              SizedBox(
                height: screenSize.height * 0.11, // 배너 높이 설정
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _imageUrls.length,
                  itemBuilder: (context, index) {
                    return Image.network(
                      _imageUrls[index],
                      fit: BoxFit.cover,
                    );
                  },
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                    vertical: screenSize.height * 0.005,
                    horizontal: screenSize.width * 0.005),
                margin: EdgeInsets.all(screenSize.height * 0.005),
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(500)),
                child: Text(
                  '${_currentPage + 1} / ${_imageUrls.length}', // 현재 페이지 / 전체 페이지
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
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
                        height:
                            screenSize.height * 0.25, // 전체 화면 높이의 25%를 높이로 설정
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
                        height:
                            screenSize.height * 0.25, // 전체 화면 높이의 25%를 높이로 설정
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
                                  image:
                                      AssetImage('assets/images/booking.png'),
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
                        height:
                            screenSize.height * 0.25, // 전체 화면 높이의 25%를 높이로 설정
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
                        height:
                            screenSize.height * 0.25, // 전체 화면 높이의 25%를 높이로 설정
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
      ))
    ]));
  }
}
