import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tongtong/community/postBody.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  final TextEditingController _textEditingController = TextEditingController();
  Future<QuerySnapshot>? futureSearchResults;

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
          onSubmitted: controlSearching,
        ),
      ),
      body: _textEditingController.text.isEmpty
          ? Container()
          : FutureBuilder(
              future: futureSearchResults,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.error != null) {
                  return const Text('An error occurred');
                }
                if (!snapshot.hasData) {
                  return const Text('해당 내용의 게시물이 없습니다');
                }

                var documents = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    var post = documents[index];
                    return (post['image'] != null
                        ? (FeedPageBody(
                            uid: post['uid'],
                            content: post['contents'],
                            photoUrls: post['image'],
                            dateTime: post['dateTime'],
                            documentId: post.id,
                            currentUserId:
                                FirebaseAuth.instance.currentUser!.uid,
                          ))
                        : (FeedPageBody(
                            uid: post['uid'],
                            content: post['contents'],
                            dateTime: post['dateTime'],
                            documentId: post.id,
                            currentUserId:
                                FirebaseAuth.instance.currentUser!.uid,
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
