import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:go_router/go_router.dart';
import 'package:tongtong/Register/register.dart';
import 'package:tongtong/db/loginDB.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tongtong/mainpage/homepage.dart';

final GoRouter _goroute = GoRouter(
  routes: <RouteBase>[
    GoRoute(path: '/', builder: (context, state) => const TokenCheck()),
    GoRoute(
      path: '/register',
      builder: (context, state) => const Register(),
    ),
    GoRoute(
      path: '/homepage',
      builder: (context, state) => const HomePage(),
    )
  ],
);

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _goroute,
    );
  }
}

Widget _firstpage() {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
        fontFamily: 'SunflowerMedium',
        colorScheme: ColorScheme.fromSeed(seedColor: (Colors.lightBlue[200])!)),
    home: Scaffold(
        backgroundColor: Colors.white,
        body: ListView(
          children: [
            _buildTitle(),
            const BuildLogin(),
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

class BuildLogin extends StatefulWidget {
  const BuildLogin({Key? key}) : super(key: key);

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
                      if (switchValue == true) {
                        _setAutoLogin(loginCheck!);
                      } else {
                        _delAutoLogin();
                      }
                      context.go('/homepage');
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

// 자동 로그인 확인
// 토큰 있음 : 메인 페이지
// 토큰 없음 : 로그인 화면
class TokenCheck extends StatefulWidget {
  const TokenCheck({super.key});

  @override
  State<TokenCheck> createState() => _TokenCheckState();
}

class _TokenCheckState extends State<TokenCheck> {
  bool isToken = false;

  @override
  void initState() {
    super.initState();
    _autoLoginCheck();
  }

  // 자동 로그인 설정 시, 공유 저장소에 토큰 저장
  void _autoLoginCheck() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token != null) {
      setState(() {
        isToken = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // 토큰이 있으면 메인 페이지, 없으면 로그인 페이지
      home: isToken ? const HomePage() : _firstpage(),
    );
  }
}
