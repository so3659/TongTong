import 'package:flutter/material.dart';
import 'package:tongtong/theme/theme.dart';
import 'package:tongtong/parameter/postParameter.dart';
import 'package:tongtong/community/postDetailPageBody.dart';

class PostDetailPage extends StatefulWidget {
  final FeedPost post;
  const PostDetailPage({super.key, required this.post});

  @override
  State<PostDetailPage> createState() => PostDetailPageState();
}

class PostDetailPageState extends State<PostDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
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
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const SizedBox(
                  height: 6,
                  width: double.infinity,
                ),
                widget.post.photoUrls != null
                    ? FeedDetailPageBody(
                        uid: widget.post.uid,
                        content: widget.post.content,
                        photoUrls: widget.post.photoUrls,
                        dateTime: widget.post.dateTime,
                        documentId: widget.post.documentId,
                        currentUserId: widget.post.currentUserId,
                      )
                    : FeedDetailPageBody(
                        uid: widget.post.uid,
                        content: widget.post.content,
                        dateTime: widget.post.dateTime,
                        documentId: widget.post.documentId,
                        currentUserId: widget.post.currentUserId,
                      ),
                Container(
                  height: 6,
                  width: double.infinity,
                  color: TwitterColor.mystic,
                )
              ],
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              //!Removed container
              const Center()
            ]),
          )
        ],
      ),
    );
  }
}
