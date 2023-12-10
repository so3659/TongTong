import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';
import 'package:tongtong/theme/theme.dart';
import 'package:tongtong/widgets/customWidgets.dart';
import 'package:go_router/go_router.dart';

final GoRouter _goroute = GoRouter(
  routes: <RouteBase>[
    GoRoute(path: '/', builder: (context, state) => const MakePost()),
  ],
);

class MakePostRouter extends StatelessWidget {
  const MakePostRouter({super.key});

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

class MakePost extends StatefulWidget {
  const MakePost({Key? key}) : super(key: key);

  @override
  State<MakePost> createState() => MakePostState();
}

class MakePostState extends State<MakePost> {
  void _onImageIconSelected(File file) {
    setState(() {
      _image = file;
    });
  }

  File? _image;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          fontFamily: 'SunflowerMedium',
          colorScheme:
              ColorScheme.fromSeed(seedColor: (Colors.lightBlue[200])!)),
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
            icon: const Icon(Icons.close),
            color: Colors.lightBlue[200],
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.send),
              color: Colors.lightBlue[200],
            )
          ],
        ),
        body: Stack(
          children: <Widget>[
            const SingleChildScrollView(),
            const Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'What\'s happening?',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 16),
                ),
                keyboardType: TextInputType.multiline,
                maxLines: null,
              ),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: (Colors.grey[200])!)),
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  child: Row(
                    children: <Widget>[
                      IconButton(
                          onPressed: () {},
                          icon: customIcon(context,
                              icon: AppIcon.image,
                              isTwitterIcon: true,
                              iconColor: Colors.lightBlue[200])),
                      IconButton(
                          onPressed: () {},
                          icon: customIcon(context,
                              icon: AppIcon.camera,
                              isTwitterIcon: true,
                              iconColor: Colors.lightBlue[200])),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
