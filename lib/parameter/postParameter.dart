import 'package:cloud_firestore/cloud_firestore.dart';

class FeedPost {
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

  FeedPost({
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
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'content': content,
      'photoUrls': photoUrls,
      'dateTime': dateTime.millisecondsSinceEpoch,
      'documentId': documentId,
      'currentUserId': currentUserId,
      'anoym': anoym,
      'commentsCount': commentsCount,
      'avatarUrl': avatarUrl,
    };
  }

  factory FeedPost.fromMap(Map<String, dynamic> map) {
    return FeedPost(
      uid: map['uid'],
      name: map['name'],
      content: map['content'],
      photoUrls: map['photoUrls'],
      dateTime: Timestamp.fromMillisecondsSinceEpoch(map['dateTime']),
      documentId: map['documentId'],
      currentUserId: map['currentUserId'],
      anoym: map['anoym'],
      commentsCount: map['commentsCount'],
      avatarUrl: map['avatarUrl'],
    );
  }
}
