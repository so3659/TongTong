import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:tongtong/practice_room/practice_postBody.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HotPracticePage extends ConsumerStatefulWidget {
  const HotPracticePage({super.key});

  @override
  HotPracticePageState createState() => HotPracticePageState();
}

class HotPracticePageState extends ConsumerState<HotPracticePage> {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  static const _pageSize = 10;
  final PagingController<DocumentSnapshot?, DocumentSnapshot>
      _pagingController = PagingController(firstPageKey: null);

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future<void> _fetchPage(DocumentSnapshot? lastDocument) async {
    try {
      final query = fireStore
          .collection("Practices")
          .where("likesCount", isGreaterThanOrEqualTo: 10)
          .limit(_pageSize);

      final snapshot = lastDocument == null
          ? await query.get()
          : await query.startAfterDocument(lastDocument).get();

      await Future.delayed(const Duration(seconds: 1));

      final isLastPage = snapshot.docs.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(snapshot.docs);
      } else {
        final nextPageKey = snapshot.docs.last;
        _pagingController.appendPage(snapshot.docs, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          '최고의 연습실',
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
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => Future.sync(
          () => _pagingController.refresh(),
        ),
        child: CustomScrollView(
          slivers: <Widget>[
            PagedSliverList<DocumentSnapshot?, DocumentSnapshot>(
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate<DocumentSnapshot>(
                itemBuilder: (context, item, index) {
                  return (item['image'] != null
                      ? item['avatarUrl'] == null
                          ? (PracticeFeedPageBody(
                              uid: item['uid'],
                              name: item['name'],
                              content: item['contents'],
                              photoUrls: item['image'],
                              dateTime: item['dateTime'],
                              documentId: item.id,
                              currentUserId: currentUserId,
                              anoym: item['anoym'],
                              commentsCount: item['commentsCount'],
                            ))
                          : (PracticeFeedPageBody(
                              uid: item['uid'],
                              name: item['name'],
                              content: item['contents'],
                              photoUrls: item['image'],
                              dateTime: item['dateTime'],
                              documentId: item.id,
                              currentUserId: currentUserId,
                              anoym: item['anoym'],
                              commentsCount: item['commentsCount'],
                              avatarUrl: item['avatarUrl'],
                            ))
                      : item['avatarUrl'] == null
                          ? (PracticeFeedPageBody(
                              uid: item['uid'],
                              name: item['name'],
                              content: item['contents'],
                              dateTime: item['dateTime'],
                              documentId: item.id,
                              currentUserId: currentUserId,
                              anoym: item['anoym'],
                              commentsCount: item['commentsCount'],
                            ))
                          : (PracticeFeedPageBody(
                              uid: item['uid'],
                              name: item['name'],
                              content: item['contents'],
                              dateTime: item['dateTime'],
                              documentId: item.id,
                              currentUserId: currentUserId,
                              anoym: item['anoym'],
                              commentsCount: item['commentsCount'],
                              avatarUrl: item['avatarUrl'],
                            )));
                },
                noItemsFoundIndicatorBuilder: (context) => const Center(
                  child: Text("표시할 게시물이 없어요", style: TextStyle(fontSize: 20)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
