import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? user;
  late final TextEditingController userNameController;
  final String _uid = FirebaseAuth.instance.currentUser!.uid;
  static const storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    // Here you might be fetching the user info from FirebaseAuth
    // or any other service your app is using.
    user = FirebaseAuth.instance.currentUser;
    userNameController = TextEditingController(text: user?.displayName);
  }

  _updateDisplayNameDialog() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('닉네임 변경'),
            content: TextField(
              maxLength: 15,
              controller: userNameController,
              decoration: const InputDecoration(hintText: '원하는 유저 이름을 적어주세요'),
            ),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('취소'),
              ),
              ElevatedButton(
                onPressed: () async {
                  updateDisplayName(userNameController.text);
                  Navigator.of(context).pop();
                },
                child: const Text('확인'),
              ),
            ],
          );
        });
  }

  Future<bool> isDisplayNameTaken(String displayName) async {
    final query = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: displayName)
        .get();

    return query.docs.isNotEmpty;
  }

  Future<void> updateDisplayName(String displayName) async {
    if (user != null && await isDisplayNameTaken(displayName) == false) {
      // displayName이 중복되지 않음
      await user!.updateDisplayName(displayName);

      // Firestore에 사용자 displayName 업데이트
      FirebaseFirestore.instance.collection('users').doc(_uid).set({
        'username': displayName,
      }, SetOptions(merge: true));
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('변경이 완료되었습니다'), //snack bar의 내용. icon, button같은것도 가능하다.
        duration: Duration(seconds: 3), //올라와있는 시간
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('이미 존재하는 이름입니다'), //snack bar의 내용. icon, button같은것도 가능하다.
        duration: Duration(seconds: 3), //올라와있는 시간
      ));
    }
  }

  Future? _updateProfileImageDialog() async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          fixedSize: const Size(200, 30)),
                      onPressed: () {
                        updateProfileImage();
                      },
                      child: const Text('프로필 사진 변경')),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          fixedSize: const Size(200, 30)),
                      onPressed: () {
                        setDefaultProfileImage();
                      },
                      child: const Text('기본 프로필 사진')),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('취소'),
                ),
              ]);
        });
  }

  Future<void> setDefaultProfileImage() async {
    await user!.updatePhotoURL(
        "https://firebasestorage.googleapis.com/v0/b/tongtong-5936b.appspot.com/o/defaultProfileImage%2Ftong_logo.png?alt=media&token=b17f8452-66e6-43f4-8439-3c414b8691c6");
    FirebaseFirestore.instance.collection('users').doc(_uid).set({
      'avatarUrl':
          "https://firebasestorage.googleapis.com/v0/b/tongtong-5936b.appspot.com/o/defaultProfileImage%2Ftong_logo.png?alt=media&token=b17f8452-66e6-43f4-8439-3c414b8691c6",
    }, SetOptions(merge: true));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('변경이 완료되었습니다.'), //snack bar의 내용. icon, button같은것도 가능하다.
      duration: Duration(seconds: 3), //올라와있는 시간
    ));
    Navigator.of(context, rootNavigator: true).pop();
  }

  Future<void> updateProfileImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
      );
      if (Platform.isIOS) {
        await Permission.photosAddOnly.request();
      }

      if (pickedFile != null) {
        File file = File(pickedFile.path);
        String imageRef = "profileImage/$_uid";
        await FirebaseStorage.instance.ref(imageRef).putFile(file);
        final String urlString =
            await FirebaseStorage.instance.ref(imageRef).getDownloadURL();
        await user?.updatePhotoURL(urlString);
        FirebaseFirestore.instance.collection('users').doc(_uid).set({
          'path': imageRef,
          'avatarUrl': urlString,
        }, SetOptions(merge: true));
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('변경이 완료되었습니다.'), //snack bar의 내용. icon, button같은것도 가능하다.
          duration: Duration(seconds: 3), //올라와있는 시간
        ));

        Navigator.of(context, rootNavigator: true).pop();
      }
    } catch (error) {
      debugPrint('error: $error');
    }
  }

  _deleteAccount() async {
    storage.delete(key: "login");
    String userId = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    // 문서가 존재하는 경우
    if (snapshot.exists) {
      // 데이터를 Map으로 캐스팅
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

      // 'path' 키가 존재하는지 확인
      if (data.containsKey('path')) {
        String filePath = data['path'];

        // Firestore Storage에서 파일 삭제
        await FirebaseStorage.instance.ref(filePath).delete();
      }
    }

    await FirebaseFirestore.instance.collection('users').doc(userId).delete();
    FirebaseAuth.instance.currentUser!.delete();
    await GoogleSignIn().signOut();
  }

  _deleteAccountConfirm() async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: const Text('정말로 탈퇴하시겠습니까?'),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('취소'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await _deleteAccount();
                  GoRouter.of(context).go('/login');
                  Navigator.of(context).pop();
                },
                child: const Text('확인'),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    String username = user?.displayName ?? 'username';
    String email = user?.email ?? 'user@domain.com';
    String avatarUrl = user?.photoURL ?? 'https://via.placeholder.com/150';

    return Scaffold(
      body: ListView(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                CircleAvatar(
                  backgroundColor: Theme.of(context).cardColor,
                  backgroundImage:
                      CachedNetworkImageProvider(avatarUrl), // 프로필 이미지 경로
                  radius: 50, // 원하는 크기로 조절
                ),
                const SizedBox(height: 10), // 상하 여백
                Text(
                  email, // 사용자 email
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  username,
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 15), // 상하 여백
                Column(
                  children: [
                    Divider(
                      color: Colors.grey[200],
                    ),
                    ListTile(
                      title: const Center(child: Text('내가 쓴 글')),
                      onTap: () {
                        GoRouter.of(context).push('/myPosts');
                      },
                    ),
                    Divider(
                      color: Colors.grey[200],
                    ),
                    ListTile(
                      title: const Center(child: Text('댓글 단 글')),
                      onTap: () {
                        GoRouter.of(context).push('/myComments');
                      },
                    ),
                    Divider(
                      color: Colors.grey[200],
                    ),
                    ListTile(
                      title: const Center(child: Text('닉네임 변경')),
                      onTap: () {
                        _updateDisplayNameDialog();
                      },
                    ),
                    Divider(
                      color: Colors.grey[200],
                    ),
                    ListTile(
                      title: const Center(child: Text('프로필 사진 변경')),
                      onTap: () {
                        _updateProfileImageDialog();
                      },
                    ),
                    Divider(
                      color: Colors.grey[200],
                    ),
                    ListTile(
                      title: const Center(child: Text('문의하기')),
                      onTap: () {
                        GoRouter.of(context).push('/inquiry');
                      },
                    ),
                    Divider(
                      color: Colors.grey[200],
                    ),
                    ListTile(
                      title: const Center(child: Text('후원하기')),
                      onTap: () {
                        GoRouter.of(context).push('/sponsor');
                      },
                    ),
                    Divider(
                      color: Colors.grey[200],
                    ),
                    ListTile(
                      title: const Center(child: Text('회원탈퇴')),
                      onTap: () {
                        _deleteAccountConfirm();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
