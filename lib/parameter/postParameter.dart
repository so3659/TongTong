import 'package:cloud_firestore/cloud_firestore.dart';

class FeedPost {
  final String uid;
  final String name;
  final String content;
  final List<dynamic>? photoUrls;
  final Timestamp dateTime;
  final String documentId;
  final String currentUserId;
  final bool anoym;

  FeedPost({
    required this.uid,
    required this.name,
    required this.content,
    this.photoUrls,
    required this.dateTime,
    required this.documentId,
    required this.currentUserId,
    required this.anoym,
  });
}
