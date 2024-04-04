import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class MakeAppointment extends StatefulWidget {
  const MakeAppointment({super.key});

  @override
  State<MakeAppointment> createState() => _MakeAppointmentState();
}

class _MakeAppointmentState extends State<MakeAppointment> {
  final String _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random();
  final TextEditingController eventController = TextEditingController();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  DateTime date = DateTime.now();
  @override
  Widget build(BuildContext context) {
    // Scaffold를 사용하여 화면의 구조를 정의
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '일정 추가',
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(color: Colors.black87),
        ),
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.0),
          child: Container(
            color: Colors.grey.shade200,
            height: 1.0,
          ),
        ), // 상단 앱 바에 표시될 타이틀 설정
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          ),
          ElevatedButton(
            onPressed: () async {
              final selectedDate = await showDatePicker(
                context: context,
                initialDate: date,
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
                initialEntryMode: DatePickerEntryMode.calendarOnly,
              );
              if (selectedDate != null) {
                setState(() {
                  date = selectedDate;
                });
              }
            },
            child: Text(
              "${date.year.toString()}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const ButtonBar(), // 버튼들을 가로로 나열하는 위젯
                TextField(
                  controller: eventController,
                  decoration: const InputDecoration(
                    hintText: "일정 추가", // 힌트 텍스트 설정
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                  onPressed: () async {
                    String postKey = getRandomString(16);
                    if (eventController.text.isEmpty) return;
                    await FirebaseFirestore.instance
                        .collection('events')
                        .doc(postKey)
                        .set({
                      'title': eventController.text,
                      'date': Timestamp.fromDate(date),
                      'uid': FirebaseAuth.instance.currentUser!.uid,
                      'documentId': postKey,
                    });
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                          '일정이 추가되었습니다.'), //snack bar의 내용. icon, button같은것도 가능하다.
                      duration: Duration(seconds: 3), //올라와있는 시간
                    ));
                    Navigator.pop(context);
                    eventController.clear();
                    setState(() {});
                  },
                  child: const Text('저장'), // 버튼에 표시될 텍스트 설정
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
