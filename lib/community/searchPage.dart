import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
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
        ),
      ),
      // body: _textEditingController.text.isEmpty
      //     ? Center(child: Text(LocaleKeys.enterSearchTerm.tr()))
      //     : StreamBuilder<List<AlgoliaObjectSnapshot>>(
      //         stream: Stream.fromFuture(_operation(searchTerm.state)),
      //         builder: (context, snapshot) {
      //           final List<AlgoliaObjectSnapshot>? currSearchStuff =
      //               snapshot.data;
      //           return CustomScrollView(
      //             shrinkWrap: true,
      //             slivers: [
      //               SliverList(
      //                 delegate: SliverChildBuilderDelegate(
      //                   (context, i) {
      //                     final post = Post(
      //                       title: currSearchStuff?[i].data['title'] as String,
      //                       content:
      //                           currSearchStuff?[i].data['content'] as String,
      //                       userId:
      //                           currSearchStuff?[i].data['userId'] as String,
      //                       id: currSearchStuff?[i].data['id'] as String,
      //                       timestamp: DateTime.parse(
      //                         currSearchStuff?[i].data['timestamp'] as String,
      //                       ),
      //                       commentCount:
      //                           currSearchStuff?[i].data['commentCount'] as int,
      //                       userDisplayName: currSearchStuff?[i]
      //                           .data['userDisplayName'] as String,
      //                     );
      //                     if (searchTerm.state.isNotEmpty) {
      //                       return Padding(
      //                         padding: const EdgeInsets.all(defaultPadding),
      //                         child: GestureDetector(
      //                           onTap: () => PostDetailPage.show(context,
      //                               postId: post.id),
      //                           child: Column(
      //                             children: [
      //                               PostUserInfo(post: post),
      //                               PostItemInfo(post: post),
      //                             ],
      //                           ),
      //                         ),
      //                       );
      //                     } else {
      //                       return const SizedBox();
      //                     }
      //                   },
      //                   childCount: currSearchStuff?.length ?? 0,
      //                 ),
      //               ),
      //             ],
      //           );
      //         },
      //       ),
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
