import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tongtong/community/postBody.dart';
import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';

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
    indexName: 'TongTong',
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  controlSearching(str) {
    Future<QuerySnapshot> searchResults = FirebaseFirestore.instance
        .collection('Posts')
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
          // onChanged: (val) => searchTerm.state = val,
          style: const TextStyle(color: Colors.black, fontSize: 20),
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.black),
          ),
          onChanged: searcher.query,
        ),
      ),
      body: _textEditingController.text.isEmpty
          ? Container()
          : StreamBuilder<SearchResponse>(
              stream:
                  searcher.responses, // 4. Listen and display search results!
              builder: (context, snapshot) {
                print(snapshot);
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.error != null) {
                  return const Text('An error occurred');
                }
                if (!snapshot.hasData) {
                  return const Text('해당 내용의 게시물이 없습니다');
                }

                final response = snapshot.data;
                final hits = response?.hits.toList() ?? [];
                return ListView.builder(
                  itemCount: hits.length,
                  itemBuilder: (context, index) {
                    var post = hits[index];
                    return (post['image'] != null
                        ? (FeedPageBody(
                            uid: post['uid'],
                            name: post['name'],
                            content: post['contents'],
                            photoUrls: post['image'],
                            dateTime: post['dateTime'],
                            documentId: post['documentId'],
                            currentUserId:
                                FirebaseAuth.instance.currentUser!.uid,
                            anoym: post['anoym'],
                            commentsCount: post['commentsCount'],
                          ))
                        : (FeedPageBody(
                            uid: post['uid'],
                            name: post['name'],
                            content: post['contents'],
                            dateTime: post['dateTime'],
                            documentId: post['documentId'],
                            currentUserId:
                                FirebaseAuth.instance.currentUser!.uid,
                            anoym: post['anoym'],
                            commentsCount: post['commentsCount'],
                          )));
                  },
                );
              },
            ),
    );
  }
}

class DisplaySearchResult extends StatelessWidget {
  const DisplaySearchResult(
      {super.key, this.artistName, this.artDes, this.genre});
  final String? artDes;
  final String? artistName;
  final String? genre;

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Text(
        artDes ?? '',
        style: const TextStyle(color: Colors.black),
      ),
      Text(
        artistName ?? '',
        style: const TextStyle(color: Colors.black),
      ),
      Text(
        genre ?? '',
        style: const TextStyle(color: Colors.black),
      ),
      const Divider(color: Colors.black),
      const SizedBox(height: 20)
    ]);
  }
}
