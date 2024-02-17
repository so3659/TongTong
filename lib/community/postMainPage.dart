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
  final List<DocumentSnapshot> _documents = [];
  final ScrollController _scrollController = ScrollController();
  bool _isFetchingMore = false;
  bool _hasMoreData = true;
  DocumentSnapshot? _lastDocument;
  late Future<QuerySnapshot> postsFuture;

  @override
  void initState() {
    super.initState();
    // 스크롤 이벤트 리스너를 추가합니다.
    _scrollController.addListener(_onScroll);
  }

  // 스크롤 리스너 메서드
  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent &&
        !_isFetchingMore) {
      // 스크롤이 최하단에 도달하면 추가 데이터 로드를 시도합니다.
      _loadMoreData();
    }
  }

  Future<void> _loadMoreData() async {
    // 로딩 상태 확인
    if (_isFetchingMore) return;

    // 로딩 상태를 true로 설정하여 로딩 인디케이터를 표시합니다.
    setState(() {
      _isFetchingMore = true;
    });

    // 마지막 문서 다음의 데이터를 로드합니다.
    QuerySnapshot snapshot = await fireStore
        .collection("Posts")
        .startAfterDocument(_lastDocument!)
        .limit(10)
        .get();

    // 새로운 데이터가 있으면 리스트에 추가합니다.
    if (snapshot.docs.isNotEmpty) {
      _lastDocument = snapshot.docs.last;
      setState(() {
        _documents.addAll(snapshot.docs);
        _isFetchingMore = false; // 로딩 상태를 false로 설정합니다.
        _hasMoreData = snapshot.docs.length == 10; // 추가 데이터가 더 있는지 확인합니다.
      });
    } else {
      setState(() {
        _hasMoreData = false; // 더 이상 데이터가 없음을 설정합니다.
        _isFetchingMore = false;
      });
    }
  }

  Future<void> _refreshPosts() async {
    setState(() {
      // Firestore에서 새 데이터를 가져오기 위한 새 Future를 할당합니다.
      postsFuture = fireStore
          .collection("Posts")
          .orderBy("dateTime", descending: true)
          .get();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshPosts,
        child: StreamBuilder<QuerySnapshot>(
          stream: fireStore
              .collection("Posts")
              .orderBy("dateTime", descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text("오류가 발생했습니다."));
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                  child: Text("표시할 게시물이 없어요", style: TextStyle(fontSize: 20)));
            }

            List<DocumentSnapshot> documents = snapshot.data!.docs;

            return ListView.builder(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: documents.length,
              itemBuilder: (context, index) {
                var doc = documents[index];
                if (doc['image'] != null) {
                  return FeedPageBody(
                      uid: doc['uid'],
                      content: doc['contents'],
                      photoUrl: doc['image'],
                      dateTime: doc['dateTime']);
                } else if (doc['image'] == null) {
                  return FeedPageBody(
                      uid: doc['uid'],
                      content: doc['contents'],
                      dateTime: doc['dateTime']);
                }
                return null;
              },
            );
          },
        ),
      ),
      floatingActionButton: _floatingActionButton(context),
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll); // 리스너를 제거합니다.
    _scrollController.dispose();
    super.dispose();
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
