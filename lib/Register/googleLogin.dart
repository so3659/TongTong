import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class GoogleLogin extends StatelessWidget {
  const GoogleLogin({super.key});
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          _buildTitle(screenSize),
          const BuildLogin(),
        ],
      ),
    );
  }
}

Widget _buildTitle(screenSize) {
  return Container(
    padding: const EdgeInsets.all(8),
    alignment: Alignment.center,
    width: 150,
    decoration: const BoxDecoration(
      color: Colors.white,
    ),
    child: FadeInUp(
        duration: const Duration(milliseconds: 3800),
        child: Container(
          margin: EdgeInsets.only(
            top: screenSize.height * 0.15, // 상단 여백
            bottom: screenSize.height * 0.15, // 하단 여백
          ),
          child: Column(
            children: [
              Container(
                  width: screenSize.width * 0.5, // 이미지 너비
                  height: screenSize.height * 0.3, // 이미지 높이
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/tong_logo.png'),
                      fit: BoxFit.contain,
                    ),
                  )),
              Container(
                  width: screenSize.width * 0.7, // 로고 텍스트 너비
                  height: screenSize.height * 0.1, // 로고 텍스트 높이
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/tong_logo_name.png'),
                      fit: BoxFit.cover,
                    ),
                  )),
            ],
          ),
        )),
  );
}

class BuildLogin extends StatefulWidget {
  const BuildLogin({super.key});

  @override
  State<BuildLogin> createState() => BuildLoginState();
}

class BuildLoginState extends State<BuildLogin> {
  String? userInfo;
  static const storage =
      FlutterSecureStorage(); //flutter_secure_storage 사용을 위한 초기화 작업

  @override
  void initState() {
    super.initState();

    //비동기로 flutter secure storage 정보를 불러오는 작업.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });
  }

  Future<bool?> getEULAV(String userId) async {
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userDoc.exists) {
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      // EULA 필드 값 확인
      bool? eulaValue = userData['EULA'] as bool?;

      return eulaValue;
    } else {
      return null;
    }
  }

  _asyncMethod() async {
    //read 함수를 통하여 key값에 맞는 정보를 불러오게 됩니다. 이때 불러오는 결과의 타입은 String 타입임을 기억해야 합니다.
    //(데이터가 없을때는 null을 반환을 합니다.)
    userInfo = await storage.read(key: "login");

    //user의 정보가 있다면 바로 로그아웃 페이지로 넝어가게 합니다.
    if (userInfo != null) {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      bool? eulaValue = await getEULAV(userId);
      getToken();
      if (eulaValue == null || eulaValue == false) {
        // EULA 동의 페이지로 이동
        GoRouter.of(context).go('/eula');
      } else {
        GoRouter.of(context).go('/homepage');
      }
    }
  }

  Future<void> saveTokenToDatabase(String? token) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance.collection('users').doc(userId).set({
      'token': token,
    }, SetOptions(merge: true));
  }

  Future<void> getToken() async {
    // ios
    String? token;
    if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      token = await FirebaseMessaging.instance.getToken();
      // token = await FirebaseMessaging.instance.getAPNSToken();
    }
    // aos
    else {
      token = await FirebaseMessaging.instance.getToken();
    }
    saveTokenToDatabase(token);
  }

  void _signInWithGoogle() async {
    try {
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      final userCredential =
          await firebaseAuth.signInWithCredential(credential);
      // debugPrint("Logged in with Google: ${userCredential.user}");
      await storage.write(key: "login", value: userCredential.user.toString());
      getToken();
      String userId = FirebaseAuth.instance.currentUser!.uid;
      bool? eulaValue = await getEULAV(userId);
      if (eulaValue == null || eulaValue == false) {
        // EULA 동의 페이지로 이동
        GoRouter.of(context).go('/eula');
      } else {
        GoRouter.of(context).go('/homepage');
      }
    } catch (e) {
      return;
    }
  }

  Future<void> appleLogin() async {
    try {
      final AuthorizationCredentialAppleID appleCredential =
          await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final OAuthCredential credential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      await storage.write(key: "login", value: userCredential.user.toString());
      getToken();
      String userId = FirebaseAuth.instance.currentUser!.uid;
      bool? eulaValue = await getEULAV(userId);
      if (eulaValue == null || eulaValue == false) {
        // EULA 동의 페이지로 이동
        GoRouter.of(context).go('/eula');
      } else {
        GoRouter.of(context).go('/homepage');
      }
    } catch (e) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        FadeInUp(
          duration: const Duration(milliseconds: 3800),
          child: Platform.isIOS
              ? Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(
                        vertical: screenSize.height * 0.0005, // 위아래 여백
                        horizontal: screenSize.width * 0.05, // 좌우 여백
                      ),
                      padding: EdgeInsets.all(screenSize.width * 0.005), // 패딩
                      width: screenSize.height * 0.6,
                      child: SignInButton(
                        Buttons.google,
                        text: "Sign in with Google",
                        onPressed: _signInWithGoogle,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                        vertical: screenSize.height * 0.0005, // 위아래 여백
                        horizontal: screenSize.width * 0.05, // 좌우 여백
                      ),
                      padding: EdgeInsets.all(screenSize.width * 0.005), // 패딩
                      width: screenSize.height * 0.6,
                      child: SignInButton(
                        Buttons.apple,
                        text: "Sign in with Apple",
                        onPressed: appleLogin,
                      ),
                    ),
                  ],
                )
              : Container(
                  margin: EdgeInsets.symmetric(
                    vertical: screenSize.height * 0.02, // 위아래 여백
                    horizontal: screenSize.width * 0.05, // 좌우 여백
                  ),
                  padding: EdgeInsets.all(screenSize.width * 0.05), // 패딩
                  width: screenSize.height * 0.6,
                  child: SignInButton(
                    Buttons.google,
                    text: "Sign in with Google",
                    onPressed: _signInWithGoogle,
                  ),
                ),
        ),
      ],
    );
  }
}
