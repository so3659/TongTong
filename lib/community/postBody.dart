import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:tongtong/services/customPageView.dart';
import 'package:tongtong/theme/theme.dart';
import 'package:tongtong/widgets/customWidgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:tongtong/parameter/postParameter.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedPageBody extends StatefulWidget {
  FeedPageBody({
    super.key,
    required this.uid,
    required this.name,
    required this.content,
    this.photoUrls,
    required this.dateTime,
    required this.documentId,
    required this.currentUserId,
    required this.anoym,
    required this.commentsCount,
    this.avatarUrl,
  });

  final String uid;
  final String? name;
  final String content;
  final List<dynamic>? photoUrls;
  final Timestamp dateTime;
  final String documentId;
  final String currentUserId;
  final bool anoym;
  final int commentsCount;
  String? avatarUrl;

  @override
  FeedPageBodyState createState() => FeedPageBodyState();
}

class FeedPageBodyState extends State<FeedPageBody>
    with AutomaticKeepAliveClientMixin<FeedPageBody> {
  int currentPage = 0;
  late FeedPost post;
  String avatarUrl =
      "https://firebasestorage.googleapis.com/v0/b/tongtong-5936b.appspot.com/o/defaultProfileImage%2Ftong_logo.png?alt=media&token=b17f8452-66e6-43f4-8439-3c414b8691c6";
  String username = "이름 없는 자";

  User? user;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    user = FirebaseAuth.instance.currentUser;
    _bringAvatarurl();
    _bringname();
    postParameter();
  }

  Future<void> _bringAvatarurl() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
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
          .doc(widget.uid)
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

  Future<void> deletePost(String documentId) async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('Posts')
        .doc(widget.documentId)
        .get();

    // 문서가 존재하는 경우
    if (snapshot.exists) {
      List<dynamic> filePaths = snapshot['path'];

      for (String filePath in filePaths) {
        try {
          await FirebaseStorage.instance.ref(filePath).delete();
        } catch (e) {
          debugPrint("Failed to delete file at $filePath: $e");
        }
      }
    }

    await FirebaseFirestore.instance
        .collection('Posts')
        .doc(documentId)
        .delete();
  }

  void postParameter() {
    post = FeedPost(
        uid: widget.uid,
        name: widget.anoym ? '익명' : username,
        content: widget.content,
        photoUrls: widget.photoUrls,
        dateTime: widget.dateTime,
        documentId: widget.documentId,
        currentUserId: widget.currentUserId,
        anoym: widget.anoym,
        commentsCount: widget.commentsCount,
        avatarUrl: widget.avatarUrl ??= avatarUrl);
  }

  Future<void> handleLikeButtonPressed(
      List<dynamic> currentLikedBy, bool isCurrentlyLiked) async {
    DocumentReference postRef =
        FirebaseFirestore.instance.collection('Posts').doc(widget.documentId);
    List<dynamic> updatedLikedBy = List.from(currentLikedBy);

    if (isCurrentlyLiked) {
      updatedLikedBy.remove(widget.currentUserId); // 좋아요 취소
    } else {
      updatedLikedBy.add(widget.currentUserId); // 좋아요 추가
    }

    await postRef.update({'likedBy': updatedLikedBy});
    await postRef
        .set({'likesCount': updatedLikedBy.length}, SetOptions(merge: true));
  }

  blockUser() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'blockList': FieldValue.arrayUnion([widget.uid]),
    });
  }

  _blockConfirm() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: const Text('차단이 완료되었습니다.'),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: const Text('확인'),
              ),
            ],
          );
        });
  }

  _blockAlert() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: const Text('이 작성자의 게시물과 댓글이 표시되지 않으며, 다시 해제하실 수 없습니다.'),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('취소'),
              ),
              ElevatedButton(
                onPressed: () async {
                  blockUser();
                  _blockConfirm();
                },
                child: const Text('확인'),
              ),
            ],
          );
        });
  }

  final String _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  _sendReport(String reportReason) async {
    try {
      String postKey = getRandomString(16);
      DocumentReference<Map<String, dynamic>> reference =
          FirebaseFirestore.instance.collection("Reports").doc(postKey);

      await reference.set({
        "type": "post",
        'reportReason': reportReason,
        "uid": widget.uid,
        "name": widget.name,
        "contents": widget.content,
        "dateTime": widget.dateTime,
        'documentId': widget.documentId,
      });
    } on FirebaseException catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.message ?? "")));
    }
  }

  _reportUser(String reportReason) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: const Text('신고 사유에 맞지 않는 신고일 경우, 해당 신고는 처리되지 않습니다.'),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('취소'),
              ),
              ElevatedButton(
                onPressed: () async {
                  _sendReport(reportReason);
                  _reportConfirm();
                },
                child: const Text('확인'),
              ),
            ],
          );
        });
  }

  _reportConfirm() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: const Text('신고가 접수되었습니다. 검토까지는 최대 24시간 소요됩니다.'),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: const Text('확인'),
              ),
            ],
          );
        });
  }

  _cancelSheet() {
    String wrongInfo = '잘못된 정보';
    String commercialAd = '상업적 광고';
    String adultReason = '음란물';
    String violence = '폭력성';
    String etc = '기타';
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Column(
              children: [
                ListTile(
                  title: Center(child: Text(wrongInfo)),
                  onTap: () {
                    _reportUser(wrongInfo);
                  },
                ),
                ListTile(
                  title: Center(child: Text(commercialAd)),
                  onTap: () {
                    _reportUser(commercialAd);
                  },
                ),
                ListTile(
                  title: Center(child: Text(adultReason)),
                  onTap: () {
                    _reportUser(adultReason);
                  },
                ),
                ListTile(
                  title: Center(child: Text(violence)),
                  onTap: () {
                    _reportUser(violence);
                  },
                ),
                ListTile(
                  title: Center(child: Text(etc)),
                  onTap: () {
                    _reportUser(etc);
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final bool hasImages = widget.photoUrls?.isNotEmpty ?? false;
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Posts')
          .doc(widget.documentId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text("오류가 발생했습니다."));
        }

        if (snapshot.hasData && snapshot.data!.data() != null) {
          var data = snapshot.data!.data() as Map<String, dynamic>;
          List<dynamic> likedBy = data['likedBy'] ?? [];
          bool isLiked = likedBy.contains(widget.currentUserId);
          int likesCount = data['likesCount'];
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () {
                  GoRouter.of(context).push('/postDetailPage', extra: post);
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 55,
                        height: 55,
                        margin: const EdgeInsets.fromLTRB(10, 0, 15, 0),
                        child: GestureDetector(
                          onTap: () {},
                          child: CircleAvatar(
                            backgroundColor: Theme.of(context).cardColor,
                            backgroundImage: widget.anoym
                                ? const AssetImage(
                                        'assets/images/tong_logo.png')
                                    as ImageProvider<Object>
                                : CachedNetworkImageProvider(avatarUrl),
                            radius: 35,
                          ),
                        ),
                      ),
                      Flexible(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 5),
                                child: Text(
                                  widget.anoym ? '익명' : username,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(color: Colors.black87),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                timeago.format(widget.dateTime.toDate(),
                                    locale: "en_short"),
                                style: GoogleFonts.mulish(
                                    fontSize: 12, color: Colors.grey),
                              ),
                              const Spacer(),
                              InkWell(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onTap: widget.uid ==
                                        FirebaseAuth.instance.currentUser!.uid
                                    ? () {
                                        showModalBottomSheet(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  Align(
                                                    alignment:
                                                        Alignment.topRight,
                                                    child: IconButton(
                                                      icon: const Icon(
                                                          Icons.close),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                  ),
                                                  Column(
                                                    children: [
                                                      ListTile(
                                                        leading: const Icon(
                                                            Icons.delete),
                                                        title: const Text('삭제'),
                                                        onTap: () {
                                                          deletePost(widget
                                                              .documentId);
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ]);
                                          },
                                        );
                                      }
                                    : () {
                                        showModalBottomSheet(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  Align(
                                                    alignment:
                                                        Alignment.topRight,
                                                    child: IconButton(
                                                      icon: const Icon(
                                                          Icons.close),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                  ),
                                                  Column(
                                                    children: [
                                                      ListTile(
                                                        leading: const Icon(
                                                            Icons.report),
                                                        title: const Text('신고'),
                                                        onTap: () {
                                                          _cancelSheet();
                                                        },
                                                      ),
                                                      ListTile(
                                                        leading: const Icon(
                                                            Icons.block),
                                                        title: const Text('차단'),
                                                        onTap: () {
                                                          _blockAlert();
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ]);
                                          },
                                        );
                                      },
                                child: const Padding(
                                  padding: EdgeInsets.zero,
                                  child: Icon(
                                    Icons.more_horiz,
                                    color: Colors.black87,
                                    size: 17,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Linkify(
                            onOpen: (link) async {
                              if (!await launchUrl(Uri.parse(link.url))) {
                                throw Exception('Could not launch ${link.url}');
                              }
                            },
                            text: widget.content,
                            style: GoogleFonts.mulish(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w300),
                            linkStyle: GoogleFonts.mulish(
                              color: Colors.blue,
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          if (hasImages)
                            Column(children: [
                              const SizedBox(
                                height: 20,
                              ),
                              CustomPageView(photoUrls: widget.photoUrls!),
                              const SizedBox(
                                height: 15,
                              ),
                            ]),
                          Container(
                              color: Colors.transparent,
                              // Stack의 크기를 제한하는 Container
                              height: 33, // 적절한 높이 값 설정
                              width: double.infinity, // 너비를 화면 너비와 동일하게 설정
                              child: Align(
                                  alignment:
                                      Alignment.centerLeft, // Row를 오른쪽에 정렬
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        left: -15, // 아이콘과 텍스트 간의 간격을 조정
                                        top: 3, // 아이콘의 상단 위치 조정
                                        child: IconButton(
                                          icon: isLiked
                                              ? customIcon(
                                                  context,
                                                  icon: AppIcon.heartFill,
                                                  isTwitterIcon: true,
                                                  size: 15,
                                                  iconColor:
                                                      TwitterColor.ceriseRed,
                                                )
                                              : customIcon(
                                                  context,
                                                  icon: AppIcon.heartEmpty,
                                                  isTwitterIcon: true,
                                                  size: 15,
                                                  iconColor: Colors.grey,
                                                ),
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                          onPressed: () {
                                            handleLikeButtonPressed(
                                                likedBy, isLiked);
                                          },
                                        ),
                                      ),
                                      Positioned(
                                        left: 18, // 아이콘 오른쪽에 텍스트를 위치시키기 위해 조정
                                        top: 15, // 아이콘과 텍스트의 세로 위치를 맞추기 위해 조정
                                        child: Text(
                                          likesCount.toString(),
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 25, // 아이콘과 텍스트 간의 간격을 조정
                                        top: 3, // 다음 아이콘의 시작점을 조정하세요
                                        child: IconButton(
                                          onPressed: () {
                                            GoRouter.of(context).push(
                                                '/postDetailPage',
                                                extra: post);
                                          },
                                          icon: customIcon(
                                            context,
                                            icon: AppIcon.reply,
                                            isTwitterIcon: true,
                                            size: 15,
                                            iconColor: Colors.grey,
                                          ),
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                        ),
                                      ),
                                      Positioned(
                                        left: 58, // 아이콘과 텍스트 간의 간격을 조정
                                        top:
                                            15, // 아이콘과 텍스트의 세로 위치를 맞추기 위해 조정하세요
                                        child: Text(
                                          widget.commentsCount.toString(),
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )))
                        ],
                      )),
                    ],
                  ),
                ),
              ),
              Divider(
                color: Colors.grey[200],
              ),
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }
}
