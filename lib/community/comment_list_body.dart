import 'package:flutter/material.dart';

class CommentList extends StatefulWidget {
  const CommentList({super.key});

  @override
  State<CommentList> createState() => CommentListState();
}

class CommentListState extends State<CommentList> {
  bool myComments = true;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // SizedBox(width: comment.level * defaultPadding * 2),
        const SizedBox(width: 9.0 * 2),
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: CircleAvatar(
            backgroundColor: Theme.of(context).cardColor,
            backgroundImage: const AssetImage('assets/images/tong_logo.png'),
            radius: 35,
          ),
        ),
        const SizedBox(width: 9.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '이름  •  시간',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: Colors.black54),
              ),
              const SizedBox(height: 3),
              Text(
                'Comment',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: Colors.black87),
              ),
              Row(
                children: [
                  const Text('좋아요'),
                  // if (comment.likedCount > 0)
                  //   const SizedBox(width: 9.0)
                  // else
                  const SizedBox(),
                  if (myComments == true)
                    const SizedBox()
                  else
                    Row(
                      children: [
                        InkWell(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onTap: null,
                          child: Padding(
                            padding: const EdgeInsets.all(9.0),
                            child: Icon(
                              Icons.more_horiz,
                              color: Colors.grey[400],
                              size: 17,
                            ),
                          ),
                        ),
                        const SizedBox(width: 9.0),
                        // 1레벨 댓글만 가능
                        // if (comment.level > 0)
                        //   const SizedBox()
                        // else
                        InkWell(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onTap: null,
                          child: Padding(
                            padding: const EdgeInsets.all(9.0),
                            child: Icon(
                              Icons.reply,
                              color: Colors.grey[400],
                              size: 17,
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
