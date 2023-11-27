import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:tongtong/login.dart';
=======
import 'package:animate_do/animate_do.dart';
>>>>>>> 10dd1d634b59c65f6041310c89a24da06b4ee882

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return MaterialApp(
      home: Login(),
    );
  }
}
=======
    Widget login = _buildLogin();
    Widget register = _buildRegister();
    Widget title = _buildTitle();

    return MaterialApp(
      theme: ThemeData(fontFamily: 'Gugi'),
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
      duration: Duration(milliseconds: 1800),
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
        duration: Duration(milliseconds: 1800),
        child: Container(
          margin: EdgeInsets.fromLTRB(30, 15, 30, 15),
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.grey[350],
            borderRadius: BorderRadius.circular(38.5),
          ),
          child: TextField(
            textAlign: TextAlign.center,
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "아이디 입력",
                hintStyle: TextStyle(color: Colors.black)),
          ),
        ),
      ),
      FadeInUp(
        duration: Duration(milliseconds: 1800),
        child: Container(
          margin: EdgeInsets.fromLTRB(30, 15, 30, 15),
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.grey[350],
            borderRadius: BorderRadius.circular(38.5),
          ),
          child: TextField(
            textAlign: TextAlign.center,
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "비밀번호 입력",
                hintStyle: TextStyle(color: Colors.black)),
          ),
        ),
      ),
      FadeInUp(
        duration: Duration(milliseconds: 1800),
        child: Container(
          margin: EdgeInsets.fromLTRB(30, 15, 30, 15),
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(38.5),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(4.0, 4.0),
                blurRadius: 15.0,
                spreadRadius: 1.0,
              ),
              BoxShadow(
                color: Colors.white,
                offset: Offset(-4.0, -4.0),
                blurRadius: 15.0,
                spreadRadius: 1.0,
              ),
            ],
          ),
          child: TextField(
            textAlign: TextAlign.center,
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "로그인",
                hintStyle: TextStyle(color: Colors.black)),
          ),
        ),
      ),
    ],
  );
}

Widget _buildRegister() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: <Widget>[
      FadeInUp(
        duration: Duration(milliseconds: 1800),
        child: Container(
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Center(
              child: Text('비밀번호 찾기'),
            )),
      ),
      FadeInUp(
        duration: Duration(milliseconds: 1800),
        child: Container(
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Center(
            child: Text('회원가입'),
          ),
        ),
      ),
    ],
  );
}
>>>>>>> 10dd1d634b59c65f6041310c89a24da06b4ee882
