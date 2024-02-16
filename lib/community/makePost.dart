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

class MakePost extends StatefulWidget {
  const MakePost({super.key});

  @override
  State<MakePost> createState() => MakePostState();
}

class MakePostState extends State<MakePost> {
  final TextEditingController contentController = TextEditingController();
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final String? _uid = FirebaseAuth.instance.currentUser!.email;
  bool _isUpload = false;
  Map<String, String>? _images;

  final String _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  Future<Map<String, String>> _imagePickerToUpload() async {
    setState(() {
      _isUpload = true;
    });
    if (Platform.isIOS) {
      await Permission.photosAddOnly.request();
    }
    final String dateTime = DateTime.now().millisecondsSinceEpoch.toString();
    ImagePicker picker = ImagePicker();
    XFile? images = await picker.pickImage(source: ImageSource.gallery);
    if (images != null) {
      String imageRef = "posts/${_uid}_$dateTime";
      File file = File(images.path);
      await FirebaseStorage.instance.ref(imageRef).putFile(file);
      final String urlString =
          await FirebaseStorage.instance.ref(imageRef).getDownloadURL();
      return {
        "image": urlString,
        "path": imageRef,
      };
    } else {
      return {
        "image": "",
        "path": "",
      };
    }
  }

  Future<void> _toFirestore(
      Map<String, String>? images, String postKey, String contents) async {
    try {
      DocumentReference<Map<String, dynamic>> reference =
          FirebaseFirestore.instance.collection("Posts").doc(postKey);
      if (images != null) {
        await reference.set({
          "uid": _uid,
          "contents": contents,
          "image": images["image"].toString(),
          "path": images["path"].toString(),
          "dateTime": Timestamp.now(),
        });
      } else if (images == null) {
        await reference.set({
          "uid": _uid,
          "contents": contents,
          "image": null,
          "path": null,
          "dateTime": Timestamp.now(),
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
              String postKey = getRandomString(16);

              _toFirestore(_images, postKey, content);
              Navigator.of(context, rootNavigator: true).pop();
            },
            icon: const Icon(Icons.send),
            color: Colors.lightBlue[200],
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          const SingleChildScrollView(),
          Expanded(
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
          ),
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
