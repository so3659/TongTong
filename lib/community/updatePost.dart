import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:tongtong/theme/theme.dart';
import 'package:tongtong/widgets/customWidgets.dart';
import 'dart:math';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UpdatePost extends StatefulWidget {
  const UpdatePost({super.key, required this.documentId});

  final String documentId;

  @override
  State<UpdatePost> createState() => UpdatePostState();
}

class UpdatePostState extends State<UpdatePost> {
  final TextEditingController contentController = TextEditingController();
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final String _uid = FirebaseAuth.instance.currentUser!.uid;
  bool _isUpload = false;
  List<Map<String, String>>? _images;
  bool checkboxValue = false;

  Future<List<Map<String, String>>> _imagePickerToUpload() async {
    setState(() {
      _isUpload = true;
    });
    if (Platform.isIOS) {
      await Permission.photosAddOnly.request();
    }
    ImagePicker picker = ImagePicker();
    List<XFile>? images = await picker.pickMultiImage(); // 여러 이미지 선택
    List<Map<String, String>> uploadedImages = [];
    for (XFile image in images) {
      String dateTime = DateTime.now().millisecondsSinceEpoch.toString();
      String imageRef = "posts/$_uid/$dateTime";
      File file = File(image.path);
      await FirebaseStorage.instance.ref(imageRef).putFile(file);
      final String urlString =
          await FirebaseStorage.instance.ref(imageRef).getDownloadURL();
      uploadedImages.add({
        "image": urlString,
        "path": imageRef,
      });
    }
    return uploadedImages;
  }

  Future<void> _toFirestore(List<Map<String, String>>? images, String postKey,
      String contents) async {
    try {
      DocumentReference<Map<String, dynamic>> reference =
          FirebaseFirestore.instance.collection("Posts").doc(postKey);
      List<String>? imageUrls = images
          ?.map((imageMap) => imageMap["image"])
          .where((url) => url != null) // null이 아닌 URL만 필터링
          .map((url) => url!) // null 체크 후, String?에서 String으로 변환
          .toList();

      List<String>? imagePaths = images
          ?.map((imageMap) => imageMap["path"])
          .where((url) => url != null) // null이 아닌 경로만 필터링
          .map((url) => url!) // null 체크 후, String?에서 String으로 변환
          .toList();

      if (images != null) {
        await reference.set({
          "uid": checkboxValue ? '익명' : _uid,
          "contents": contents,
          "image": imageUrls,
          "path": imagePaths,
          "dateTime": Timestamp.now(),
          'likedBy': [],
        });
      } else if (images == null) {
        await reference.set({
          "uid": checkboxValue ? '익명' : _uid,
          "contents": contents,
          "image": null,
          "path": null,
          "dateTime": Timestamp.now(),
          'likedBy': [],
        });
      }
    } on FirebaseException catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.message ?? "")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
          icon: const Icon(Icons.close),
          color: Colors.lightBlue[200],
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              String content = contentController.text;
              print(_images);

              _toFirestore(_images, widget.documentId, content);
              Navigator.of(context, rootNavigator: true).pop();
            },
            icon: const Icon(Icons.send),
            color: Colors.lightBlue[200],
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          Positioned.fill(
              child: SingleChildScrollView(
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'What\'s happening?',
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 16),
              ),
              keyboardType: TextInputType.multiline,
              maxLines: null,
              controller: contentController,
            ),
          )),
          Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: (Colors.grey[200])!)),
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                child: Row(
                  children: <Widget>[
                    IconButton(
                        onPressed: () async {
                          _images = await _imagePickerToUpload();
                        },
                        icon: customIcon(context,
                            icon: AppIcon.image,
                            isTwitterIcon: true,
                            iconColor: Colors.lightBlue[200])),
                    IconButton(
                        onPressed: () {},
                        icon: customIcon(context,
                            icon: AppIcon.camera,
                            isTwitterIcon: true,
                            iconColor: Colors.lightBlue[200])),
                    const Spacer(),
                    Row(
                      children: [
                        Checkbox(
                          activeColor: Colors.lightBlue[200],
                          value: checkboxValue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          side: BorderSide(
                            color: Colors.lightBlue[200]!,
                            width: 1,
                          ),
                          onChanged: (bool? value) {
                            setState(() {
                              checkboxValue = value!;
                            });
                          },
                        ),
                        Text(
                          '익명',
                          style: TextStyle(color: Colors.lightBlue[200]!),
                        ),
                        const SizedBox(
                          width: 10,
                        )
                      ],
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }

  @override
  void dispose() {
    contentController.dispose();
    super.dispose();
  }
}
