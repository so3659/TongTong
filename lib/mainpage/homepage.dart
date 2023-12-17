import 'package:flutter/material.dart';
import 'package:tongtong/Register/login.dart';
import 'package:tongtong/calendar/calendarMain.dart';
import 'package:tongtong/community/makePost.dart';
import 'package:tongtong/community/memoMainPage.dart';
import 'package:go_router/go_router.dart';
import 'package:tongtong/community/test.dart';
import 'package:tongtong/info/infoMain.dart';
import 'package:tongtong/mainpage/mainpage.dart';

// void main() => runApp(const HomePage());

final GoRouter _goroute = GoRouter(
  routes: <RouteBase>[
    GoRoute(path: '/', builder: (context, state) => const MyStatefulWidget()),
    GoRoute(
      path: '/mainpage',
      builder: (context, state) => const Mainpage(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const Login(),
    )
  ],
);

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'SunflowerMedium',
      ),
      routerConfig: _goroute,
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => MyStatefulWidgetState();
}

class MyStatefulWidgetState extends State<MyStatefulWidget> {
  final PageController _pageController = PageController();

  int _selectedIndex = 0;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  static const List<Widget> _widgetOptions = <Widget>[
    MyMemoPage(),
    InfoMain(),
    Calendar(),
    // Text(
    //   'Friends',
    //   style: optionStyle,
    // ),
    // Text(
    //   'My',
    //   style: optionStyle,
    // ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'SunflowerMedium',
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('통통')),
          actions: <Widget>[
            IconButton(
                onPressed: () {
                  context.go('/login');
                },
                icon: const Icon(Icons.settings))
          ],
        ),
        drawer: Drawer(
          child: Column(
            children: [
              const SizedBox(
                height: 200,
              ),
              Container(
                  width: 200,
                  height: 200,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/tong_logo.png'),
                      fit: BoxFit.cover,
                    ),
                  )),
              Container(
                  width: 200,
                  height: 100,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/tong_logo_name.png'),
                      fit: BoxFit.cover,
                    ),
                  )),
              Expanded(
                  child: Align(
                alignment: Alignment.bottomCenter,
                child: TextButton(
                  child: const Text(
                    '로그아웃',
                  ),
                  onPressed: () {
                    GoRouter.of(context).go('/login');
                  },
                ),
              ))
            ],
          ),
        ),
        body: PageView(
          controller: _pageController,
          children: <Widget>[
            Scaffold(
              body: Center(
                child: _widgetOptions.elementAt(_selectedIndex),
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
                  // BottomNavigationBarItem(
                  //   icon: Icon(Icons.people),
                  //   label: 'Friends',
                  // ),
                  // BottomNavigationBarItem(
                  //   icon: Icon(Icons.perm_identity),
                  //   label: 'My',
                  // ),
                ],
                currentIndex: _selectedIndex,
                selectedItemColor: Colors.lightBlue[200],
                backgroundColor: Colors.white,
                onTap: _onItemTapped,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _createDrawer() {
  return Drawer(
    child: Column(
      children: [
        const DrawerHeader(
          decoration: BoxDecoration(color: Colors.blue),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.person, color: Colors.white),
              Text("du.it.ddu",
                  style: TextStyle(color: Colors.white, fontSize: 16.0))
            ],
          ),
        ),
        _createFolderInDrawer("Flutter"),
        _createFolderInDrawer("Android"),
        _createFolderInDrawer("iOS"),
        _createFolderInDrawer("Something1"),
        const Expanded(
            child: Align(
          alignment: Alignment.bottomCenter,
          child: Text('Bottom'),
        ))
      ],
    ),
  );
}

Widget _createFolderInDrawer(String folderName) {
  return Container(
    padding: const EdgeInsets.all(8.0),
    child: Text(folderName),
  );
}
