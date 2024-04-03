import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tongtong/knowhow/knowhow_postBody.dart';
import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class Product {
  final String objectID;
  // final String uid;
  // final String name;
  // final String content;
  // final List<dynamic>? photoUrls;
  // final Timestamp dateTime;
  // final String documentId;
  // // final String currentUserId;
  // final bool anoym;
  // final int commentsCount;

  Product(
    this.objectID,
    // this.uid,
    // this.name,
    // this.content,
    // this.photoUrls,
    // this.dateTime,
    // this.documentId,
    // // this.currentUserId,
    // this.anoym,
    // this.commentsCount,
  );

  static Product fromJson(Map<String, dynamic> json) {
    return Product(
      json['objectID'],
      // json['uid'],
      // json['name'],
      // json['content'],
      // json['photoUrls'],
      // json['dateTime'],
      // json['documentId'],
      // json['anoym'],
      // json['commentsCount']
    );
  }
}

class HitsPage {
  const HitsPage(this.items, this.pageKey, this.nextPageKey);

  final List<Product> items;
  final int pageKey;
  final int? nextPageKey;

  factory HitsPage.fromResponse(SearchResponse response) {
    final items = response.hits.map(Product.fromJson).toList();
    final isLastPage = response.page >= response.nbPages;
    final nextPageKey = isLastPage ? null : response.page + 1;
    return HitsPage(items, response.page, nextPageKey);
  }
}

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  final TextEditingController _textEditingController = TextEditingController();
  Future<QuerySnapshot>? futureSearchResults;
  final searcher = HitsSearcher(
    applicationID: 'GZ9N2RJ1BA',
    apiKey: dotenv.get("PostAPI"),
    indexName: 'TongTong_Knowhow',
  );

  final PagingController<int, Product> _pagingController =
      PagingController(firstPageKey: 0);

  Stream<HitsPage> get _searchPage =>
      searcher.responses.map(HitsPage.fromResponse);

  @override
  void initState() {
    super.initState();
    _textEditingController.addListener(
      () => searcher.applyState(
        (state) => state.copyWith(
          query: _textEditingController.text,
          page: 0,
        ),
      ),
    );
    _searchPage.listen((page) {
      if (page.pageKey == 0) {
        _pagingController.refresh();
      }
      _pagingController.appendPage(page.items, page.nextPageKey);
    }).onError((error) => _pagingController.error = error);
    _pagingController.addPageRequestListener(
        (pageKey) => searcher.applyState((state) => state.copyWith(
              page: pageKey,
            )));
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    searcher.dispose();
    _pagingController.dispose();
    super.dispose();
  }

  controlSearching(str) {
    Future<QuerySnapshot> searchResults = FirebaseFirestore.instance
        .collection('Knowhow')
        .where('contents', isGreaterThanOrEqualTo: str)
        .where('contents', isLessThanOrEqualTo: str + '\uf8ff')
        .limit(10)
        .get();
    setState(() {
      futureSearchResults = searchResults;
    });
  }

  void showReplyDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: const Text(
              '현재 예산 문제로 인해 검색 시스템이 \n 완벽하지 않습니다. \n\n 중간에 끼어있는 문자열이나 뒤에 오는 문자열\n 대상으로 검색이 불가능합니다. \n\n ex) Guitar로 시작하는 문서가 있을경우 \n - Gui, Guir, Guitar으로 찾기 가능 \n - ui, uitar으로 찾기 불가능 \n\n 여러분의 후원이 더 좋은 통통 앱을 만듭니다 '),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('네'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('네'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Theme.of(context).primaryColor,
            size: 20,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _textEditingController.clear(),
            icon: Icon(
              Icons.cancel_outlined,
              color: Theme.of(context).primaryColor,
              size: 20,
            ),
          ),
        ],
        title: TextField(
          autofocus: true,
          controller: _textEditingController,

          style: const TextStyle(color: Colors.black, fontSize: 20),
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
            hintText: '검색어를 입력해주세요',
            // prefixIcon: Icon(Icons.search),
          ),
          // onChanged: searcher.query,
        ),
      ),
      body:
          // _textEditingController.text.isEmpty
          //     ? Container()
          //     :
          Column(
        children: <Widget>[
          Expanded(
            child: _hits(context), // Expanded를 올바르게 사용
          ),
        ],
      ),
    );
  }

  Widget _hits(BuildContext context) => PagedListView<int, Product>(
      pagingController: _pagingController,
      builderDelegate: PagedChildBuilderDelegate<Product>(
        noItemsFoundIndicatorBuilder: (_) => const Center(
          child: Text('해당 내용의 게시물이 없습니다'),
        ),
        itemBuilder: (_, item, __) {
          return FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('Knowhow')
                .doc(item.objectID)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.error != null) {
                return const Center(
                  child: Text('An error occurred'),
                );
              }
              if (!snapshot.hasData) {
                return const Center(
                  child: Text('해당 내용의 게시물이 없습니다'),
                );
              }
              Map<String, dynamic>? data = snapshot.data?.data();

              return _textEditingController.text.isEmpty
                  ? Container()
                  : (data != null && data['image'] != null)
                      ? (FeedPageBody(
                          uid: data['uid'],
                          name: data['name'],
                          content: data['contents'],
                          photoUrls: data['image'],
                          dateTime: data['dateTime'],
                          documentId: data['documentId'],
                          currentUserId: FirebaseAuth.instance.currentUser!.uid,
                          anoym: data['anoym'],
                          commentsCount: data['commentsCount'],
                        ))
                      : (FeedPageBody(
                          uid: data!['uid'],
                          name: data['name'],
                          content: data['contents'],
                          dateTime: data['dateTime'],
                          documentId: data['documentId'],
                          currentUserId: FirebaseAuth.instance.currentUser!.uid,
                          anoym: data['anoym'],
                          commentsCount: data['commentsCount'],
                        ));
            },
          );
        },
      ));
}
