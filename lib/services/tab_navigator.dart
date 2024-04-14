import 'package:flutter/material.dart';
import 'package:tongtong/calendar/calendarMain.dart';
import 'package:tongtong/info/infoMain.dart';
import 'package:tongtong/mainpage/mainpage.dart';

class TabNavigatorRoutes {
  static const String root = '/';
  static const String detail = '/detail';
}

class TabNavigator extends StatelessWidget {
  const TabNavigator(
      {super.key, required this.navigatorKey, required this.tabItem});
  final GlobalKey<NavigatorState> navigatorKey;
  final String tabItem;

  @override
  Widget build(BuildContext context) {
    late Widget child;
    if (tabItem == "Home") {
      child = const Mainpage();
    } else if (tabItem == "Info")
      child = const InfoMain();
    else if (tabItem == "Calendar")
      child = const Calendar();
    else if (tabItem == "Friends")
      child = const Text('Friends');
    else if (tabItem == "My") child = const Text('M?y');

    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(builder: (context) => child);
      },
    );
  }
}
