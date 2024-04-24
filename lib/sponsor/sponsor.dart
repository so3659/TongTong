import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

class Sponsor extends StatefulWidget {
  const Sponsor({super.key});

  @override
  State<Sponsor> createState() => _SponsorState();
}

class _SponsorState extends State<Sponsor> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    // Scaffold를 사용하여 화면의 구조를 정의
    return Scaffold(
        appBar: AppBar(
          title: Text(
            '후원하기',
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
        body: SingleChildScrollView(
            child: Center(
                child: Column(
          children: [
            SizedBox(
              height: screenSize.height * 0.05,
            ),
            const Text('계좌번호\n',
                style: TextStyle(fontSize: 18), textAlign: TextAlign.center),
            SelectableText('카카오뱅크 3333-05-7607820',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent[700]),
                textAlign: TextAlign.center),
            SizedBox(height: screenSize.height * 0.01),
            ElevatedButton(
              onPressed: () {
                Clipboard.setData(const ClipboardData(text: '3333-05-7607820'));
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('계좌 번호가 복사되었습니다.')));
              },
              child: const Text('계좌 번호 복사'),
            ),
            SizedBox(height: screenSize.height * 0.05),
            Platform.isIOS
                ? Column(
                    children: [
                      const Text('익명 후원\n',
                          style: TextStyle(fontSize: 18),
                          textAlign: TextAlign.center),
                      SelectableText('https://toss.me/so3659',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent[700])),
                      SizedBox(height: screenSize.height * 0.01),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Clipboard.setData(const ClipboardData(
                                    text: 'https://toss.me/so3659'));
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            '복사되었습니다. 크롬 브라우저에 붙여넣기를 해주세요.')));
                              },
                              child: const Text('익명 계좌 복사'),
                            ),
                          ]),
                    ],
                  )
                : Column(children: [
                    const Text('익명 후원\n',
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center),
                    Linkify(
                      onOpen: (link) async {
                        if (!await launchUrl(Uri.parse(link.url))) {
                          throw Exception('Could not launch ${link.url}');
                        }
                      },
                      text: 'https://toss.me/so3659',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent[700]),
                      linkStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          color: Colors.blueAccent[700]),
                    ),
                  ])
          ],
        ))));
  }
}
