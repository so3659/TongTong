import 'package:flutter/material.dart';
import 'package:tongtong/Register/login.dart';
import 'package:tongtong/Register/register.dart';
import 'package:tongtong/community/makePost.dart';
import 'package:go_router/go_router.dart';
import 'package:tongtong/community/postMainPage.dart';
import 'package:tongtong/mainpage/homepage.dart';
import 'package:tongtong/mainpage/mainpage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const MyApp(),
  );
}

final GoRouter _goroute = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => const MaterialPage<void>(child: Login()),
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
      builder: (context, state) => const Login(),
    ),
    GoRoute(
      path: '/makePost',
      builder: (context, state) => const MakePost(),
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
      // home: Login(),
    );
  }
}
