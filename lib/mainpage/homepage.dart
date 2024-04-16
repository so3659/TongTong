import 'dart:convert';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tongtong/calendar/calendarMain.dart';
import 'package:tongtong/community/postDetailPage.dart';
import 'package:tongtong/info/infoMain.dart';
import 'package:tongtong/knowhow/knowhow_postDetailPage.dart';
import 'package:tongtong/lightning/lightning_postDetailPage.dart';
import 'package:tongtong/mainpage/mainpage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tongtong/parameter/postParameter.dart';
import 'package:tongtong/practice_room/practice_postDetailPage.dart';
import 'package:tongtong/profile/profilePage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tongtong/repair/repair_postDetailPage.dart';
import 'package:tongtong/restaurant/restaurant_postDetailPage.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  static const storage = FlutterSecureStorage();
  final PageController _pageController = PageController();
  final AssetsAudioPlayer _assetsAudioPlayer = AssetsAudioPlayer.newPlayer();
  bool _play = true;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> onSelectNotification(NotificationResponse details) async {
    try {
      if (details.payload != null) {
        Map<String, dynamic> outerData =
            json.decode(details.payload ?? "") as Map<String, dynamic>;
        if (outerData.containsKey('postId')) {
          Map<String, dynamic> data =
              json.decode(outerData['postId']) as Map<String, dynamic>;
          FeedPost post = FeedPost.fromMap(data);
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PostDetailPage(post: post)));
        } else if (outerData.containsKey('knowhowId')) {
          Map<String, dynamic> data =
              json.decode(outerData['knowhowId']) as Map<String, dynamic>;
          FeedPost post = FeedPost.fromMap(data);
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => KnowhowDetailPage(post: post)));
        } else if (outerData.containsKey('repairId')) {
          Map<String, dynamic> data =
              json.decode(outerData['repairId']) as Map<String, dynamic>;
          FeedPost post = FeedPost.fromMap(data);
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RepairDetailPage(post: post)));
        } else if (outerData.containsKey('lightningId')) {
          Map<String, dynamic> data =
              json.decode(outerData['lightningId']) as Map<String, dynamic>;
          FeedPost post = FeedPost.fromMap(data);
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => LightningDetailPage(post: post)));
        } else if (outerData.containsKey('restaurantsId')) {
          Map<String, dynamic> data =
              json.decode(outerData['restaurantsId']) as Map<String, dynamic>;
          FeedPost post = FeedPost.fromMap(data);
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RestaurantDetailPage(post: post)));
        } else if (outerData.containsKey('practiceId')) {
          Map<String, dynamic> data =
              json.decode(outerData['practiceId']) as Map<String, dynamic>;
          FeedPost post = FeedPost.fromMap(data);
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PracticeDetailPage(post: post)));
        }
      }
    } catch (e) {
      debugPrint("Error navigating: $e");
    }
  }

  @override
  void initState() {
    setupPlaylist();

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.data.containsKey('postId')) {
        final dynamic postJson = json.decode(message.data['postId']);
        if (postJson is Map<String, dynamic>) {
          FeedPost post = FeedPost.fromMap(postJson);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PostDetailPage(post: post)));
        }
      } else if (message.data.containsKey('knowhowId')) {
        final dynamic postJson = json.decode(message.data['knowhowId']);
        if (postJson is Map<String, dynamic>) {
          FeedPost post = FeedPost.fromMap(postJson);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => KnowhowDetailPage(post: post)));
        }
      } else if (message.data.containsKey('repairId')) {
        final dynamic postJson = json.decode(message.data['repairId']);
        if (postJson is Map<String, dynamic>) {
          FeedPost post = FeedPost.fromMap(postJson);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RepairDetailPage(post: post)));
        }
      } else if (message.data.containsKey('lightningId')) {
        final dynamic postJson = json.decode(message.data['lightningId']);
        if (postJson is Map<String, dynamic>) {
          FeedPost post = FeedPost.fromMap(postJson);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => LightningDetailPage(post: post)));
        }
      } else if (message.data.containsKey('restaurantsId')) {
        final dynamic postJson = json.decode(message.data['restaurantsId']);
        if (postJson is Map<String, dynamic>) {
          FeedPost post = FeedPost.fromMap(postJson);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RestaurantDetailPage(post: post)));
        }
      } else if (message.data.containsKey('practiceId')) {
        final dynamic postJson = json.decode(message.data['practiceId']);
        if (postJson is Map<String, dynamic>) {
          FeedPost post = FeedPost.fromMap(postJson);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PracticeDetailPage(post: post)));
        }
      }
    });

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message?.data != null && message!.data.containsKey('postId')) {
        final dynamic postJson = json.decode(message.data['postId']);
        if (postJson is Map<String, dynamic>) {
          FeedPost post = FeedPost.fromMap(postJson);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PostDetailPage(post: post)));
        }
      } else if (message?.data != null &&
          message!.data.containsKey('knowhowId')) {
        final dynamic postJson = json.decode(message.data['knowhowId']);
        if (postJson is Map<String, dynamic>) {
          FeedPost post = FeedPost.fromMap(postJson);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => KnowhowDetailPage(post: post)));
        }
      } else if (message?.data != null &&
          message!.data.containsKey('repairId')) {
        final dynamic postJson = json.decode(message.data['repairId']);
        if (postJson is Map<String, dynamic>) {
          FeedPost post = FeedPost.fromMap(postJson);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RepairDetailPage(post: post)));
        }
      } else if (message?.data != null &&
          message!.data.containsKey('lightningId')) {
        final dynamic postJson = json.decode(message.data['lightningId']);
        if (postJson is Map<String, dynamic>) {
          FeedPost post = FeedPost.fromMap(postJson);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => LightningDetailPage(post: post)));
        }
      } else if (message?.data != null &&
          message!.data.containsKey('restaurantsId')) {
        final dynamic postJson = json.decode(message.data['restaurantsId']);
        if (postJson is Map<String, dynamic>) {
          FeedPost post = FeedPost.fromMap(postJson);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RestaurantDetailPage(post: post)));
        }
      } else if (message?.data != null &&
          message!.data.containsKey('practiceId')) {
        final dynamic postJson = json.decode(message.data['practiceId']);
        if (postJson is Map<String, dynamic>) {
          FeedPost post = FeedPost.fromMap(postJson);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PracticeDetailPage(post: post)));
        }
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        FlutterLocalNotificationsPlugin().show(
          notification.hashCode,
          notification.title,
          notification.body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'high_importance_channel',
              'high_importance_notification',
              importance: Importance.max,
            ),
          ),
          payload: json.encode(message.data), // `payload`를 json 문자열로 설정
        );
      }
    });

    var initializationSettingsAndroid =
        const AndroidInitializationSettings('mipmap/ic_launcher');

    var initialzationSettingsIOS = const DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initialzationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onSelectNotification,
    );

    super.initState();
  }

  void setupPlaylist() async {
    _assetsAudioPlayer.open(
      Audio(
        "assets/audio/tong_music.mp3",
        metas: Metas(
          title: "낭만이라는 우리",
          artist: "김태리",
          album: "통통 1집",
          image: const MetasImage.asset("assets/images/tong_logo.png"),
        ),
      ),
      showNotification: true,
      autoStart: false,
      loopMode: LoopMode.single,
    );

    _assetsAudioPlayer.isPlaying.listen((event) {
      setState(() {
        _play = event;
      });
    });
  }

  int _selectedIndex = 0;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  static const List<Widget> _widgetOptions = <Widget>[
    Mainpage(),
    InfoMain(),
    Calendar(),
    ProfilePage()
  ];

  @override
  void dispose() {
    _assetsAudioPlayer.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  signOut() async {
    storage.delete(key: "login");
    await GoogleSignIn().signOut();
  }

  void _playPause() {
    _assetsAudioPlayer.playOrPause();
    setState(() {
      _play = !_play;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('통통')),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                GoRouter.of(context).push('/helppeople');
              },
              icon: const Icon(
                Icons.favorite,
                color: Colors.pink,
              ))
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: Column(
          children: [
            SizedBox(
              height: screenSize.height * 0.05,
            ),
            Row(
              children: [
                // Padding(
                //     padding: EdgeInsets.fromLTRB(
                //         screenSize.width * 0.03, 0, screenSize.width * 0.03, 0),
                //     child: const CircleAvatar(
                //         backgroundColor: Colors.white,
                //         backgroundImage:
                //             AssetImage('assets/images/tong_logo.png'),
                //         radius: 30)),
                SizedBox(
                  width: screenSize.width * 0.07,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    children: [
                      const Text(
                        '낭만이라는 우리',
                        style: TextStyle(fontSize: 15),
                      ),
                      Text(
                        '김태리 - 통통 1집',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: screenSize.width * 0.25,
                ),
                IconButton(
                  icon: Icon(_play ? Icons.pause : Icons.play_arrow),
                  iconSize: 28,
                  onPressed: () => _assetsAudioPlayer.playOrPause(),
                ),
              ],
            ),
            SizedBox(
              height: screenSize.height * 0.2,
            ),
            Container(
                width: screenSize.height * 0.3,
                height: screenSize.height * 0.3,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/tong_logo.png'),
                    fit: BoxFit.cover,
                  ),
                )),
            Container(
                width: screenSize.height * 0.3,
                height: screenSize.height * 0.1,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/tong_logo_name.png'),
                    fit: BoxFit.cover,
                  ),
                )),
            SizedBox(
              height: screenSize.height * 0.1,
            ),
            Expanded(
                child: Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                children: [
                  SizedBox(
                    width: screenSize.width * 0.05,
                  ),
                  InkWell(
                    onTap: () async {
                      final url = Uri.parse(
                          'https://github.com/so3659/Social-App-For-Club');
                      if (await canLaunchUrl(url)) {
                        launchUrl(url, mode: LaunchMode.externalApplication);
                      }
                    },
                    child: const ImageIcon(
                      AssetImage("assets/images/github_logo_name.png"),
                      size: 40,
                    ),
                  ),
                  const Spacer(),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        child: const Text(
                          '후원하기',
                        ),
                        onPressed: () {
                          signOut();
                          GoRouter.of(context).push('/sponsor');
                        },
                      ),
                      TextButton(
                        child: const Text(
                          '로그아웃',
                        ),
                        onPressed: () async {
                          await signOut();
                          if (!mounted) return; // 위젯이 마운트되어 있지 않다면 함수를 종료합니다.
                          GoRouter.of(context).go('/login');
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ))
          ],
        ),
      ),
      body: Navigator(
        onGenerateRoute: (RouteSettings) {
          return MaterialPageRoute(
            builder: (context) => Center(
              child: _widgetOptions.elementAt(_selectedIndex),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Info',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.perm_identity),
            label: 'My',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.lightBlue[200],
        backgroundColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}

Widget _createFolderInDrawer(String folderName) {
  return Container(
    padding: const EdgeInsets.all(8.0),
    child: Text(folderName),
  );
}
