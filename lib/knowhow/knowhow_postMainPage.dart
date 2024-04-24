import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:tongtong/knowhow/knowhow_hotPostsPage.dart';
import 'package:tongtong/knowhow/knowhow_makePost.dart';
import 'package:tongtong/knowhow/knowhow_postBody.dart';
import 'package:tongtong/knowhow/knowhow_searchPage.dart';
import 'package:tongtong/theme/theme.dart';
import 'package:tongtong/widgets/customWidgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class KnowhowPage extends StatefulWidget {
  const KnowhowPage({super.key});

  @override
  KnowhowState createState() => KnowhowState();
}

class KnowhowState extends State<KnowhowPage> {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  static const _pageSize = 10;
  final PagingController<DocumentSnapshot?, DocumentSnapshot>
      _pagingController = PagingController(firstPageKey: null);
  final Set<String> _blockedUsers = {};

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future<void> loadBlockedUsers() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    var doc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    List<dynamic> blocked = doc.data()?['blockList'] ?? [];
    setState(() {
      _blockedUsers.addAll(blocked.cast<String>());
    });
  }

  Future<void> _fetchPage(DocumentSnapshot? lastDocument) async {
    try {
      final query = fireStore
          .collection("Knowhow")
          .orderBy("dateTime", descending: true)
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

  Widget? floatingButtons() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      foregroundColor: Colors.white,
      visible: true,
      curve: Curves.bounceIn,
      backgroundColor: Colors.lightBlue[200],
      children: [
        SpeedDialChild(
            child: customIcon(
              context,
              icon: AppIcon.fabTweet,
              isTwitterIcon: true,
              iconColor: Theme.of(context).colorScheme.onPrimary,
              size: 25,
            ),
            label: "글 작성",
            labelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 13.0),
            backgroundColor: Colors.lightBlue[200],
            labelBackgroundColor: Colors.lightBlue[200],
            onTap: () {
              Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(builder: (context) => const MakeKnowhow()));
            }),
        SpeedDialChild(
          child: const Icon(
            Icons.search,
            color: Colors.white,
          ),
          label: "검색",
          backgroundColor: Colors.lightBlue[200],
          labelBackgroundColor: Colors.lightBlue[200],
          labelStyle: const TextStyle(
              fontWeight: FontWeight.w500, color: Colors.white, fontSize: 13.0),
          onTap: () {
            Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(builder: (context) => const SearchPage()));
          },
        ),
        SpeedDialChild(
            child: const Icon(Icons.local_fire_department, color: Colors.white),
            label: "최고의 노하우",
            labelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 13.0),
            backgroundColor: Colors.lightBlue[200],
            labelBackgroundColor: Colors.lightBlue[200],
            onTap: () {
              Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                  builder: (context) => const HotKnowhowPage()));
            }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          '기타 노하우',
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
        onRefresh: () => Future.sync(() {
          _pagingController.refresh();
          loadBlockedUsers();
        }),
        child: PagedListView<DocumentSnapshot?, DocumentSnapshot>(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<DocumentSnapshot>(
            itemBuilder: (context, item, index) {
              if (_blockedUsers.contains(item['uid'])) {
                return const SizedBox.shrink(); // 차단된 사용자의 게시물은 표시하지 않습니다.
              }
              return (item['image'] != null
                  ? item['avatarUrl'] == null
                      ? (KnowhowFeedPageBody(
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
                      : (KnowhowFeedPageBody(
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
                      ? (KnowhowFeedPageBody(
                          uid: item['uid'],
                          name: item['name'],
                          content: item['contents'],
                          dateTime: item['dateTime'],
                          documentId: item.id,
                          currentUserId: currentUserId,
                          anoym: item['anoym'],
                          commentsCount: item['commentsCount'],
                        ))
                      : (KnowhowFeedPageBody(
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
      ),
      floatingActionButton: floatingButtons(),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
