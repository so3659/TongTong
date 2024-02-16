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
  List<DocumentSnapshot> _documents = [];
  final ScrollController _scrollController = ScrollController();
  bool _isFetchingMore = false;
  bool _hasMoreData = true;
  DocumentSnapshot? _lastDocument;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _scrollController.addListener(_loadMoreDataIfNeeded);
  }

  Future<void> _loadInitialData() async {
    QuerySnapshot snapshot =
        await fireStore.collection("Posts").limit(10).get();
    if (snapshot.docs.isEmpty) {
      _hasMoreData = false; // 더 이상 로드할 데이터가 없음
    } else {
      _documents = snapshot.docs;
      _lastDocument = _documents.last;
    }
    setState(() {}); // 상태 업데이트하여 UI 갱신
  }

  void _loadMoreDataIfNeeded() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent &&
        !_isFetchingMore &&
        _hasMoreData) {
      _loadMoreData();
    }
  }

  Future<void> _loadMoreData() async {
    if (_isFetchingMore || !_hasMoreData) return;

    setState(() {
      _isFetchingMore = true;
    });

    QuerySnapshot snapshot;
    // 마지막 문서가 있다면, 그 문서 이후의 데이터를 로드합니다.
    if (_lastDocument != null) {
      snapshot = await fireStore
          .collection("Posts")
          .startAfterDocument(_lastDocument!)
          .limit(10)
          .get();
    } else {
      // _lastDocument가 null이라면, 초기 데이터 로드를 의미합니다.
      snapshot = await fireStore.collection("Posts").limit(10).get();
    }

    // 새로운 데이터가 있으면, 기존 데이터 리스트에 추가합니다.
    if (snapshot.docs.isNotEmpty) {
      _lastDocument = snapshot.docs.last;
      _documents.addAll(snapshot.docs);
      _hasMoreData =
          snapshot.docs.length == 10; // 10개 미만이 로드되면 더 이상 데이터가 없는 것으로 간주
    } else {
      _hasMoreData = false;
    }

    setState(() {
      _isFetchingMore = false;
    });
  }

  Future<void> refreshPosts() async {
    // 새로고침 로직. 기존 데이터를 유지하고 싶다면 이 부분을 수정합니다.
    DocumentSnapshot? firstDocument =
        _documents.isNotEmpty ? _documents.first : null;

    // 새로고침을 통해 가장 최신 데이터를 가져오되, 기존 데이터는 유지합니다.
    QuerySnapshot newSnapshot = await fireStore
        .collection("Posts")
        .orderBy('dateTime', descending: true) // timestamp 필드를 기준으로 내림차순 정렬 가정
        .startAfter([firstDocument?['dateTime']])
        .limit(10)
        .get();

    // 새로운 데이터를 기존 데이터 앞에 추가합니다.
    if (newSnapshot.docs.isNotEmpty) {
      setState(() {
        _documents.insertAll(0, newSnapshot.docs);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: refreshPosts,
        child: _documents.isEmpty && !_isFetchingMore
            ? const Center(
                child: Text("표시할 게시물이 없어요", style: TextStyle(fontSize: 20)))
            : ListView.builder(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: _documents.length + (_hasMoreData ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _documents.length) {
                    // 마지막 아이템일 경우 로딩 인디케이터를 표시
                    return _hasMoreData
                        ? const Center(child: CircularProgressIndicator())
                        : Container();
                  }
                  var doc = _documents[index];
                  if (doc['image'] != null) {
                    return Column(
                      children: [
                        FeedPageBody(
                            uid: doc['uid'],
                            content: doc['contents'],
                            photoUrl: doc['image'],
                            dateTime: doc['dateTime'])
                      ],
                    );
                  } else if (doc['image'] == null) {
                    return Column(
                      children: [
                        FeedPageBody(
                            uid: doc['uid'],
                            content: doc['contents'],
                            dateTime: doc['dateTime'])
                      ],
                    );
                  }
                  return null;
                },
              ),
      ),
      floatingActionButton: _floatingActionButton(context),
    );
  }

  @override
  void dispose() {
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
