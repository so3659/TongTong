import 'package:flutter/material.dart';

class Mainpage extends StatefulWidget {
  const Mainpage({Key? key}) : super(key: key);

  @override
  State<Mainpage> createState() => MainpageState();
}

class MainpageState extends State<Mainpage> {
  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
        child: Column(
      children: [
        SizedBox(
          child: Image.asset('assets/images/tong_top_logo.png'),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                    child: SizedBox(
                      height: 130,
                      width: 150,
                      child: FloatingActionButton(
                        heroTag: 'insta',
                        backgroundColor: Colors.white,
                        onPressed: () {},
                        child: const ImageIcon(
                          AssetImage('assets/images/insta.png'),
                          size: 100,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      height: 230,
                      width: 150,
                      child: FloatingActionButton(
                        heroTag: 'booking',
                        backgroundColor: Colors.white,
                        onPressed: () {},
                        child: const ImageIcon(
                          AssetImage('assets/images/tong_logo.png'),
                          size: 100,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                    child: SizedBox(
                      height: 230,
                      width: 150,
                      child: FloatingActionButton(
                        heroTag: 'chat',
                        backgroundColor: Colors.white,
                        onPressed: () {},
                        child: const ImageIcon(
                          AssetImage('assets/images/tong_logo.png'),
                          size: 100,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      height: 130,
                      width: 150,
                      child: FloatingActionButton(
                        heroTag: 'navercafe',
                        backgroundColor: Colors.white,
                        onPressed: () {},
                        child: const ImageIcon(
                          AssetImage('assets/images/navercafe.png'),
                          size: 100,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ])
          ],
        )
      ],
    ));
  }
}
