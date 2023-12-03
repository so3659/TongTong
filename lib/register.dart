import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tongtong/db/loginDB.dart';
import 'package:tongtong/login.dart';

final GoRouter _goroute = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/login',
      builder: (context, state) => Login(),
    )
  ],
);

void main() {
  runApp(Register());
}

class Register extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'SunflowerMedium'),
      home: const Scaffold(
        body: SingleChildScrollView(
            child: Column(
          children: [Agg()],
        )),
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
  GlobalKey<FormState> formKey = GlobalKey();

  final TextEditingController classNumController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController =
      TextEditingController();
  String? _classNum, _name, _id, _password, _passwordConfirm;

  @override
  Widget build(BuildContext context) {
    return Form(
        key: formKey,
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          const SizedBox(height: 30.0),
          TextFormField(
            controller: classNumController,
            textAlign: TextAlign.center,
            decoration: const InputDecoration(
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
          ),
          TextFormField(
            controller: nameController,
            textAlign: TextAlign.center,
            decoration: const InputDecoration(
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
          ),
          TextFormField(
            controller: idController,
            textAlign: TextAlign.center,
            decoration: const InputDecoration(
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
          ),
          TextFormField(
            controller: passwordController,
            textAlign: TextAlign.center,
            decoration: const InputDecoration(
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
          ),
          TextFormField(
            controller: passwordConfirmController,
            textAlign: TextAlign.center,
            decoration: const InputDecoration(
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
          ),
          FloatingActionButton(
            heroTag: 'Register',
            backgroundColor: Colors.white,
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                formKey.currentState!.save();
                final idCheck = await confirmIdCheck(_id!);
                if (idCheck != '0') {
                  if (context.mounted) {
                    showDuplicateDialog(context);
                  }
                } else {
                  insertMember(_classNum!, _name!, _id!, _password!);
                  if (context.mounted) {
                    showSuccessDialog(context);
                    context.pop();
                  }
                }
              } else {
                showFailDialog(context);
              }
            },
            child: const Text('회원가입'),
          ),
        ]));
  }
}

void showSuccessDialog(BuildContext context) async {
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
        ],
      );
    },
  );
}

void showFailDialog(BuildContext context) async {
  String result = await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('통통 회원가입'),
        content: const Text("양식을 제대로 채워주세요"),
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

void showDuplicateDialog(BuildContext context) async {
  String result = await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('통통 회원가입'),
        content: const Text("입력한 아이디가 이미 존재합니다"),
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
