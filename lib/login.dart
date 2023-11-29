import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget login = _buildLogin();
    Widget register = _buildRegister();
    Widget title = _buildTitle();

    return MaterialApp(
      theme: ThemeData(fontFamily: 'SunflowerMedium'),
      home: Scaffold(
          backgroundColor: Colors.white,
          body: ListView(
            children: [
              title,
              login,
              register,
            ],
          )),
    );
  }
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

Widget _buildLogin() {
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
          child: const TextField(
            textAlign: TextAlign.center,
            decoration: InputDecoration(
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
          child: const TextField(
            textAlign: TextAlign.center,
            decoration: InputDecoration(
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
              onPressed: () {},
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100)),
              child: const Text('로그인'),
            )),
      ),
    ],
  );
}

Widget _buildRegister() {
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
              onPressed: () {},
            ),
          ),
        ),
      ),
    ],
  );
}
