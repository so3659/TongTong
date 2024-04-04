import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tongtong/community/postBody.dart';
import 'package:tongtong/knowhow/knowhow_postBody.dart';
import 'package:tongtong/lightning/lightning_postBody.dart';
import 'package:tongtong/practice_room/practice_postBody.dart';
import 'package:tongtong/repair/repair_postBody.dart';
import 'package:tongtong/restaurant/restaurant_postBody.dart';

class MyComments extends StatefulWidget {
  const MyComments({super.key});

  @override
  State<MyComments> createState() => _MyCommentsmentState();
}

class _MyCommentsmentState extends State<MyComments> {
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  List<Map<String, dynamic>> postsWithMyComments = [];

  @override
  void initState() {
    super.initState();
    fetchPostsWithMyComments();
  }

  Future<void> fetchPostsWithMyComments() async {
    List<String> collections = [
      'Posts',
      'Practices',
      'Restaurants',
      'Knowhow',
      'Repair',
      'Lightning'
    ];

    Set<String> postDocumentIds = {};

    for (String collection in collections) {
      // 댓글에서 현재 사용자가 작성한 항목 검색
      QuerySnapshot commentsSnapshot = await FirebaseFirestore.instance
          .collectionGroup('comments')
          .where('uid', isEqualTo: currentUserId)
          .get();

      // 대댓글에서 현재 사용자가 작성한 항목 검색
      QuerySnapshot repliesSnapshot = await FirebaseFirestore.instance
          .collectionGroup('Replies')
          .where('uid', isEqualTo: currentUserId)
          .get();

      // 댓글과 대댓글에서 얻은 게시물 ID를 저장
      for (var doc in commentsSnapshot.docs) {
        postDocumentIds.add(doc['postId']);
      }
      for (var doc in repliesSnapshot.docs) {
        postDocumentIds.add(doc['postId']);
      }
    }

    // 저장된 게시물 ID를 사용하여 게시물 정보 검색
    List<Map<String, dynamic>> fetchedPosts = [];

    for (String postId in postDocumentIds) {
      for (String collection in collections) {
        DocumentSnapshot postSnapshot = await FirebaseFirestore.instance
            .collection(collection)
            .doc(postId)
            .get();

        if (postSnapshot.exists) {
          Map<String, dynamic> postData =
              postSnapshot.data() as Map<String, dynamic>;
          postData['collection'] = collection; // 어느 컬렉션에서 왔는지 식별
          fetchedPosts.add(postData);
        }
      }
    }

    // 시간 순서대로 정렬
    fetchedPosts.sort((a, b) => b['dateTime'].compareTo(a['dateTime']));
    if (mounted) {
      setState(() {
        postsWithMyComments = fetchedPosts;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold를 사용하여 화면의 구조를 정의
    return Scaffold(
        appBar: AppBar(
          title: Text(
            '댓글 단 글',
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
        body: postsWithMyComments.isEmpty
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('아직 작성한 댓글이 없어요!'),
                    Text('댓글을 작성해보세요!'),
                  ],
                ),
              )
            : ListView.builder(
                // shrinkWrap: true,
                // physics: const NeverScrollableScrollPhysics(), // 중첩 스크롤 문제 방지
                itemCount: postsWithMyComments.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> item = postsWithMyComments[index];
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
