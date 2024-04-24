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

class MakeRestaurant extends StatefulWidget {
  const MakeRestaurant({super.key});

  @override
  State<MakeRestaurant> createState() => MakeRestaurantState();
}

class MakeRestaurantState extends State<MakeRestaurant> {
  final TextEditingController contentController = TextEditingController();
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final String _uid = FirebaseAuth.instance.currentUser!.uid;
  final String? _displayName = FirebaseAuth.instance.currentUser!.displayName;
  List<Map<String, String>>? _images;
  bool checkboxValue = false;
  XFile? image;
  List<XFile?>? multiImage = [];
  List<XFile?>? images = [];
  final picker = ImagePicker();
  bool _loading = false;

  final String _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  Future<List<Map<String, String>>> _imagePickerToUpload(
      List<XFile?>? images) async {
    List<Map<String, String>> uploadedImages = [];
    var nonNullableImages =
        images!.where((image) => image != null).cast<XFile>();
    for (XFile image in nonNullableImages) {
      String dateTime = DateTime.now().millisecondsSinceEpoch.toString();
      String imageRef = "restaurant/$_uid/$dateTime";
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
          FirebaseFirestore.instance.collection("Restaurants").doc(postKey);
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

      String? avatarUrl = await fetchAvatarUrl(_uid);

      if (images != null) {
        await reference.set({
          "uid": _uid,
          "name": checkboxValue ? '익명' : _displayName,
          "contents": contents,
          "image": imageUrls,
          "path": imagePaths,
          "dateTime": Timestamp.now(),
          'likedBy': [],
          'likesCount': 0,
          'anoym': checkboxValue,
          'commentsCount': 0,
          'documentId': postKey,
          'avatarUrl': avatarUrl,
        });
      } else if (images == null) {
        await reference.set({
          "uid": _uid,
          "name": checkboxValue ? '익명' : _displayName,
          "contents": contents,
          "image": null,
          "path": null,
          "dateTime": Timestamp.now(),
          'likedBy': [],
          'likesCount': 0,
          'anoym': checkboxValue,
          'commentsCount': 0,
          'documentId': postKey,
          'avatarUrl': avatarUrl,
        });
      }
    } on FirebaseException catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.message ?? "")));
    }
  }

  Future<String?> fetchAvatarUrl(String uid) async {
    // 문서 참조를 얻습니다.
    DocumentReference<Map<String, dynamic>> userDocRef =
        FirebaseFirestore.instance.collection('users').doc(uid);

    try {
      // 문서의 스냅샷을 가져옵니다.
      DocumentSnapshot<Map<String, dynamic>> docSnapshot =
          await userDocRef.get();

      // 문서가 존재하는지 확인합니다.
      if (docSnapshot.exists) {
        // 문서 데이터를 얻습니다.
        Map<String, dynamic>? data = docSnapshot.data();

        // 'avatarUrl' 필드가 존재하는지 확인하고, 존재한다면 그 값을 반환합니다.
        return data?['avatarUrl'];
      } else {
        // 문서가 존재하지 않는 경우 null을 반환합니다.
        return null;
      }
    } catch (e) {
      // 오류가 발생한 경우, null을 반환합니다.
      return null;
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
              if (!mounted) return; // 추가: 함수 시작 시 위젯이 마운트되어 있는지 확인
              setState(() {
                _loading = true; // Firestore에 문서를 보내는 작업이 시작됨
              });

              String content = contentController.text;
              String postKey = getRandomString(16);
              if (images != null) {
                _images = await _imagePickerToUpload(images);
              }

              _toFirestore(_images, postKey, content);

              if (mounted) {
                // 변경: 작업 완료 후 위젯이 마운트되어 있는지 확인
                setState(() {
                  _loading = false; // 작업이 완료됨
                });
              }
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
                  child: Column(
            children: [
              TextField(
                decoration: const InputDecoration(
                  hintText: '나만의 맛집에 대한 이야기를 적어주세요. \n링크를 공유하면 더 좋아요!',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 16),
                ),
                keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: contentController,
              ),
              images != null
                  ? ListView.builder(
                      padding: const EdgeInsets.fromLTRB(0, 30, 0, 70),
                      itemCount: images!.length,
                      shrinkWrap: true, // ListView를 내용의 높이에 맞춤
                      physics:
                          const NeverScrollableScrollPhysics(), // 이 ListView가 스크롤되지 않도록 설정
                      itemBuilder: (context, index) {
                        return Center(
                            child: Container(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Container(
                                width: 300,
                                height: 300,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  image: DecorationImage(
                                    image:
                                        FileImage(File(images![index]!.path)),
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                              ),
                              Container(
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  //삭제 버튼
                                  child: IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    icon: const Icon(Icons.close,
                                        color: Colors.black, size: 15),
                                    onPressed: () {
                                      //버튼을 누르면 해당 이미지가 삭제됨
                                      setState(() {
                                        images!.remove(images![index]);
                                      });
                                    },
                                  )),
                            ],
                          ),
                        ));
                      })
                  : Container()
            ],
          ))),
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
                          if (images?.length != null && images!.length >= 10) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                duration: const Duration(seconds: 2),
                                content: const Text("이미지는 10개까지만 가능합니다!"),
                                action: SnackBarAction(
                                  label: "Done",
                                  textColor: Colors.white,
                                  onPressed: () {},
                                ),
                              ),
                            );
                          } else {
                            multiImage = await picker.pickMultiImage();
                            if (multiImage != null) {
                              if (multiImage!.length + images!.length > 10) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    duration: const Duration(seconds: 2),
                                    content: const Text("이미지는 10개까지만 가능합니다!"),
                                    action: SnackBarAction(
                                      label: "Done",
                                      textColor: Colors.white,
                                      onPressed: () {},
                                    ),
                                  ),
                                );
                              } else {
                                setState(() {
                                  //갤러리에서 가지고 온 사진들은 리스트 변수에 저장되므로 addAll()을 사용해서 images와 multiImage 리스트를 합쳐줍니다.
                                  images?.addAll(multiImage!);
                                });
                              }
                            }
                          }
                        },
                        icon: customIcon(context,
                            icon: AppIcon.image,
                            isTwitterIcon: true,
                            iconColor: Colors.lightBlue[200])),
                    IconButton(
                        onPressed: () async {
                          if (images?.length != null && images!.length >= 10) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                duration: const Duration(seconds: 2),
                                content: const Text("이미지는 10개까지만 가능합니다!"),
                                action: SnackBarAction(
                                  label: "Done",
                                  textColor: Colors.white,
                                  onPressed: () {},
                                ),
                              ),
                            );
                          } else {
                            if (Platform.isIOS) {
                              await Permission.photosAddOnly.request();
                            }

                            image = await picker.pickImage(
                                source: ImageSource.camera);
                            if (image != null) {
                              if (1 + images!.length > 10) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    duration: const Duration(seconds: 2),
                                    content: const Text("이미지는 10개까지만 가능합니다!"),
                                    action: SnackBarAction(
                                      label: "Done",
                                      textColor: Colors.white,
                                      onPressed: () {},
                                    ),
                                  ),
                                );
                              } else {
                                setState(() {
                                  images?.add(image);
                                });
                              }
                            }
                          }
                        },
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
              )),
          if (_loading)
            const Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              ),
            ),
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
