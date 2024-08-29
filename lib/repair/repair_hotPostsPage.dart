import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:tongtong/repair/repair_postBody.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HotRepairPage extends ConsumerStatefulWidget {
  const HotRepairPage({super.key});

  @override
  HotRepairPageState createState() => HotRepairPageState();
}

class HotRepairPageState extends ConsumerState<HotRepairPage> {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  static const _pageSize = 10;
  final PagingController<DocumentSnapshot?, DocumentSnapshot>
      _pagingController = PagingController(firstPageKey: null);
  final Set<String> _blockedUsers = {};
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });

    loadBlockedUsers();
  }

  Future<void> _fetchPage(DocumentSnapshot? lastDocument) async {
    try {
      final query = fireStore
          .collection("Repair")
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

  Future<void> loadBlockedUsers() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    var doc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    List<dynamic> blocked = doc.data()?['blockList'] ?? [];

    setState(() {
      _blockedUsers.addAll(blocked.cast<String>());
    });
  }

  Future<void> _refreshPage() async {
    final scrollPosition = _scrollController.position.pixels;
    _pagingController.refresh();
    loadBlockedUsers();
    // 리프레시 후 스크롤 위치 복원
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(scrollPosition);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          '대박 수리점',
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
        onRefresh: _refreshPage,
        child: PagedListView<DocumentSnapshot?, DocumentSnapshot>(
          pagingController: _pagingController,
          physics: const ClampingScrollPhysics(),
          scrollController: _scrollController,
          builderDelegate: PagedChildBuilderDelegate<DocumentSnapshot>(
            itemBuilder: (context, item, index) {
              if (_blockedUsers.contains(item['uid'])) {
                return const SizedBox.shrink(); // 차단된 사용자의 게시물은 표시하지 않습니다.
              }
              return RepairFeedPageBody(
                uid: item['uid'],
                name: item['name'],
                content: item['contents'],
                photoUrls: item['image'],
                dateTime: item['dateTime'],
                documentId: item.id,
                currentUserId: currentUserId,
                anoym: item['anoym'],
                commentsCount: item['commentsCount'],
                avatarUrl: item['avatarUrl'], // avatarUrl이 null인 경우 null을 전달
              );
            },
            noItemsFoundIndicatorBuilder: (context) => const Center(
              child: Text("표시할 게시물이 없어요", style: TextStyle(fontSize: 20)),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
