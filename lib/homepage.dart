import 'package:flutter/material.dart';
import 'package:tongtong/mainpage.dart';
import 'package:go_router/go_router.dart';

final GoRouter _goroute = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/mainpage',
      builder: (context, state) => Mainpage(),
    )
  ],
);

void main() => runApp(const Homepage());

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'SunflowerMedium',
      ),
      home: const NavigationExample(),
    );
  }
}

class NavigationExample extends StatefulWidget {
  const NavigationExample({super.key});

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: Center(child: Text('통통')),
        actions: <Widget>[
          IconButton(onPressed: () {}, icon: Icon(Icons.settings))
        ],
      ),
      drawer: _createDrawer(),
      floatingActionButton: SizedBox(
          height: 80,
          width: 80,
          child: FittedBox(
            child: FloatingActionButton.large(
              heroTag: 'home',
              backgroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
              onPressed: () {
                context.go('/mainpage');
              },
              tooltip: 'Home',
              elevation: 4.0,
              child: const ImageIcon(
                AssetImage('assets/images/tong_logo.png'),
                size: 70,
              ),
            ),
          )),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        backgroundColor: Colors.white,
        indicatorColor: Colors.lightBlue[150],
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.info_rounded),
            icon: Icon(Icons.info_outline_rounded),
            label: 'Info',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.calendar_month_rounded),
            icon: Icon(Icons.calendar_month_outlined),
            label: 'Calender',
          ),
          SizedBox(child: Text('')),
          NavigationDestination(
            selectedIcon: Icon(Icons.people_rounded),
            icon: Icon(Icons.people_outline),
            label: 'Friends',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.face_3),
            icon: Icon(
              Icons.face,
            ),
            label: 'My',
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: <Widget>[
        /// Home page
        new Mainpage(),

        /// Home page
        Container(
          margin: const EdgeInsets.all(8.0),
          child: SizedBox.expand(
            child: Center(
              child: Text(
                'Home page',
              ),
            ),
          ),
        ),

        Card(
          shadowColor: Colors.transparent,
          margin: const EdgeInsets.all(8.0),
          child: SizedBox.expand(
            child: Center(
              child: Text(
                'Home page',
              ),
            ),
          ),
        ),

        /// Notifications page
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Card(
                child: ListTile(
                  leading: Icon(Icons.notifications_sharp),
                  title: Text('Notification 1'),
                  subtitle: Text('This is a notification'),
                ),
              ),
              Card(
                child: ListTile(
                  leading: Icon(Icons.notifications_sharp),
                  title: Text('Notification 2'),
                  subtitle: Text('This is a notification'),
                ),
              ),
            ],
          ),
        ),

        /// Messages page
        ListView.builder(
          reverse: true,
          itemCount: 2,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return Align(
                alignment: Alignment.centerRight,
                child: Container(
                  margin: const EdgeInsets.all(8.0),
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    'Hello',
                  ),
                ),
              );
            }
            return Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.all(8.0),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  'Hi!',
                ),
              ),
            );
          },
        ),
      ][currentPageIndex],
    ));
  }
}

Widget _createDrawer() {
  return Drawer(
    child: ListView(
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
      ],
    ),
  );
}

Widget _createFolderInDrawer(String folderName) {
  return Container(
    padding: EdgeInsets.all(8.0),
    child: Text(folderName),
  );
}
