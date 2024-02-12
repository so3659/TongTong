import 'package:flutter/material.dart';
import 'package:tongtong/community/makePost.dart';
import 'package:tongtong/community/postListProvider.dart';
import 'package:provider/provider.dart';
import 'package:tongtong/community/postBody.dart';
import 'package:tongtong/db/memoDB.dart';
import 'package:tongtong/helper/utility.dart';
import 'postDetailPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tongtong/theme/theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tongtong/widgets/customWidgets.dart';
import 'package:timeago/timeago.dart' as timeago;

class MyMemoPage extends StatefulWidget {
  const MyMemoPage({super.key});

  @override
  MyMemoState createState() => MyMemoState();
}

class MyMemoState extends State<MyMemoPage> {
  FirebaseFirestore posts = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: [
            Expanded(
              child: Builder(
                builder: (context) {
                  posts.collection("Posts").get().then(
                    (querySnapshot) {
                      print("Successfully completed");
                      if (querySnapshot.docs.isEmpty) {
                        print("Empty");
                        return const Center(
                          child: Text(
                            "표시할 게시물이 없어요",
                            style: TextStyle(fontSize: 20),
                          ),
                        );
                      } else {
                        print("Not Empty");
                        return ListView.builder(
                          itemCount: querySnapshot.docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              children: [
                                FeedPageBody(
                                    content: querySnapshot.docs[index]
                                        ['contents'])
                              ],
                            );
                          },
                        );
                      }
                    },
                    onError: (e) => print("Error completing: $e"),
                  );
                  return const Divider();
                },
              ),
            ),
          ],
        ),
        // 플로팅 액션 버튼
        floatingActionButton: _floatingActionButton(context));
  }
}

Widget _floatingActionButton(BuildContext context) {
  return FloatingActionButton(
    heroTag: 'MakePost',
    shape: const CircleBorder(),
    onPressed: () {
      Navigator.of(context, rootNavigator: true)
          .push(MaterialPageRoute(builder: (context) => const MakePost()));
    },
    child: customIcon(
      context,
      icon: AppIcon.fabTweet,
      isTwitterIcon: true,
      iconColor: Theme.of(context).colorScheme.onPrimary,
      size: 25,
    ),
  );
}
