import 'package:cloud_firestore/cloud_firestore.dart';

class FeedPost {
  final String uid;
  final String content;
  final List<String>? photoUrls;
  final Timestamp dateTime;
  final String documentId;
  final String currentUserId;

  FeedPost({
    required this.uid,
    required this.content,
    this.photoUrls,
    required this.dateTime,
    required this.documentId,
    required this.currentUserId,
  });
}
