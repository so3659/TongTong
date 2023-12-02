import 'package:flutter/material.dart';

void main() {
  runApp(Register());
}

class Register extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'SunflowerMedium'),
      home: Scaffold(
        body: ListView(
          children: [Agg()],
        ),
      ),
    );
  }
}

class Agg extends StatefulWidget {
  const Agg({Key? key}) : super(key: key);

  @override
  State<Agg> createState() => AggState();
}

class AggState extends State<Agg> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController classNumController = TextEditingController();
  String _classNum = '';
  final TextEditingController nameController = TextEditingController();
  String _name = '';
  final TextEditingController idController = TextEditingController();
  String _id = '';
  final TextEditingController passwordController = TextEditingController();
  String _password = '';
  final TextEditingController passwordConfirmController =
      TextEditingController();
  String _passwordConfirm = '';

  @override
  Widget build(BuildContext context) {
    return Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Form(
                child: TextFormField(
              controller: classNumController,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: '학번',
                hintStyle: TextStyle(color: Colors.black),
              ),
              autovalidateMode: AutovalidateMode.always,
              onSaved: (value) {
                setState(() {
                  _classNum = value as String;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '학번을 입력해주세요';
                }
                return null;
              },
            )),
            Form(
                child: TextFormField(
              controller: nameController,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: '이름',
                hintStyle: TextStyle(color: Colors.black),
              ),
              autovalidateMode: AutovalidateMode.always,
              onSaved: (value) {
                setState(() {
                  _name = value as String;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '이름을 입력해주세요';
                }
                return null;
              },
            )),
            Form(
                child: TextFormField(
              controller: idController,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: '아이디',
                hintStyle: TextStyle(color: Colors.black),
              ),
              autovalidateMode: AutovalidateMode.always,
              onSaved: (value) {
                setState(() {
                  _id = value as String;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '이름을 입력해주세요';
                }
                return null;
              },
            )),
            Form(
                child: TextFormField(
              controller: passwordController,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: '비밀번호',
                hintStyle: TextStyle(color: Colors.black),
              ),
              autovalidateMode: AutovalidateMode.always,
              onSaved: (value) {
                setState(() {
                  _password = value as String;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '비밀번호를 입력해주세요';
                }
                return null;
              },
            )),
            Form(
                child: TextFormField(
              controller: passwordConfirmController,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: '비밀번호 확인',
                hintStyle: TextStyle(color: Colors.black),
              ),
              autovalidateMode: AutovalidateMode.always,
              onSaved: (value) {
                setState(() {
                  _passwordConfirm = value as String;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '비밀번호를 확인해주세요';
                }
                if (value != passwordController.text) {
                  return '비밀번호가 일치하지 않습니다';
                }
                return null;
              },
            )),
            FloatingActionButton(
              heroTag: 'Register',
              backgroundColor: Colors.white,
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$_name')),
                  );
                } else {
                  showAlertDialog(context);
                }
              },
              child: const Text('회원가입'),
            )
          ],
        ));
  }
}

void showAlertDialog(BuildContext context) async {
  String result = await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('통통 회원가입'),
        content: const Text("통통의 일원이 되신걸 축하드립니다!"),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.pop(context, "OK");
            },
          ),
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.pop(context, "Cancel");
            },
          ),
        ],
      );
    },
  );
}
