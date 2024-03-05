import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tongtong/parameter/postParameter.dart';
import 'package:tongtong/community/postDetailPageBody.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';
import 'package:tongtong/community/comment_list_body.dart';
import 'package:tongtong/community/reply_list_body.dart';

class PostDetailPage extends ConsumerStatefulWidget {
  final FeedPost post;
  const PostDetailPage({super.key, required this.post});

  @override
  PostDetailPageState createState() => PostDetailPageState();
}

class PostDetailPageState extends ConsumerState<PostDetailPage> {
  final String _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random();
  final FocusNode _focusNode = FocusNode();
  String? _replyingToCommentId;

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  Future<void> addComment(
      String postId, String commentId, String content) async {
    DocumentReference postRef =
        FirebaseFirestore.instance.collection('Posts').doc(postId);

    CollectionReference commentsRef = postRef.collection('comments');

    await commentsRef.doc(commentId).set({
      'uid': FirebaseAuth.instance.currentUser!.uid,
      'content': content,
      'dateTime': Timestamp.now(),
      'postId': postId,
      'commentId': commentId,
      'likedBy': [],
    });
  }

  Future<void> addReplyToComment(
      String postId, String commentId, String replyContent) async {
    DocumentReference commentRef = FirebaseFirestore.instance
        .collection('Posts')
        .doc(widget.post.documentId) // 게시글 ID
        .collection('comments')
        .doc(commentId);

    String replyId = getRandomString(16); // Unique ID

    // 대댓글 추가 로직
    await commentRef.collection('Replies').doc(replyId).set({
      'uid': FirebaseAuth.instance.currentUser!.uid,
      'content': replyContent,
      'dateTime': Timestamp.now(),
      'postId': postId,
      'commentId': commentId,
      'replyId': replyId,
      'likedBy': [],
    });

    // UI 업데이트 등의 후속 처리
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final focusManager = ref.watch(focusManagerProvider);
      final currentReplyingCommentId = ref.watch(replyProvider);

      final TextEditingController contents = TextEditingController();
      String commentId = getRandomString(16); // Unique ID
      void startReplyingToComment(String commentId) {
        _replyingToCommentId = commentId; // 대댓글을 달 댓글의 ID를 저장
      }

      if (focusManager.shouldFocusCommentField) {
        startReplyingToComment(currentReplyingCommentId!);
        // 포커스 요청이 있으면 포커스를 주고 상태를 리셋
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _focusNode.requestFocus();
          ref.read(focusManagerProvider).resetFocusRequest();
        });
      }
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    pinned: true,
                    title: Text(
                      'Main',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(color: Colors.black87),
                    ),
                    iconTheme:
                        IconThemeData(color: Theme.of(context).primaryColor),
                    backgroundColor:
                        Theme.of(context).appBarTheme.backgroundColor,
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
                      ],
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('Posts')
                              .doc(widget.post.documentId)
                              .collection('comments')
                              .orderBy('dateTime', descending: false)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            if (snapshot.hasError) {
                              return const Center(
                                  child: Text('댓글을 불러오는데 문제가 발생했습니다.'));
                            }
                            if (!snapshot.hasData ||
                                snapshot.data!.docs.isEmpty) {
                              return const Center(child: Text('댓글이 없습니다.'));
                            }
                            return ListView.builder(
                              shrinkWrap: true,
                              physics:
                                  const NeverScrollableScrollPhysics(), // 스크롤 중첩 문제 방지
                              itemCount:
                                  snapshot.data!.docs.length, // 리스트에 있는 항목의 수
                              itemBuilder: (context, index) {
                                // 각 항목을 어떻게 빌드할지 정의
                                DocumentSnapshot document =
                                    snapshot.data!.docs[index];
                                Map<String, dynamic> comment =
                                    document.data() as Map<String, dynamic>;

                                return CommentList(
                                    // 여기서 CommentList는 직접 정의한 위젯이어야 합니다.
                                    uid: comment['uid'],
                                    content: comment['content'],
                                    dateTime: comment['dateTime'],
                                    postId: comment['postId'],
                                    commentId: comment['commentId']
                                    // 여기에 댓글에 대댓글을 추가하는 UI를 구현할 수 있습니다.
                                    );
                              },
                            );
                          },
                        );
                      },
                      childCount: 1,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: TextFormField(
                focusNode: _focusNode,
                controller: contents,
                decoration: InputDecoration(
                  hintText: "댓글을 입력하세요",
                  hintStyle: const TextStyle(color: Colors.grey),
                  contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      gapPadding: 10,
                      borderSide: BorderSide(color: Colors.lightBlue[200]!)),
                  suffixIcon: IconButton(
                    onPressed: () async {
                      String content = contents.text;
                      if (_replyingToCommentId != null) {
                        addReplyToComment(widget.post.documentId,
                            _replyingToCommentId!, content);
                        _replyingToCommentId = null; // 대댓글 추가 대상 초기화
                      } else {
                        await addComment(
                            widget.post.documentId, commentId, content);
                      }

                      contents.clear();
                    },
                    icon: const Icon(Icons.send),
                    color: Colors.lightBlue[200],
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.lightBlue[200]!,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
