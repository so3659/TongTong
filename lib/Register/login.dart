import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:go_router/go_router.dart';
import 'package:tongtong/Register/register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tongtong/mainpage/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatelessWidget {
  const Login({super.key});
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

Widget _firstpage() {
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

Widget _buildTitle() {
  return Container(
    padding: const EdgeInsets.all(8),
    alignment: Alignment.center,
    height: 300,
    width: 150,
    decoration: const BoxDecoration(
      color: Colors.white,
    ),
    child: FadeInUp(
      duration: const Duration(milliseconds: 1800),
      child: const Text(
        'TongTong',
        style: TextStyle(
          color: Colors.black,
          fontSize: 40,
        ),
      ),
    ),
  );
}

class BuildLogin extends StatefulWidget {
  const BuildLogin({super.key});

  @override
  State<BuildLogin> createState() => BuildLoginState();
}

class BuildLoginState extends State<BuildLogin> {
  bool switchValue = false;

  // 자동 로그인 설정
  void _setAutoLogin(String token) async {
    // 공유저장소에 유저 DB의 인덱스 저장
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  // 자동 로그인 해제
  void _delAutoLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController id = TextEditingController();
    final TextEditingController pw = TextEditingController();
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        FadeInUp(
          duration: const Duration(milliseconds: 1800),
          child: Container(
            margin: const EdgeInsets.fromLTRB(30, 15, 30, 15),
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.grey[350],
              borderRadius: BorderRadius.circular(38.5),
            ),
            child: TextField(
              controller: id,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "아이디 입력",
                  hintStyle: TextStyle(color: Colors.black)),
            ),
          ),
        ),
        FadeInUp(
          duration: const Duration(milliseconds: 1800),
          child: Container(
            margin: const EdgeInsets.fromLTRB(30, 15, 30, 15),
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.grey[350],
              borderRadius: BorderRadius.circular(38.5),
            ),
            child: TextField(
              controller: pw,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "비밀번호 입력",
                  hintStyle: TextStyle(color: Colors.black)),
            ),
          ),
        ),
        FadeInUp(
          duration: const Duration(milliseconds: 1800),
          child: Container(
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              padding: const EdgeInsets.all(20),
              width: 450,
              child: FloatingActionButton(
                backgroundColor: Colors.white,
                onPressed: () async {
                  try {
                    UserCredential credential =
                        await firebaseAuth.signInWithEmailAndPassword(
                            email: id.text, password: pw.text);
                    if (credential.user != null) {
                      context.go('/homepage');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                            'Server Error'), //snack bar의 내용. icon, button같은것도 가능하다.
                        duration: Duration(seconds: 5), //올라와있는 시간
                      ));
                    }
                  } on FirebaseAuthException catch (error) {
                    // logger.e(error.code);
                    String? errorCode;
                    switch (error.code) {
                      case "invalid-email":
                        errorCode = ('이메일의 형식이 올바르지 않습니다');
                        break;
                      case "user-not-found":
                        errorCode = ('유저 정보가 없습니다');
                        break;
                      case "wrong-password":
                        errorCode = ('비밀번호가 올바르지 않습니다');
                        break;
                      case "user-disabled":
                        errorCode = error.code;
                        break;
                      default:
                        errorCode = null;
                    }
                    if (errorCode != null) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            errorCode), //snack bar의 내용. icon, button같은것도 가능하다.
                        duration: const Duration(seconds: 3), //올라와있는 시간
                      ));
                    }
                  }
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100)),
                child: const Text('로그인'),
              )),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            FadeInUp(
              duration: const Duration(milliseconds: 1800),
              // 자동 로그인 확인 토글 스위치
              child: SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('자동로그인 '),
                    Switch(
                      // 부울 값으로 스위치 토글 (value)
                      value: switchValue,
                      activeColor: Colors.lightBlue[200],
                      onChanged: (bool? value) {
                        // 스위치가 토글될 때 실행될 코드
                        setState(() {
                          switchValue = value ?? false;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            FadeInUp(
              duration: const Duration(milliseconds: 1800),
              child: Container(
                margin: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Center(
                  child: TextButton(
                    child: const Text('회원가입'),
                    onPressed: () => context.push('/register'),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}

void showFailDialog(BuildContext context) async {
  String result = await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('통통 로그인'),
        content: const Text("아이디 또는 비밀번호가 올바르지 않습니다"),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.pop(context, "OK");
            },
          ),
        ],
      );
    },
  );
}
