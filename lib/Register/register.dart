import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tongtong/Register/login.dart';
import 'package:tongtong/db/loginDB.dart';
import 'package:animate_do/animate_do.dart';

// final GoRouter _goroute = GoRouter(
//   routes: <RouteBase>[
//     GoRoute(path: '/login', builder: (context, state) => const Login())
//   ],
// );

// void main() {
//   runApp(const Register());
// }

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          fontFamily: 'SunflowerMedium',
          colorScheme:
              ColorScheme.fromSeed(seedColor: (Colors.lightBlue[200])!)),
      home: const Agg(),
    );
  }
}

class Agg extends StatefulWidget {
  const Agg({Key? key}) : super(key: key);

  @override
  State<Agg> createState() => AggState();
}

class AggState extends State<Agg> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController classNumController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController =
      TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  String? _classNum, _name, _id, _password, _passwordConfirm, _userName;

  @override
  void dispose() {
    classNumController.dispose();
    nameController.dispose();
    idController.dispose();
    passwordController.dispose();
    passwordConfirmController.dispose();
    userNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Form(
                key: formKey,
                child: FadeInUp(
                    duration: const Duration(milliseconds: 1800),
                    child: Center(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                          Container(
                            margin: const EdgeInsets.fromLTRB(10, 50, 10, 5),
                            height: 150,
                            width: 150,
                            child: const Image(
                                image:
                                    AssetImage('assets/images/tong_logo.png')),
                          ),
                          const SizedBox(height: 30.0),
                          SizedBox(
                            width: 350,
                            child: TextFormField(
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
                          ),
                          SizedBox(
                            width: 350,
                            child: TextFormField(
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
                          ),
                          SizedBox(
                            width: 350,
                            child: TextFormField(
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
                                  return '아이디를 입력해주세요';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            width: 350,
                            child: TextFormField(
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
                          ),
                          SizedBox(
                            width: 350,
                            child: TextFormField(
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
                          ),
                          SizedBox(
                            width: 350,
                            child: TextFormField(
                              controller: userNameController,
                              textAlign: TextAlign.center,
                              decoration: const InputDecoration(
                                hintText: '닉네임',
                                hintStyle: TextStyle(color: Colors.black),
                              ),
                              autovalidateMode: AutovalidateMode.always,
                              onSaved: (value) {
                                setState(() {
                                  _userName = value as String;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '닉네임을 입력해주세요';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: 150,
                            child: FloatingActionButton(
                              heroTag: 'Register',
                              backgroundColor: Colors.white,
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  formKey.currentState!.save();
                                  final idCheck = await confirmIdCheck(_id!);
                                  final userNameCheck =
                                      await confirmUserNameCheck(_userName!);
                                  if (idCheck != '0') {
                                    if (context.mounted) {
                                      showIdDuplicateDialog(context);
                                    }
                                  } else if (userNameCheck != '0') {
                                    if (context.mounted) {
                                      showUserNameDuplicateDialog(context);
                                    }
                                  } else {
                                    if (context.mounted) {
                                      showSuccessDialog(context);
                                      context.pop();
                                    }
                                    insertMember(
                                        classNumController.text,
                                        nameController.text,
                                        idController.text,
                                        passwordController.text,
                                        userNameController.text);
                                  }
                                } else {
                                  showFailDialog(context);
                                }
                              },
                              child: const Text('회원가입'),
                            ),
                          )
                        ]))))));
  }
}

void showSuccessDialog(BuildContext context) async {
  var result = await showDialog(
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

void showIdDuplicateDialog(BuildContext context) async {
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

void showUserNameDuplicateDialog(BuildContext context) async {
  String result = await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('통통 회원가입'),
        content: const Text("입력한 닉네임이 이미 존재합니다"),
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
