import 'package:flutter/material.dart';

void main() {
  runApp(Register());
}

class Register extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget classNum = _buildClassNum();
    Widget name = _buildName();
    Widget id = _buildId();
    Widget password = _buildPassword();
    Widget passwordCheck = _buildPasswordCheck();
    Widget create = _buildCreate();

    return MaterialApp(
      theme: ThemeData(fontFamily: 'SunflowerMedium'),
      home: Scaffold(
        body: ListView(
          children: [
            classNum,
            name,
            id,
            password,
            passwordCheck,
            create,
          ],
        ),
      ),
    );
  }
}

Widget _buildClassNum() {
  return Container(
    margin: const EdgeInsets.fromLTRB(20, 15, 20, 0),
    padding: const EdgeInsets.all(20),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.grey[350],
        borderRadius: BorderRadius.circular(38.5),
      ),
      child: const TextField(
        textAlign: TextAlign.center,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "학번",
            hintStyle: TextStyle(color: Colors.black)),
      ),
    ),
  );
}

Widget _buildName() {
  return Container(
    margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
    padding: const EdgeInsets.all(20),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.grey[350],
        borderRadius: BorderRadius.circular(38.5),
      ),
      child: const TextField(
        textAlign: TextAlign.center,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "이름",
            hintStyle: TextStyle(color: Colors.black)),
      ),
    ),
  );
}

Widget _buildId() {
  return Container(
    margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
    padding: const EdgeInsets.all(20),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.grey[350],
        borderRadius: BorderRadius.circular(38.5),
      ),
      child: const TextField(
        textAlign: TextAlign.center,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "아이디",
            hintStyle: TextStyle(color: Colors.black)),
      ),
    ),
  );
}

Widget _buildPassword() {
  return Container(
    margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
    padding: const EdgeInsets.all(20),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.grey[350],
        borderRadius: BorderRadius.circular(38.5),
      ),
      child: const TextField(
        obscureText: true,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "비밀번호",
            hintStyle: TextStyle(color: Colors.black)),
      ),
    ),
  );
}

Widget _buildPasswordCheck() {
  return Container(
    margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
    padding: const EdgeInsets.all(20),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.grey[350],
        borderRadius: BorderRadius.circular(38.5),
      ),
      child: const TextField(
        obscureText: true,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "이름",
            hintStyle: TextStyle(color: Colors.black)),
      ),
    ),
  );
}

Widget _buildCreate() {
  return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      padding: const EdgeInsets.all(20),
      child: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {},
        child: const Text('회원가입'),
      ));
}
