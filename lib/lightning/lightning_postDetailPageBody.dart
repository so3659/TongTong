import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:tongtong/lightning/lightning_updatePost.dart';
import 'package:tongtong/services/customPageView.dart';
import 'package:tongtong/theme/theme.dart';
import 'package:tongtong/widgets/customWidgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:tongtong/parameter/postParameter.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedDetailPageBody extends StatefulWidget {
  const FeedDetailPageBody({
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
  final String? avatarUrl;

  @override
  State<FeedDetailPageBody> createState() => _FeedDetailPageBodyState();
}

class _FeedDetailPageBodyState extends State<FeedDetailPageBody> {
  int currentPage = 0;
  late FeedPost post;

  @override
  void initState() {
    super.initState();
    postParameter();
  }

  Future<void> deleteLightning(String documentId) async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('Lightning')
        .doc(widget.documentId)
        .get();

    // 문서가 존재하는 경우
    if (snapshot.exists) {
      List<dynamic> filePaths = snapshot['path'];

      for (String filePath in filePaths) {
        try {
          await FirebaseStorage.instance.ref(filePath).delete();
        } catch (e) {
          print("Failed to delete file at $filePath: $e");
        }
      }
    }

    await FirebaseFirestore.instance
        .collection('Lightning')
        .doc(documentId)
        .delete();
  }

  void postParameter() {
    if (widget.photoUrls != null) {
      widget.avatarUrl == null
          ? post = FeedPost(
              uid: widget.uid,
              name: widget.name,
              content: widget.content,
              photoUrls: widget.photoUrls,
              dateTime: widget.dateTime,
              documentId: widget.documentId,
              currentUserId: widget.currentUserId,
              anoym: widget.anoym,
              commentsCount: widget.commentsCount,
            )
          : post = FeedPost(
              uid: widget.uid,
              name: widget.name,
              content: widget.content,
              photoUrls: widget.photoUrls,
              dateTime: widget.dateTime,
              documentId: widget.documentId,
              currentUserId: widget.currentUserId,
              anoym: widget.anoym,
              commentsCount: widget.commentsCount,
              avatarUrl: widget.avatarUrl);
    } else {
      widget.avatarUrl == null
          ? post = FeedPost(
              uid: widget.uid,
              name: widget.name,
              content: widget.content,
              dateTime: widget.dateTime,
              documentId: widget.documentId,
              currentUserId: widget.currentUserId,
              anoym: widget.anoym,
              commentsCount: widget.commentsCount,
            )
          : post = FeedPost(
              uid: widget.uid,
              name: widget.name,
              content: widget.content,
              dateTime: widget.dateTime,
              documentId: widget.documentId,
              currentUserId: widget.currentUserId,
              anoym: widget.anoym,
              commentsCount: widget.commentsCount,
              avatarUrl: widget.avatarUrl);
    }
  }

  Future<void> handleLikeButtonPressed(
      List<dynamic> currentLikedBy, bool isCurrentlyLiked) async {
    DocumentReference postRef = FirebaseFirestore.instance
        .collection('Lightning')
        .doc(widget.documentId);
    List<dynamic> updatedLikedBy = List.from(currentLikedBy);

    if (isCurrentlyLiked) {
      updatedLikedBy.remove(widget.currentUserId); // 좋아요 취소
    } else {
      updatedLikedBy.add(widget.currentUserId); // 좋아요 추가
    }

    await postRef.update({'likedBy': updatedLikedBy}); // Firestore 업데이트
    // UI 업데이트는 StreamBuilder가 담당하므로 여기서는 setState() 호출 없음
  }

  @override
  Widget build(BuildContext context) {
    final bool hasImages = widget.photoUrls?.isNotEmpty ?? false;
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Lightning')
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
          var post = snapshot.data!.data() as Map<String, dynamic>;
          List<dynamic> likedBy = post['likedBy'] ?? [];
          bool isLiked = likedBy.contains(widget.currentUserId);
          int likesCount = likedBy.length;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
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
                              ? const AssetImage('assets/images/tong_logo.png')
                                  as ImageProvider<Object>
                              : widget.avatarUrl == null
                                  ? const AssetImage(
                                          'assets/images/tong_logo.png')
                                      as ImageProvider<Object>
                                  : CachedNetworkImageProvider(
                                      widget.avatarUrl!),
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
                                          return SizedBox(
                                              height: 150,
                                              child: Center(
                                                  child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: <Widget>[
                                                    Align(
                                                      alignment:
                                                          Alignment.topRight,
                                                      child: IconButton(
                                                        icon: const Icon(
                                                            Icons.close),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      ),
                                                    ),
                                                    Container(
                                                      child: Column(
                                                        children: [
                                                          // ListTile(
                                                          //   leading: const Icon(
                                                          //       Icons.update),
                                                          //   title: const Text(
                                                          //       '수정'),
                                                          //   onTap: () {
                                                          //     // Navigator.of(
                                                          //     //         context,
                                                          //     //         rootNavigator:
                                                          //     //             true)
                                                          //     //     .push(MaterialPageRoute(
                                                          //     //         builder:
                                                          //     //             (context) =>
                                                          //     //                 const UpdateLightning()));
                                                          //   },
                                                          // ),
                                                          ListTile(
                                                            leading: const Icon(
                                                                Icons.delete),
                                                            title: const Text(
                                                                '삭제'),
                                                            onTap: () {
                                                              deleteLightning(
                                                                  widget
                                                                      .documentId);
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ])));
                                        },
                                      );
                                    }
                                  : null,
                              child: Padding(
                                padding: EdgeInsets.zero,
                                child: Icon(
                                  Icons.more_horiz,
                                  color: widget.uid ==
                                          FirebaseAuth.instance.currentUser!.uid
                                      ? Colors.black87
                                      : Colors.grey[400],
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
                                    Positioned(
                                      left: 25, // 아이콘과 텍스트 간의 간격을 조정
                                      top: 3, // 다음 아이콘의 시작점을 조정하세요
                                      child: IconButton(
                                        onPressed: () {},
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
                                      top: 15, // 아이콘과 텍스트의 세로 위치를 맞추기 위해 조정하세요
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
}
