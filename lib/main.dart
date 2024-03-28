import 'package:flutter/material.dart';
import 'package:tongtong/Register/googleLogin.dart';
import 'package:tongtong/Register/register.dart';
import 'package:tongtong/calendar/makeAppointment.dart';
import 'package:tongtong/community/makePost.dart';
import 'package:go_router/go_router.dart';
import 'package:tongtong/community/postMainPage.dart';
import 'package:tongtong/mainpage/homepage.dart';
import 'package:tongtong/mainpage/mainpage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tongtong/community/postDetailPage.dart';
import 'firebase_options.dart';
import 'package:tongtong/parameter/postParameter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
      path: '/register',
      pageBuilder: (context, state) =>
          const MaterialPage<void>(child: Register()),
    ),
    GoRoute(
      path: '/homepage',
      pageBuilder: (context, state) =>
          const MaterialPage<void>(child: HomePage()),
    ),
    GoRoute(
      path: '/memo',
      builder: (context, state) => const MyMemoPage(),
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
      path: '/postDetailPage',
      name: 'postDetailPage',
      builder: (context, state) {
        // extra에서 post 객체를 추출합니다.
        final post = state.extra as FeedPost;
        // 추출한 post 객체를 PostDetailPage 생성자에 전달합니다.
        return PostDetailPage(post: post);
      },
    ),
  ],
  debugLogDiagnostics: true,
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          fontFamily: 'SunflowerMedium',
          colorScheme:
              ColorScheme.fromSeed(seedColor: (Colors.lightBlue[200])!)),
      routerConfig: _goroute,
    );
  }
}
