import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tongtong/FCM/fcm.dart';
import 'package:tongtong/parameter/postParameter.dart';
import 'package:tongtong/restaurant/restaurant_postDetailPageBody.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';
import 'package:tongtong/restaurant/restaurant_comment_list_body.dart';
import 'package:tongtong/restaurant/restaurant_reply_list_body.dart';
import 'package:http/http.dart' as http;

class RestaurantDetailPage extends ConsumerStatefulWidget {
  final FeedPost post;
  const RestaurantDetailPage({super.key, required this.post});

  @override
  RestaurantDetailPageState createState() => RestaurantDetailPageState();
}

class RestaurantDetailPageState extends ConsumerState<RestaurantDetailPage> {
  final String _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random();
  final FocusNode _focusNode = FocusNode();
  String? _replyingToCommentId;
  bool checkboxValue = false;
  final TextEditingController contents = TextEditingController();
  bool _loading = false;
  final Set<String> _blockedUsers = {};
  String avatarUrl =
      "https://firebasestorage.googleapis.com/v0/b/tongtong-5936b.appspot.com/o/defaultProfileImage%2Ftong_logo.png?alt=media&token=b17f8452-66e6-43f4-8439-3c414b8691c6";
  String username = "이름 없는 자";

  @override
  void initState() {
    super.initState();
    _bringAvatarurl();
    _bringname();
    loadBlockedUsers();
  }

  Future<void> _bringAvatarurl() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.post.uid)
          .get();

      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

        if (data.containsKey('avatarUrl')) {
          if (mounted) {
            // mounted 확인
            setState(() {
              avatarUrl = data['avatarUrl'];
            });
          }
        }
      }
    } catch (e) {
      print("Error fetching avatar URL: $e");
    }
  }

  Future<void> _bringname() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.post.uid)
          .get();

      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

        if (data.containsKey('username')) {
          if (mounted) {
            // mounted 확인
            setState(() {
              username = data['username'];
            });
          }
        }
      }
    } catch (e) {
      print("Error fetching username: $e");
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

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  Future<void> sendNotification(String toToken) async {
    AccessTokenFirebase accessTokenGetter = AccessTokenFirebase();
    String token = await accessTokenGetter.getAccessToken();
    String jsonPost = jsonEncode(widget.post.toJson());

    final projectID = dotenv.get("ProjectID");
    try {
      final response = await http.post(
          Uri.parse(
              'https://fcm.googleapis.com/v1/projects/$projectID/messages:send'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: json.encode({
            "message": {
              "token": toToken,
              "notification": {"title": "새 댓글 알림", "body": "게시물에 새 댓글이 달렸습니다!"},
              "data": {"restaurantsId": jsonPost},
              "android": {
                "notification": {"click_action": "FLUTTER_NOTIFICATION_CLICK"}
              },
              "apns": {
                "payload": {
                  "aps": {
                    "category": "FLUTTER_NOTIFICATION_CLICK",
                    "content-available": 1
                  }
                }
              }
            }
          }));
    } on HttpException catch (error) {
      return debugPrint(error.message);
    }
  }

  Future<void> sendNotification_reply(String toToken) async {
    AccessTokenFirebase accessTokenGetter = AccessTokenFirebase();
    String token = await accessTokenGetter.getAccessToken();
    String jsonPost = jsonEncode(widget.post.toJson());

    final projectID = dotenv.get("ProjectID");
    try {
      final response = await http.post(
          Uri.parse(
              'https://fcm.googleapis.com/v1/projects/$projectID/messages:send'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: json.encode({
            "message": {
              "token": toToken,
              "notification": {
                "title": "새 대댓글 알림",
                "body": "댓글에 새 대댓글이 달렸습니다!"
              },
              "data": {"restaurantsId": jsonPost},
              "android": {
                "notification": {"click_action": "FLUTTER_NOTIFICATION_CLICK"}
              },
              "apns": {
                "payload": {
                  "aps": {
                    "category": "FLUTTER_NOTIFICATION_CLICK",
                    "content-available": 1
                  }
                }
              }
            }
          }));
    } on HttpException catch (error) {
      return debugPrint(error.message);
    }
  }

  Future<String> getUserToken(String uid) async {
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
    return userData['token'];
  }

  Future<String> getCommentUid(String postId, String commentId) async {
    DocumentSnapshot commentDoc = await FirebaseFirestore.instance
        .collection('Restaurants')
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .get();
    Map<String, dynamic> commentData =
        commentDoc.data() as Map<String, dynamic>;
    return commentData['uid'];
  }

  Future<void> addComment(String postId, String content) async {
    if (contents.text.isEmpty) return;
    if (!mounted) return; // 추가: 함수 시작 시 위젯이 마운트되어 있는지 확인
    setState(() {
      _loading = true; // Firestore에 문서를 보내는 작업이 시작됨
    });
    DocumentReference postRef =
        FirebaseFirestore.instance.collection('Restaurants').doc(postId);

    CollectionReference commentsRef = postRef.collection('comments');
    String commentId = getRandomString(16);
    String uid = FirebaseAuth.instance.currentUser!.uid;

    DocumentSnapshot postSnapshot = await postRef.get();

    List<dynamic> anoymList = postSnapshot.get('anoymList') ?? [];
    int anoymCount = postSnapshot.get('anoymCount') ?? 0;
    bool postAnoym = postSnapshot.get('anoym') ?? false;

    String displayName;
    if (checkboxValue) {
      // 익명 사용자인 경우
      if (anoymList.contains(uid)) {
        // 이미 익명 목록에 있는 경우
        int index = anoymList.indexOf(uid);
        displayName = (postAnoym && postSnapshot.get('uid') == uid)
            ? "익명(작성자)"
            : "익명$index";
      } else {
        // 익명 목록에 없는 경우 새로 추가
        anoymList.add(uid);
        if (postSnapshot.get('uid') != uid) {
          anoymCount++;
        } else if (!(postAnoym && postSnapshot.get('uid') == uid)) {
          anoymCount++;
        }

        displayName = (postAnoym && postSnapshot.get('uid') == uid)
            ? "익명(작성자)"
            : "익명$anoymCount";

        // 익명 목록과 카운트 업데이트
        await FirebaseFirestore.instance
            .collection("Restaurants")
            .doc(postId)
            .update({
          'anoymList': anoymList,
          'anoymCount': anoymCount,
        });
      }
    } else {
      // 실명 사용자인 경우
      displayName = FirebaseAuth.instance.currentUser!.displayName!;
    }

    String? avatarUrl =
        await fetchAvatarUrl(FirebaseAuth.instance.currentUser!.uid);

    await commentsRef.doc(commentId).set({
      "uid": uid,
      "name": displayName,
      'content': content,
      'dateTime': Timestamp.now(),
      'postId': postId,
      'commentId': commentId,
      'likedBy': [],
      'anoym': checkboxValue,
      'replyCount': 0,
      'isDeleted': false,
      'avatarUrl': avatarUrl,
    });
    await postRef.update({
      'commentsCount': FieldValue.increment(1),
    });
    if (widget.post.uid != FirebaseAuth.instance.currentUser!.uid) {
      getUserToken(widget.post.uid).then((token) {
        sendNotification(token);
      });
    }
    if (mounted) {
      // 변경: 작업 완료 후 위젯이 마운트되어 있는지 확인
      setState(() {
        _loading = false; // 작업이 완료됨
      });
    }
  }

  Future<void> addReplyToComment(
      String postId, String commentId, String replyContent) async {
    if (contents.text.isEmpty) return;
    if (!mounted) return; // 추가: 함수 시작 시 위젯이 마운트되어 있는지 확인
    setState(() {
      _loading = true; // Firestore에 문서를 보내는 작업이 시작됨
    });
    DocumentReference postRef = FirebaseFirestore.instance
        .collection('Restaurants')
        .doc(widget.post.documentId);
    DocumentReference commentRef = FirebaseFirestore.instance
        .collection('Restaurants')
        .doc(widget.post.documentId) // 게시글 ID
        .collection('comments')
        .doc(commentId);

    String replyId = getRandomString(16); // Unique ID
    String uid0 = FirebaseAuth.instance.currentUser!.uid;

    DocumentSnapshot postSnapshot = await FirebaseFirestore.instance
        .collection("Restaurants")
        .doc(postId)
        .get();

    List<dynamic> anoymList = postSnapshot.get('anoymList') ?? [];
    int anoymCount = postSnapshot.get('anoymCount') ?? 0;
    bool postAnoym = postSnapshot.get('anoym') ?? false;

    String displayName;
    if (checkboxValue) {
      // 익명 사용자인 경우
      if (anoymList.contains(uid0)) {
        // 이미 익명 목록에 있는 경우
        int index = anoymList.indexOf(uid0);
        displayName = (postAnoym && postSnapshot.get('uid') == uid0)
            ? "익명(작성자)"
            : "익명${index + 1}";
      } else {
        // 익명 목록에 없는 경우 새로 추가
        anoymList.add(uid0);
        if (postSnapshot.get('uid') != uid0) {
          anoymCount++;
        } else if (!(postAnoym && postSnapshot.get('uid') == uid0)) {
          anoymCount++;
        }
        displayName = (postAnoym && postSnapshot.get('uid') == uid0)
            ? "익명(작성자)"
            : "익명$anoymCount";

        // 익명 목록과 카운트 업데이트
        await FirebaseFirestore.instance
            .collection("Restaurants")
            .doc(postId)
            .update({
          'anoymList': anoymList,
          'anoymCount': anoymCount,
        });
      }
    } else {
      // 실명 사용자인 경우
      displayName = FirebaseAuth.instance.currentUser!.displayName!;
    }

    String? avatarUrl =
        await fetchAvatarUrl(FirebaseAuth.instance.currentUser!.uid);

    // 대댓글 추가 로직
    await commentRef.collection('Replies').doc(replyId).set({
      "uid": FirebaseAuth.instance.currentUser!.uid,
      "name": displayName,
      'content': replyContent,
      'dateTime': Timestamp.now(),
      'postId': postId,
      'commentId': commentId,
      'replyId': replyId,
      'likedBy': [],
      'anoym': checkboxValue,
      'avatarUrl': avatarUrl,
    });

    await postRef.update({
      'commentsCount': FieldValue.increment(1),
    });
    await commentRef.update({
      'replyCount': FieldValue.increment(1),
    });
    final uid = await getCommentUid(widget.post.documentId, commentId);
    if (uid != widget.post.uid) {
      if (widget.post.uid != FirebaseAuth.instance.currentUser!.uid) {
        getUserToken(widget.post.uid).then((token) {
          sendNotification_reply(token);
        });
      }
      if (uid != FirebaseAuth.instance.currentUser!.uid) {
        getUserToken(uid).then((token) {
          sendNotification_reply(token);
        });
      }
    } else {
      if (widget.post.uid != FirebaseAuth.instance.currentUser!.uid) {
        getUserToken(widget.post.uid).then((token) {
          sendNotification_reply(token);
        });
      }
    }

    if (mounted) {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<String?> fetchAvatarUrl(String uid) async {
    // 문서 참조를 얻습니다.
    DocumentReference<Map<String, dynamic>> userDocRef =
        FirebaseFirestore.instance.collection('users').doc(uid);

    try {
      // 문서의 스냅샷을 가져옵니다.
      DocumentSnapshot<Map<String, dynamic>> docSnapshot =
          await userDocRef.get();

      // 문서가 존재하는지 확인합니다.
      if (docSnapshot.exists) {
        // 문서 데이터를 얻습니다.
        Map<String, dynamic>? data = docSnapshot.data();

        // 'avatarUrl' 필드가 존재하는지 확인하고, 존재한다면 그 값을 반환합니다.
        return data?['avatarUrl'];
      } else {
        // 문서가 존재하지 않는 경우 null을 반환합니다.
        return null;
      }
    } catch (e) {
      // 오류가 발생한 경우, null을 반환합니다.
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final focusManager = ref.watch(restaurant_focusManagerProvider);
      final currentReplyingCommentId = ref.watch(restaurant_replyProvider);
      final screenSize = MediaQuery.of(context).size;

      void startReplyingToComment(String commentId) {
        _replyingToCommentId = commentId; // 대댓글을 달 댓글의 ID를 저장
      }

      if (focusManager.shouldFocusCommentField) {
        startReplyingToComment(currentReplyingCommentId!);
        // 포커스 요청이 있으면 포커스를 주고 상태를 리셋
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _focusNode.requestFocus();
          ref.read(restaurant_focusManagerProvider).resetFocusRequest();
        });
      }
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Stack(children: [
          Column(
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
                          SizedBox(
                            height: screenSize.height * 0.02,
                            width: double.infinity,
                          ),
                          FeedDetailPageBody(
                            uid: widget.post.uid,
                            name: widget.post.anoym ? '익명' : username,
                            content: widget.post.content,
                            photoUrls: widget.post.photoUrls,
                            dateTime: widget.post.dateTime,
                            documentId: widget.post.documentId,
                            currentUserId: widget.post.currentUserId,
                            anoym: widget.post.anoym,
                            commentsCount: widget.post.commentsCount,
                            avatarUrl: widget
                                .post.avatarUrl, // avatarUrl이 null인 경우 null을 전달
                          ),
                        ],
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('Restaurants')
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
                                return Container();
                              }
                              return ListView.builder(
                                padding: EdgeInsets.zero,
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

                                  return Column(
                                    children: [
                                      _blockedUsers.contains(comment['uid'])
                                          ? const SizedBox.shrink()
                                          : CommentList(
                                              // 댓글 정보를 사용하여 CommentList 위젯 생성
                                              uid: comment['uid'],
                                              name: comment['name'],
                                              content: comment['content'],
                                              dateTime: comment['dateTime'],
                                              postId: comment['postId'],
                                              commentId: comment['commentId'],
                                              anoym: comment['anoym'],
                                              replyCount: comment['replyCount'],
                                              isDelete: comment['isDeleted'],
                                              avatarUrl: comment['avatarUrl'],
                                            ),
                                      StreamBuilder<QuerySnapshot>(
                                        // 대댓글 목록을 가져오는 스트림
                                        stream: document.reference
                                            .collection('Replies')
                                            .orderBy('dateTime',
                                                descending: false)
                                            .snapshots(),
                                        builder: (context, repliesSnapshot) {
                                          if (repliesSnapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const Center(
                                                child:
                                                    CircularProgressIndicator());
                                          }
                                          if (repliesSnapshot.hasError) {
                                            return const Center(
                                                child: Text(
                                                    '대댓글을 불러오는데 문제가 발생했습니다.'));
                                          }
                                          if (!repliesSnapshot.hasData ||
                                              repliesSnapshot
                                                  .data!.docs.isEmpty) {
                                            return Container(); // 대댓글이 없으면 비어 있는 컨테이너를 반환
                                          }

                                          // 대댓글 목록을 나타내는 위젯을 빌드합니다.
                                          return ListView.builder(
                                            padding: EdgeInsets.zero,
                                            physics:
                                                const NeverScrollableScrollPhysics(), // 중첩 스크롤 방지
                                            shrinkWrap:
                                                true, // 내부 컨텐츠에 맞춰 크기 조절
                                            itemCount: repliesSnapshot
                                                .data!.docs.length, // 대댓글의 수
                                            itemBuilder: (context, replyIndex) {
                                              DocumentSnapshot replyDoc =
                                                  repliesSnapshot
                                                      .data!.docs[replyIndex];
                                              Map<String, dynamic> reply =
                                                  replyDoc.data()
                                                      as Map<String, dynamic>;
                                              return _blockedUsers
                                                      .contains(reply['uid'])
                                                  ? const SizedBox.shrink()
                                                  : ReplyList(
                                                      uid: reply['uid'],
                                                      name: reply['name'],
                                                      content: reply['content'],
                                                      dateTime:
                                                          reply['dateTime'],
                                                      postId: reply['postId'],
                                                      commentId:
                                                          reply['commentId'],
                                                      replyId: reply['replyId'],
                                                      anoym: reply['anoym'],
                                                      avatarUrl:
                                                          reply['avatarUrl'],
                                                    );
                                            },
                                          );
                                        },
                                      ),
                                    ],
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
                  child: Row(
                    children: <Widget>[
                      Row(
                        children: [
                          Checkbox(
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            visualDensity: const VisualDensity(
                              horizontal: VisualDensity.minimumDensity,
                              vertical: VisualDensity.minimumDensity,
                            ),
                            activeColor: Colors.lightBlue[200],
                            value: checkboxValue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            side: BorderSide(
                              color: Colors.lightBlue[200]!,
                              width: 1,
                            ),
                            onChanged: (bool? value) {
                              setState(() {
                                checkboxValue = value!;
                              });
                            },
                          ),
                          Text(
                            '익명',
                            style: TextStyle(color: Colors.lightBlue[200]!),
                          ),
                          const SizedBox(
                            width: 10,
                          )
                        ],
                      ),
                      Expanded(
                        child: TextFormField(
                          focusNode: _focusNode,
                          controller: contents,
                          decoration: InputDecoration(
                            hintText: "댓글을 입력하세요",
                            hintStyle: const TextStyle(color: Colors.grey),
                            contentPadding:
                                const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                gapPadding: 10,
                                borderSide:
                                    BorderSide(color: Colors.lightBlue[200]!)),
                            suffixIcon: IconButton(
                              onPressed: () async {
                                String content = contents.text;
                                if (_replyingToCommentId != null) {
                                  addReplyToComment(widget.post.documentId,
                                      _replyingToCommentId!, content);
                                  _replyingToCommentId = null; // 대댓글 추가 대상 초기화
                                } else {
                                  await addComment(
                                      widget.post.documentId, content);
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
                  ))
            ],
          ),
          if (_loading)
            const Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              ),
            ),
        ]),
      );
    });
  }

  @override
  void dispose() {
    contents.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}
