import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tongtong/calendar/calendarMain.dart';
import 'package:tongtong/community/postMainPage.dart';
import 'package:tongtong/community/postBody.dart';
import 'package:tongtong/info/infoMain.dart';
import 'package:tongtong/mainpage/mainpage.dart';
import 'package:tongtong/community/comment_list_body.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();

  int _selectedIndex = 0;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  static const List<Widget> _widgetOptions = <Widget>[
    Mainpage(),
    InfoMain(),
    Calendar(),
    Text(
      'My',
      style: optionStyle,
    ),
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

  void signOut() async {
    await GoogleSignIn().signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('통통')),
        actions: <Widget>[
          IconButton(onPressed: () {}, icon: const Icon(Icons.settings))
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
                  signOut();
                  GoRouter.of(context).go('/login');
                },
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
