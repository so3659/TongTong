import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class GoogleLogin extends StatelessWidget {
  const GoogleLogin({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          _buildTitle(),
          const BuildLogin(),
        ],
      ),
    );
  }
}

Widget _buildTitle() {
  return Container(
    padding: const EdgeInsets.all(8),
    alignment: Alignment.center,
    width: 150,
    decoration: const BoxDecoration(
      color: Colors.white,
    ),
    child: FadeInUp(
        duration: const Duration(milliseconds: 1800),
        child: Container(
          margin: const EdgeInsets.fromLTRB(0, 100, 0, 50),
          child: Column(
            children: [
              Container(
                  width: 200,
                  height: 200,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/tong_logo.png'),
                      fit: BoxFit.cover,
                    ),
                  )),
              Container(
                  width: 350,
                  height: 150,
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

  _asyncMethod() async {
    //read 함수를 통하여 key값에 맞는 정보를 불러오게 됩니다. 이때 불러오는 결과의 타입은 String 타입임을 기억해야 합니다.
    //(데이터가 없을때는 null을 반환을 합니다.)
    userInfo = await storage.read(key: "login");

    //user의 정보가 있다면 바로 로그아웃 페이지로 넝어가게 합니다.
    if (userInfo != null) {
      context.go('/homepage');
    }
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
      // print("Logged in with Google: ${userCredential.user}");
      await storage.write(key: "login", value: userCredential.user.toString());
      context.go('/homepage');
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        FadeInUp(
          duration: const Duration(milliseconds: 1800),
          child: Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            padding: const EdgeInsets.all(20),
            width: 450,
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
