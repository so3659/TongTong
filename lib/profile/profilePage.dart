import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                CircleAvatar(
                  backgroundColor: Theme.of(context).cardColor,
                  backgroundImage: const AssetImage(
                      'assets/images/tong_logo.png'), // 프로필 이미지 경로
                  radius: 50, // 원하는 크기로 조절
                ),
                const SizedBox(height: 10), // 상하 여백
                const Text(
                  'kso3659@gmail.com', // 사용자 email
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  '김성욱',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  '동토리',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 15), // 상하 여백
                _buildRoundedButton('내가 쓴 글'),
                _buildRoundedButton('댓글 단 글'),
                _buildRoundedButton('닉네임 변경'),
                _buildRoundedButton('프로필 사진 변경'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildRoundedButton(String title) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 50), // 좌우 여백
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          shape: const StadiumBorder(), // 버튼의 모서리를 둥글게
          side: BorderSide(width: 2, color: Colors.lightBlue[200]!), // 테두리 색상
        ),
        onPressed: () {
          // 버튼이 눌렸을 때의 액션
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0), // 버튼 내부 상하 패딩
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.black, // 텍스트 색상
              fontSize: 16, // 텍스트 크기
            ),
          ),
        ),
      ),
    ),
  );
}
