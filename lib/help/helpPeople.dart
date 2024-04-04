import 'package:flutter/material.dart';

class HelpPeople extends StatefulWidget {
  const HelpPeople({super.key});

  @override
  State<HelpPeople> createState() => _HelpPeopleState();
}

class _HelpPeopleState extends State<HelpPeople> {
  @override
  Widget build(BuildContext context) {
    // Scaffold를 사용하여 화면의 구조를 정의
    return Scaffold(
        appBar: AppBar(
          title: Text(
            '도움 주신 분들',
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
        body: Container());
  }
}
