import 'package:flutter/material.dart';
import 'package:tongtong/community/makePost.dart';
import 'package:tongtong/community/postBody.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tongtong/theme/theme.dart';
import 'package:tongtong/widgets/customWidgets.dart';

class MyMemoPage extends StatefulWidget {
  const MyMemoPage({super.key});

  @override
  MyMemoState createState() => MyMemoState();
}

class MyMemoState extends State<MyMemoPage> {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  late Future<QuerySnapshot> postsFuture;

  @override
  void initState() {
    super.initState();
    postsFuture = fireStore.collection("Posts").get(); // 초기 데이터 로드
  }

  Future<void> refreshPosts() async {
    setState(() {
      // Firestore에서 새 데이터를 가져오기 위한 새 Future를 할당합니다.
      postsFuture = fireStore.collection("Posts").get();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh:
            refreshPosts, // RefreshIndicator의 onRefresh에 refreshPosts 함수를 할당합니다.
        child: FutureBuilder<QuerySnapshot>(
          future: postsFuture, // FutureBuilder에 postsFuture를 사용합니다.
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const Center(child: Text("오류가 발생했습니다."));
            }

            if (snapshot.data?.docs.isEmpty ?? true) {
              return const Center(
                  child: Text("표시할 게시물이 없어요", style: TextStyle(fontSize: 20)));
            }

            return ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var doc = snapshot.data!.docs[index];
                return Column(
                  children: [FeedPageBody(content: doc['contents'])],
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: _floatingActionButton(context),
    );
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
