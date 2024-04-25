import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class EULA extends StatefulWidget {
  const EULA({super.key});

  @override
  State<EULA> createState() => _EULAState();
}

class _EULAState extends State<EULA> {
  bool checkboxValue = false;

  Future<void> saveEULAToDatabase() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance.collection('users').doc(userId).set({
      'EULA': true,
    }, SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: FadeInUp(
        duration: const Duration(milliseconds: 3000),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(screenSize.width * 0.05,
                  screenSize.height * 0.2, 0, screenSize.height * 0.01),
              child: const Row(
                children: [
                  Text(
                    '환영합니다!\n아래 약관에 동의하시면\n낭만적인 여행이 시작됩니다',
                    style: TextStyle(fontSize: 20),
                  )
                ],
              ),
            ),
            Divider(
              color: Colors.grey[300],
              thickness: 1,
            ),
            Container(
              margin: EdgeInsets.fromLTRB(
                  screenSize.width * 0.03, 0, screenSize.width * 0.03, 0),
              child: Row(
                children: [
                  Checkbox(
                    value: checkboxValue,
                    onChanged: (bool? value) {
                      setState(() {
                        checkboxValue = value!;
                      });
                    },
                  ),
                  const Text('서비스 약관 동의'),
                  const Spacer(),
                  IconButton(
                      onPressed: () {
                        GoRouter.of(context).push('/eulaDetail');
                      },
                      icon: Icon(Icons.chevron_right_rounded,
                          color: Colors.grey[400]))
                ],
              ),
            ),
            SizedBox(
              height: screenSize.height * 0.5,
            ),
            checkboxValue == false
                ? TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        minimumSize: Size(
                            screenSize.width * 0.9, screenSize.height * 0.07),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () {},
                    child: const Text('시작하기',
                        style: TextStyle(fontSize: 15, color: Colors.white)))
                : TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.lightBlue[200],
                        minimumSize: Size(
                            screenSize.width * 0.9, screenSize.height * 0.07),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () {
                      saveEULAToDatabase();
                      GoRouter.of(context).go('/homepage');
                    },
                    child: const Text('시작하기',
                        style: TextStyle(fontSize: 15, color: Colors.white)))
          ],
        ),
      ),
    );
  }
}
