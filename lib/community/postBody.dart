import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tongtong/theme/theme.dart';
import 'package:tongtong/widgets/customWidgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:tongtong/parameter/postParameter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeedPageBody extends ConsumerStatefulWidget {
  const FeedPageBody({
    super.key,
    required this.uid,
    required this.content,
    this.photoUrls,
    required this.dateTime,
    required this.documentId,
    required this.currentUserId,
  });

  final String uid;
  final String content;
  final List<dynamic>? photoUrls;
  final Timestamp dateTime;
  final String documentId;
  final String currentUserId;

  @override
  _FeedPageBodyState createState() => _FeedPageBodyState();
}

class _FeedPageBodyState extends ConsumerState<FeedPageBody> {
  int currentPage = 0;
  bool isPressed = false;
  int likesCount = 0;
  bool isLiked = false;
  late FeedPost post;

  @override
  void initState() {
    super.initState();
    // Firestore에서 실시간 데이터를 구독합니다.
    FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.documentId)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists && snapshot.data()!.containsKey('likedBy')) {
        List<dynamic> likedBy = snapshot.data()!['likedBy'] as List<dynamic>;
        setState(() {
          isLiked = likedBy.contains(widget.currentUserId);
          likesCount = likedBy.length; // 서버의 likedBy 배열 길이로 likesCount를 설정
        });
      }
    });
    postParameter();
    isPressed = isLiked;
  }

  void postParameter() {
    if (widget.photoUrls != null) {
      post = FeedPost(
        uid: widget.uid,
        content: widget.content,
        photoUrls: widget.photoUrls,
        dateTime: widget.dateTime,
        documentId: widget.documentId,
        currentUserId: widget.currentUserId,
      );
    } else {
      post = FeedPost(
        uid: widget.uid,
        content: widget.content,
        dateTime: widget.dateTime,
        documentId: widget.documentId,
        currentUserId: widget.currentUserId,
      );
    }
  }

  Future<void> handleLikeButtonPressed() async {
    DocumentReference postRef =
        FirebaseFirestore.instance.collection('Posts').doc(widget.documentId);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(postRef);
      if (!snapshot.exists) {
        throw Exception("Post does not exist!");
      }

      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

      List<dynamic> likedBy = List.from(data['likedBy'] ?? []);

      if (isLiked) {
        // 좋아요 취소 로직
        likedBy.remove(widget.currentUserId);
      } else {
        // 좋아요 로직
        likedBy.add(widget.currentUserId);
      }

      transaction.update(postRef, {
        'likedBy': likedBy,
      });

      setState(() {
        isLiked = !isLiked;
        likesCount = likedBy.length;
        isPressed = isLiked;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool hasImages = widget.photoUrls?.isNotEmpty ?? false;

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
                        backgroundImage:
                            const AssetImage('assets/images/tong_logo.png'),
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
                              widget.uid,
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
                          )
                        ],
                      ),
                      Text(
                        widget.content,
                        style: GoogleFonts.mulish(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w300),
                      ),
                      if (hasImages)
                        Column(children: [
                          const SizedBox(
                            height: 20,
                          ),
                          AspectRatio(
                              aspectRatio: 1.0,
                              child: Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  ClipRRect(
                                      // ClipRRect를 사용하여 이미지를 둥글게 잘라냅니다.
                                      borderRadius: BorderRadius.circular(15),
                                      child: PageView.builder(
                                        onPageChanged: (value) {
                                          setState(() {
                                            currentPage = value;
                                          });
                                        },
                                        itemCount: widget.photoUrls!.length,
                                        itemBuilder: (context, index) {
                                          return Image.network(
                                            widget.photoUrls![index],
                                            fit: BoxFit.fitWidth,
                                          );
                                        },
                                      )),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    margin: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.5),
                                        borderRadius:
                                            BorderRadius.circular(500)),
                                    child: Text(
                                      '${currentPage + 1} / ${widget.photoUrls!.length}', // 현재 페이지 / 전체 페이지
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              )),
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
                                      icon: isPressed
                                          ? customIcon(
                                              context,
                                              icon: AppIcon.heartFill,
                                              isTwitterIcon: true,
                                              size: 15,
                                              iconColor: TwitterColor.ceriseRed,
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
                                        handleLikeButtonPressed();
                                        // setState(() {
                                        //   isPressed = isLiked;
                                        //   print(isLiked);
                                        //   print(isPressed);
                                        // });
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
                                  const Positioned(
                                    left: 58, // 아이콘과 텍스트 간의 간격을 조정
                                    top: 15, // 아이콘과 텍스트의 세로 위치를 맞추기 위해 조정하세요
                                    child: Text(
                                      '0',
                                      style: TextStyle(
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
            )),
        Divider(
          color: Colors.grey[200],
        ),
      ],
    );
  }
}
