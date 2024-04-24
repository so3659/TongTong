import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:tongtong/theme/theme.dart';
import 'package:tongtong/widgets/customWidgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

class ReplyList extends StatefulWidget {
  const ReplyList(
      {super.key,
      required this.uid,
      required this.name,
      required this.content,
      required this.dateTime,
      required this.postId,
      required this.commentId,
      required this.replyId,
      required this.anoym,
      this.avatarUrl});

  final String uid;
  final String? name;
  final String content;
  final Timestamp dateTime;
  final String postId;
  final String commentId;
  final String replyId;
  final bool anoym;
  final String? avatarUrl;

  @override
  State<ReplyList> createState() => ReplyListState();
}

class ReplyListState extends State<ReplyList> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> handleLikeButtonPressed(
      List<dynamic> currentLikedBy, bool isCurrentlyLiked) async {
    DocumentReference postRef = FirebaseFirestore.instance
        .collection('Restaurants')
        .doc(widget.postId)
        .collection('comments')
        .doc(widget.commentId)
        .collection('Replies')
        .doc(widget.replyId);
    List<dynamic> updatedLikedBy = List.from(currentLikedBy);

    if (isCurrentlyLiked) {
      updatedLikedBy.remove(widget.uid); // 좋아요 취소
    } else {
      updatedLikedBy.add(widget.uid); // 좋아요 추가
    }

    await postRef.update({'likedBy': updatedLikedBy}); // Firestore 업데이트
    // UI 업데이트는 StreamBuilder가 담당하므로 여기서는 setState() 호출 없음
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

  blockUser() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'blockList': FieldValue.arrayUnion([widget.uid]),
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
        "type": "restaurant-reply",
        'reportReason': reportReason,
        "uid": widget.uid,
        "name": widget.name,
        "contents": widget.content,
        "dateTime": widget.dateTime,
        'documentId': widget.replyId,
      });
    } on FirebaseException catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.message ?? "")));
    }
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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Restaurants')
          .doc(widget.postId)
          .collection('comments')
          .doc(widget.commentId)
          .collection('Replies')
          .doc(widget.replyId)
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
          bool isLiked = likedBy.contains(widget.uid);
          int likesCount = likedBy.length;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(right: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(width: 9.0 * 4),
                    Container(
                      width: 55,
                      height: 55,
                      margin: const EdgeInsets.fromLTRB(10, 0, 15, 0),
                      child: GestureDetector(
                        onTap: () {},
                        child: CircleAvatar(
                          backgroundColor: Theme.of(context).cardColor,
                          backgroundImage: widget.anoym
                              ? const AssetImage('assets/images/tong_logo.png')
                                  as ImageProvider<Object>
                              : widget.avatarUrl == null
                                  ? const AssetImage(
                                          'assets/images/tong_logo.png')
                                      as ImageProvider<Object>
                                  : CachedNetworkImageProvider(
                                      widget.avatarUrl!),
                          radius: 20,
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
                                widget.anoym
                                    ? '익명'
                                    : (widget.name ?? '(이름을 설정해주세요)'),
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
                                                  alignment: Alignment.topRight,
                                                  child: IconButton(
                                                    icon:
                                                        const Icon(Icons.close),
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
                                                        deleteReply();
                                                        Navigator.pop(context);
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
                                                  alignment: Alignment.topRight,
                                                  child: IconButton(
                                                    icon:
                                                        const Icon(Icons.close),
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
                        Container(
                            color: Colors.transparent,
                            // Stack의 크기를 제한하는 Container
                            height: 33, // 적절한 높이 값 설정
                            width: double.infinity, // 너비를 화면 너비와 동일하게 설정
                            child: Align(
                                alignment: Alignment.centerLeft, // Row를 오른쪽에 정렬
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
                                  ],
                                )))
                      ],
                    ))
                  ],
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

  Future<void> deleteReply() async {
    var replyRef = FirebaseFirestore.instance
        .collection('Restaurants')
        .doc(widget.postId)
        .collection('comments')
        .doc(widget.commentId)
        .collection('Replies')
        .doc(widget.replyId);

    // 대댓글을 삭제합니다.
    await replyRef.delete();

    // 댓글 수를 감소시킵니다.
    await FirebaseFirestore.instance
        .collection('Restaurants')
        .doc(widget.postId)
        .update({
      'commentsCount': FieldValue.increment(-1),
    });

    await FirebaseFirestore.instance
        .collection('Restaurants')
        .doc(widget.postId)
        .collection('comments')
        .doc(widget.commentId)
        .update({
      'replyCount': FieldValue.increment(-1),
    });
  }
}
