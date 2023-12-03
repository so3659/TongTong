import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:go_router/go_router.dart';
import 'package:tongtong/db/loginDB.dart';
import 'package:tongtong/homepage.dart';
import 'package:tongtong/register.dart';

final GoRouter _goroute = GoRouter(
  routes: <RouteBase>[
    GoRoute(path: '/', builder: (context, state) => _firstpage()),
    GoRoute(
      path: '/register',
      builder: (context, state) => Register(),
    ),
    GoRoute(
      path: '/homepage',
      builder: (context, state) => Homepage(),
    )
  ],
);

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _goroute,
    );
  }
}

Widget _firstpage() {
  return MaterialApp(
    theme: ThemeData(fontFamily: 'SunflowerMedium'),
    home: Scaffold(
        backgroundColor: Colors.white,
        body: ListView(
          children: [
            _buildTitle(),
            const BuildLogin(),
            const BuildRegister(),
          ],
        )),
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

class BuildLogin extends StatelessWidget {
  const BuildLogin({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController id = TextEditingController();
    final TextEditingController pw = TextEditingController();
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
                  final loginCheck = await login(id.text, pw.text);
                  if (loginCheck == '-1') {
                    if (context.mounted) {
                      showFailDialog(context);
                    }
                  } else {
                    if (context.mounted) {
                      context.push('/homepage');
                    }
                  }
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100)),
                child: const Text('로그인'),
              )),
        ),
      ],
    );
  }
}

class BuildRegister extends StatelessWidget {
  const BuildRegister({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        FadeInUp(
          duration: const Duration(milliseconds: 1800),
          child: Container(
              margin: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Center(
                child: TextButton(
                  child: const Text('비밀번호 찾기'),
                  onPressed: () {},
                ),
              )),
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
