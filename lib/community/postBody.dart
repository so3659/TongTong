import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tongtong/theme/theme.dart';
import 'package:tongtong/widgets/customWidgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;

class FeedPageBody extends StatefulWidget {
  const FeedPageBody({
    super.key,
    required this.uid,
    required this.content,
    this.photoUrls, // 이제 photoUrls는 리스트입니다.
    required this.dateTime,
  });

  final String uid;
  final String content;
  final List<dynamic>? photoUrls; // 변경: 리스트 타입으로
  final Timestamp dateTime;

  @override
  State<FeedPageBody> createState() => _FeedPageBodyState();
}

class _FeedPageBodyState extends State<FeedPageBody> {
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final bool hasImages = widget.photoUrls?.isNotEmpty ?? false;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.only(right: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
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
                          style: GoogleFonts.mulish(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Colors.black,
                          ),
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
                                    borderRadius: BorderRadius.circular(500)),
                                child: Text(
                                  '${currentPage + 1} / ${widget.photoUrls!.length}', // 현재 페이지 / 전체 페이지
                                  style: const TextStyle(color: Colors.white),
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
                    padding: const EdgeInsets.only(bottom: 0, top: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                            child: Row(children: [
                          IconButton(
                            onPressed: () {},
                            icon: customIcon(
                              context,
                              icon: AppIcon.reply,
                              isTwitterIcon: true,
                              size: 15,
                              iconColor: Colors.grey,
                            ),
                          ),
                          customText(
                            '0',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                              fontSize: 10,
                            ),
                            context: context,
                          ),
                        ])),
                        Expanded(
                            child: Row(children: [
                          IconButton(
                            onPressed: () {},
                            icon: customIcon(
                              context,
                              icon: AppIcon.heartEmpty,
                              isTwitterIcon: true,
                              size: 15,
                              iconColor: Colors.grey,
                            ),
                          ),
                          customText(
                            '0',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                              fontSize: 10,
                            ),
                            context: context,
                          ),
                        ])),
                      ],
                    ),
                  )
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
  }
}
