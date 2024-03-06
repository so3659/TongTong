import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tongtong/theme/theme.dart';
import 'package:tongtong/widgets/customWidgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:tongtong/community/reply_list_body.dart';

final focusManagerProvider = ChangeNotifierProvider((ref) => FocusManager());
final replyProvider = StateNotifierProvider<ReplyNotifier, String?>((ref) {
  return ReplyNotifier();
});

class FocusManager extends ChangeNotifier {
  bool _shouldFocusCommentField = false;

  bool get shouldFocusCommentField => _shouldFocusCommentField;

  void requestFocusToCommentField() {
    _shouldFocusCommentField = true;
    notifyListeners();
  }

  void resetFocusRequest() {
    _shouldFocusCommentField = false;
    notifyListeners();
  }
}

// 대댓글 상태를 관리하는 StateNotifier
class ReplyNotifier extends StateNotifier<String?> {
  ReplyNotifier() : super(null);

  void startReplying(String commentId) {
    state = commentId;
  }

  void stopReplying() {
    state = null;
  }
}

class CommentList extends ConsumerStatefulWidget {
  const CommentList({
    super.key,
    required this.uid,
    required this.content,
    required this.dateTime,
    required this.postId,
    required this.commentId,
  });

  final String uid;
  final String content;
  final Timestamp dateTime;
  final String postId;
  final String commentId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => CommentListState();
}

class CommentListState extends ConsumerState<CommentList> {
  @override
  void initState() {
    super.initState();
  }

  void showReplyDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: const Text('대댓글을 작성하시겠습니까?'),
          actions: [
            ElevatedButton(
              onPressed: () {
                ref.read(focusManagerProvider).requestFocusToCommentField();
                // ReplyNotifier에 commentId 전달
                ref
                    .read(replyProvider.notifier)
                    .startReplying(widget.commentId);
                Navigator.of(context).pop();
              },
              child: const Text('네'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('아니요'),
            ),
          ],
        );
      },
    );
  }

  Future<void> handleLikeButtonPressed(
      List<dynamic> currentLikedBy, bool isCurrentlyLiked) async {
    DocumentReference postRef = FirebaseFirestore.instance
        .collection('Posts')
        .doc(widget.postId)
        .collection('comments')
        .doc(widget.commentId);
    List<dynamic> updatedLikedBy = List.from(currentLikedBy);

    if (isCurrentlyLiked) {
      updatedLikedBy.remove(widget.uid); // 좋아요 취소
    } else {
      updatedLikedBy.add(widget.uid); // 좋아요 추가
    }

    await postRef.update({'likedBy': updatedLikedBy}); // Firestore 업데이트
    // UI 업데이트는 StreamBuilder가 담당하므로 여기서는 setState() 호출 없음
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Posts')
            .doc(widget.postId)
            .collection('comments')
            .doc(widget.commentId)
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
                      const SizedBox(width: 9.0 * 2),
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
                                            showReplyDialog();
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
                                        top:
                                            15, // 아이콘과 텍스트의 세로 위치를 맞추기 위해 조정하세요
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
      ),
    ]);
  }
}
