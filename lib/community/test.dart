import 'package:flutter/material.dart';
import 'package:tongtong/theme/theme.dart';
import 'package:tongtong/widgets/customWidgets.dart';
import 'package:timeago/timeago.dart' as timeago;

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'SunflowerMedium',
      ),
      home: Scaffold(
        body: SafeArea(
            child: SizedBox(
          height: context.height,
          width: context.width,
          child: const FeedPageBody(),
        )),
      ),
    );
  }
}

class FeedPageBody extends StatelessWidget {
  const FeedPageBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              child: GestureDetector(
                onTap: () {},
                child: const CircleAvatar(
                  backgroundImage: AssetImage('assets/images/insta.png'),
                  radius: 35,
                ),
              ),
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 5),
                      child: const Text(
                        'name',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 19,
                        ),
                      ),
                    ),
                    const Text(
                      '15분전',
                      style: TextStyle(fontSize: 17, color: Colors.grey),
                    )
                  ],
                ),
                const Text('안녕하세요'),
                const Text('안녕하세요'),
                const Text('안녕하세요'),
                const Text('안녕하세요'),
                const Text('안녕하세요'),
                const Text('안녕하세요'),
                const Text('안녕하세요'),
                const Text('안녕하세요'),
                const Text('안녕하세요'),
                const Text('안녕하세요'),
                Container(
                  margin: const EdgeInsets.only(
                    top: 10,
                    right: 20,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      customIcon(context,
                          icon: AppIcon.reply, isTwitterIcon: true, size: 15),
                      customIcon(context,
                          icon: AppIcon.heartEmpty,
                          isTwitterIcon: true,
                          size: 15),
                    ],
                  ),
                )
              ],
            ))
          ],
        ),
        Divider(
          color: Colors.grey[200],
        ),
      ],
    );
  }
}
