import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:tongtong/calendar/calendarMain.dart';
import 'package:tongtong/community/memoMainPage.dart';
import 'package:tongtong/community/postBody.dart';
import 'package:tongtong/info/infoMain.dart';
import 'package:tongtong/mainpage/mainpage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();

  int _selectedIndex = 0;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  static const List<Widget> _widgetOptions = <Widget>[
<<<<<<< HEAD
    Mainpage(),
    InfoMain(),
    Calendar(),
    Text(
      'Friends',
      style: optionStyle,
    ),
    Text(
      'My',
      style: optionStyle,
    ),
=======
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
>>>>>>> 97ca06a09e6687d7ffc036fe4aaf3af2cfaf7503
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
    // return MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   theme: ThemeData(
    //     fontFamily: 'SunflowerMedium',
    //   ),
    //   home:
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('통통')),
        actions: <Widget>[
          IconButton(onPressed: () {}, icon: const Icon(Icons.settings))
        ],
      ),
<<<<<<< HEAD
      drawer: Drawer(
        child: Column(
          children: [
            const SizedBox(
              height: 200,
=======
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
>>>>>>> 97ca06a09e6687d7ffc036fe4aaf3af2cfaf7503
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
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Friends',
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

// Widget _createDrawer() {
//   return Drawer(
//     child: Column(
//       children: [
//         const SizedBox(
//           height: 200,
//         ),
//         Container(
//             width: 200,
//             height: 200,
//             decoration: const BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage('assets/images/tong_logo.png'),
//                 fit: BoxFit.cover,
//               ),
//             )),
//         Container(
//             width: 200,
//             height: 100,
//             decoration: const BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage('assets/images/tong_logo_name.png'),
//                 fit: BoxFit.cover,
//               ),
//             )),
//         Expanded(
//             child: Align(
//           alignment: Alignment.bottomCenter,
//           child: TextButton('로그아웃',
//           onPressed: (){GoRouter.of(context).go('/login');},),
//         ))
//       ],
//     ),
//   );
// }

Widget _createFolderInDrawer(String folderName) {
  return Container(
    padding: const EdgeInsets.all(8.0),
    child: Text(folderName),
  );
}
