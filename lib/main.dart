import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:tongtong/EULA/eula.dart';
import 'package:tongtong/EULA/eulaDetail.dart';
import 'package:tongtong/Inquiry/inquiry.dart';
import 'package:tongtong/Register/googleLogin.dart';
import 'package:tongtong/calendar/makeAppointment.dart';
import 'package:tongtong/community/makePost.dart';
import 'package:go_router/go_router.dart';
import 'package:tongtong/community/postMainPage.dart';
import 'package:tongtong/help/helpPeople.dart';
import 'package:tongtong/knowhow/knowhow_postDetailPage.dart';
import 'package:tongtong/knowhow/knowhow_postMainPage.dart';
import 'package:tongtong/lightning/lightning_postDetailPage.dart';
import 'package:tongtong/lightning/lightning_postMainPage.dart';
import 'package:tongtong/mainpage/homepage.dart';
import 'package:tongtong/mainpage/mainpage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tongtong/community/postDetailPage.dart';
import 'package:tongtong/practice_room/practice_postDetailPage.dart';
import 'package:tongtong/practice_room/practice_postMainPage.dart';
import 'package:tongtong/profile/myComments.dart';
import 'package:tongtong/profile/myPosts.dart';
import 'package:tongtong/repair/repair_postDetailPage.dart';
import 'package:tongtong/repair/repair_postMainPage.dart';
import 'package:tongtong/restaurant/restaurant_postDetailPage.dart';
import 'package:tongtong/restaurant/restaurant_postMainPage.dart';
import 'package:tongtong/sponsor/sponsor.dart';
import 'firebase_options.dart';
import 'package:tongtong/parameter/postParameter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("백그라운드 메시지 처리.. ${message.notification!.body!}");
}

void initializeNotification() async {
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(const AndroidNotificationChannel(
          'high_importance_channel', 'high_importance_notification',
          importance: Importance.max, playSound: true));

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
      ?.getActiveNotifications();

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  var initialzationSettingsIOS = const DarwinInitializationSettings(
    requestSoundPermission: true,
    requestBadgePermission: true,
    requestAlertPermission: true,
  );

  await flutterLocalNotificationsPlugin.initialize(InitializationSettings(
      android: const AndroidInitializationSettings("mipmap/ic_launcher"),
      iOS: initialzationSettingsIOS));
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 스플래시 스크린을 초기화하고 유지합니다.
  FlutterNativeSplash.preserve(
      widgetsBinding: WidgetsFlutterBinding.ensureInitialized());

  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  initializeNotification();

  initializeDateFormatting().then((_) => runApp(
        const ProviderScope(
          child: MyApp(),
        ),
      ));
}

final GoRouter _goroute = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      pageBuilder: (context, state) =>
          const MaterialPage<void>(child: GoogleLogin()),
    ),
    GoRoute(
      path: '/homepage',
      pageBuilder: (context, state) =>
          const MaterialPage<void>(child: HomePage()),
    ),
    GoRoute(
      path: '/memo',
      builder: (context, state) => const PostPage(),
    ),
    GoRoute(
      path: '/practice_room',
      builder: (context, state) => const PracticePage(),
    ),
    GoRoute(
      path: '/restaurant',
      builder: (context, state) => const RestaurantPage(),
    ),
    GoRoute(
      path: '/helppeople',
      builder: (context, state) => const HelpPeople(),
    ),
    GoRoute(
      path: '/inquiry',
      builder: (context, state) => const Inquiry(),
    ),
    GoRoute(
      path: '/sponsor',
      builder: (context, state) => const Sponsor(),
    ),
    GoRoute(
      path: '/knowhow',
      builder: (context, state) => const KnowhowPage(),
    ),
    GoRoute(
      path: '/repair',
      builder: (context, state) => const RepairPage(),
    ),
    GoRoute(
      path: '/lighting',
      builder: (context, state) => const LightningPage(),
    ),
    GoRoute(
      path: '/mainpage',
      builder: (context, state) => const Mainpage(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const GoogleLogin(),
    ),
    GoRoute(
      path: '/makePost',
      builder: (context, state) => const MakePost(),
    ),
    GoRoute(
      path: '/makeAppointment',
      builder: (context, state) => const MakeAppointment(),
    ),
    GoRoute(
      path: '/myPosts',
      builder: (context, state) => const MyPosts(),
    ),
    GoRoute(
      path: '/myComments',
      builder: (context, state) => const MyComments(),
    ),
    GoRoute(
      path: '/eula',
      builder: (context, state) => const EULA(),
    ),
    GoRoute(
      path: '/eulaDetail',
      builder: (context, state) => const EULADetail(),
    ),
    GoRoute(
      path: '/postDetailPage',
      name: 'postDetailPage',
      builder: (context, state) {
        // extra에서 post 객체를 추출합니다.
        final post = state.extra as FeedPost;
        // 추출한 post 객체를 PostDetailPage 생성자에 전달합니다.
        return PostDetailPage(post: post);
      },
    ),
    GoRoute(
      path: '/Practice_postDetailPage',
      name: 'Practice_postDetailPage',
      builder: (context, state) {
        // extra에서 post 객체를 추출합니다.
        final post = state.extra as FeedPost;
        // 추출한 post 객체를 PostDetailPage 생성자에 전달합니다.
        return PracticeDetailPage(post: post);
      },
    ),
    GoRoute(
      path: '/Restaurant_postDetailPage',
      name: 'Restaurant_postDetailPage',
      builder: (context, state) {
        // extra에서 post 객체를 추출합니다.
        final post = state.extra as FeedPost;
        // 추출한 post 객체를 PostDetailPage 생성자에 전달합니다.
        return RestaurantDetailPage(post: post);
      },
    ),
    GoRoute(
      path: '/Knowhow_postDetailPage',
      name: 'Knowhow_postDetailPage',
      builder: (context, state) {
        // extra에서 post 객체를 추출합니다.
        final post = state.extra as FeedPost;
        // 추출한 post 객체를 PostDetailPage 생성자에 전달합니다.
        return KnowhowDetailPage(post: post);
      },
    ),
    GoRoute(
      path: '/Repair_postDetailPage',
      name: 'Repair_postDetailPage',
      builder: (context, state) {
        // extra에서 post 객체를 추출합니다.
        final post = state.extra as FeedPost;
        // 추출한 post 객체를 PostDetailPage 생성자에 전달합니다.
        return RepairDetailPage(post: post);
      },
    ),
    GoRoute(
      path: '/Lightning_postDetailPage',
      name: 'Lightning_postDetailPage',
      builder: (context, state) {
        // extra에서 post 객체를 추출합니다.
        final post = state.extra as FeedPost;
        // 추출한 post 객체를 PostDetailPage 생성자에 전달합니다.
        return LightningDetailPage(post: post);
      },
    ),
  ],
  debugLogDiagnostics: true,
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    initialization(context);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          fontFamily: 'NanumGothicBold',
          colorScheme:
              ColorScheme.fromSeed(seedColor: (Colors.lightBlue[200])!)),
      routerConfig: _goroute,
    );
  }

  void initialization(BuildContext context) async {
    // 3초 후에 스플래시 스크린을 숨기는 비동기 작업
    await Future.delayed(const Duration(seconds: 1));
    FlutterNativeSplash.remove();
  }
}
