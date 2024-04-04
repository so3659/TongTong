import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tongtong/community/postBody.dart';
import 'package:tongtong/knowhow/knowhow_postBody.dart';
import 'package:tongtong/lightning/lightning_postBody.dart';
import 'package:tongtong/practice_room/practice_postBody.dart';
import 'package:tongtong/repair/repair_postBody.dart';
import 'package:tongtong/restaurant/restaurant_postBody.dart';

class MyPosts extends StatefulWidget {
  const MyPosts({super.key});

  @override
  State<MyPosts> createState() => _MyPostsState();
}

class _MyPostsState extends State<MyPosts> {
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  List<Map<String, dynamic>> allPosts = [];

  @override
  void initState() {
    super.initState();
    fetchAllPosts();
  }

  Future<void> fetchAllPosts() async {
    List<String> collections = [
      'Posts',
      'Practices',
      'Restaurants',
      'Knowhow',
      'Repair',
      'Lightning'
    ];
    List<Map<String, dynamic>> fetchedPosts = [];

    for (String collection in collections) {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection(collection)
          .where('uid', isEqualTo: currentUserId)
          .get();

      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        // 각 문서에 컬렉션 이름을 추가하여 어느 컬렉션에서 왔는지 식별 가능
        data['collection'] = collection;
        fetchedPosts.add(data);
      }
    }

    // 시간 순서대로 정렬
    fetchedPosts.sort((a, b) => b['dateTime'].compareTo(a['dateTime']));

    if (mounted) {
      setState(() {
        allPosts = fetchedPosts;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold를 사용하여 화면의 구조를 정의
    return Scaffold(
        appBar: AppBar(
          title: Text(
            '내가 쓴 글',
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: Colors.black87),
          ),
          iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(0.0),
            child: Container(
              color: Colors.grey.shade200,
              height: 1.0,
            ),
          ), // 상단 앱 바에 표시될 타이틀 설정
        ),
        body: allPosts.isEmpty
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('아직 작성한 글이 없어요!'),
                    Text('글을 작성해보세요!'),
                  ],
                ),
              )
            : ListView.builder(
                // shrinkWrap: true,
                // physics: const NeverScrollableScrollPhysics(), // 중첩 스크롤 문제 방지
                itemCount: allPosts.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> item = allPosts[index];
                  switch (item['collection']) {
                    case 'Posts':
                      return (item['image'] != null
                          ? (FeedPageBody(
                              uid: item['uid'],
                              name: item['name'],
                              content: item['contents'],
                              photoUrls: item['image'],
                              dateTime: item['dateTime'],
                              documentId: item['documentId'],
                              currentUserId: currentUserId,
                              anoym: item['anoym'],
                              commentsCount: item['commentsCount'],
                              avatarUrl: item['avatarUrl']))
                          : (FeedPageBody(
                              uid: item['uid'],
                              name: item['name'],
                              content: item['contents'],
                              dateTime: item['dateTime'],
                              documentId: item['documentId'],
                              currentUserId: currentUserId,
                              anoym: item['anoym'],
                              commentsCount: item['commentsCount'],
                              avatarUrl: item['avatarUrl'])));
                    case 'Practices':
                      return (item['image'] != null
                          ? (PracticeFeedPageBody(
                              uid: item['uid'],
                              name: item['name'],
                              content: item['contents'],
                              photoUrls: item['image'],
                              dateTime: item['dateTime'],
                              documentId: item['documentId'],
                              currentUserId: currentUserId,
                              anoym: item['anoym'],
                              commentsCount: item['commentsCount'],
                              avatarUrl: item['avatarUrl']))
                          : (PracticeFeedPageBody(
                              uid: item['uid'],
                              name: item['name'],
                              content: item['contents'],
                              dateTime: item['dateTime'],
                              documentId: item['documentId'],
                              currentUserId: currentUserId,
                              anoym: item['anoym'],
                              commentsCount: item['commentsCount'],
                              avatarUrl: item['avatarUrl'])));
                    case 'Restaurants':
                      return (item['image'] != null
                          ? (RestaurantFeedPageBody(
                              uid: item['uid'],
                              name: item['name'],
                              content: item['contents'],
                              photoUrls: item['image'],
                              dateTime: item['dateTime'],
                              documentId: item['documentId'],
                              currentUserId: currentUserId,
                              anoym: item['anoym'],
                              commentsCount: item['commentsCount'],
                              avatarUrl: item['avatarUrl']))
                          : (RestaurantFeedPageBody(
                              uid: item['uid'],
                              name: item['name'],
                              content: item['contents'],
                              dateTime: item['dateTime'],
                              documentId: item['documentId'],
                              currentUserId: currentUserId,
                              anoym: item['anoym'],
                              commentsCount: item['commentsCount'],
                              avatarUrl: item['avatarUrl'])));
                    case 'Knowhow':
                      return (item['image'] != null
                          ? (KnowhowFeedPageBody(
                              uid: item['uid'],
                              name: item['name'],
                              content: item['contents'],
                              photoUrls: item['image'],
                              dateTime: item['dateTime'],
                              documentId: item['documentId'],
                              currentUserId: currentUserId,
                              anoym: item['anoym'],
                              commentsCount: item['commentsCount'],
                              avatarUrl: item['avatarUrl']))
                          : (RestaurantFeedPageBody(
                              uid: item['uid'],
                              name: item['name'],
                              content: item['contents'],
                              dateTime: item['dateTime'],
                              documentId: item['documentId'],
                              currentUserId: currentUserId,
                              anoym: item['anoym'],
                              commentsCount: item['commentsCount'],
                              avatarUrl: item['avatarUrl'])));
                    case 'Repair':
                      return (item['image'] != null
                          ? (RepairFeedPageBody(
                              uid: item['uid'],
                              name: item['name'],
                              content: item['contents'],
                              photoUrls: item['image'],
                              dateTime: item['dateTime'],
                              documentId: item['documentId'],
                              currentUserId: currentUserId,
                              anoym: item['anoym'],
                              commentsCount: item['commentsCount'],
                              avatarUrl: item['avatarUrl']))
                          : (RestaurantFeedPageBody(
                              uid: item['uid'],
                              name: item['name'],
                              content: item['contents'],
                              dateTime: item['dateTime'],
                              documentId: item['documentId'],
                              currentUserId: currentUserId,
                              anoym: item['anoym'],
                              commentsCount: item['commentsCount'],
                              avatarUrl: item['avatarUrl'])));
                    case 'Lightning':
                      return (item['image'] != null
                          ? (LightningFeedPageBody(
                              uid: item['uid'],
                              name: item['name'],
                              content: item['contents'],
                              photoUrls: item['image'],
                              dateTime: item['dateTime'],
                              documentId: item['documentId'],
                              currentUserId: currentUserId,
                              anoym: item['anoym'],
                              commentsCount: item['commentsCount'],
                              avatarUrl: item['avatarUrl']))
                          : (RestaurantFeedPageBody(
                              uid: item['uid'],
                              name: item['name'],
                              content: item['contents'],
                              dateTime: item['dateTime'],
                              documentId: item['documentId'],
                              currentUserId: currentUserId,
                              anoym: item['anoym'],
                              commentsCount: item['commentsCount'],
                              avatarUrl: item['avatarUrl'])));
                    default:
                      return Container(); // 기본값
                  }
                },
              ));
  }
}
