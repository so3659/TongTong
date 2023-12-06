// 선택한 항목의 내용을 보여주는 추가 페이지
// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tongtong/memoMainPage.dart';
import 'package:tongtong/memoListProvider.dart';
import 'package:tongtong/db/memoDB.dart';

class ContentPage extends StatefulWidget {
  // 생성자 초기화
  final dynamic content;
  const ContentPage({Key? key, required this.content}) : super(key: key);

  @override
  State<ContentPage> createState() => _ContentState(content: content);
}

class _ContentState extends State<ContentPage> {
  // 부모에게 받은 생성자 값 초기화
  final dynamic content;
  _ContentState({required this.content});

  // 메모의 정보를 저장할 변수
  List memoInfo = [];

  // 앱 바 메모 수정 버튼을 이용하여 메모를 수정할 제목과 내용
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  // 앱 바 메모 수정 클릭 이벤트
  Future<void> updateItemEvent(BuildContext context) {
    // 앱 바 메모 수정 버튼을 이용하여 메모를 수정할 제목과 내용
    TextEditingController titleController =
        TextEditingController(text: memoInfo[0]['memoTitle']);
    TextEditingController contentController =
        TextEditingController(text: memoInfo[0]['memoContent']);

    // 다이얼로그 폼 열기
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('메모 수정'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: '제목',
                ),
              ),
              TextField(
                controller: contentController,
                maxLines: null, // 다중 라인 허용
                decoration: const InputDecoration(
                  labelText: '내용',
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('수정'),
              onPressed: () async {
                String memoTitle = titleController.text;
                String memoContent = contentController.text;

                Navigator.of(context).pop();

                print('memoTitle : $memoTitle');
                // 메모 수정
                await updateMemo(content['id'], memoTitle, memoContent);

                // 업데이트 된 메모 정보 호출
                updateRefresh();

                // 메모 내용 업데이트
                setState(() {
                  memoInfo = context.watch<MemoUpdator>().memoList;
                });
              },
            ),
          ],
        );
      },
    );
  }

  // 메모 삭제
  void deleteItemEvent(BuildContext context) {
    deleteMemo(memoInfo[0]['id']);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MyMemoPage(),
      ),
    );
  }

  // 메모 수정시 화면 새로고침
  Future<void> updateRefresh() async {
    List memoList = [];
    // DB에서 메모 정보 호출
    var result = await selectMemo(content['id']);

    // 특정 메모 정보 저장
    for (final row in result!.rows) {
      var memo = {
        'id': row.colByName('id'),
        'userIndex': row.colByName('userIndex'),
        'userName': row.colByName('userName'),
        'memoTitle': row.colByName('memoTitle'),
        'memoContent': row.colByName('memoContent'),
        'createDate': row.colByName('createDate'),
        'updateDate': row.colByName('updateDate')
      };
      memoList.add(memo);
    }
    print("memo update : $memoList");
    context.read<MemoUpdator>().updateList(memoList);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var memo = {
      'id': content['id'],
      'userIndex': content['userIndex'],
      'userName': content['userName'],
      'memoTitle': content['memoTitle'],
      'memoContent': content['memoContent'],
      'createDate': content['createDate'],
      'updateDate': content['updateDate']
    };
    List memoList = [];
    memoList.add(memo);

    // 빌드가 완료된 후 Provider의 데이터 읽기
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MemoUpdator>().updateList(memoList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // 좌측 상단의 뒤로 가기 버튼
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, 1);
          },
        ),
        title: const Text('메모 상세 보기'),
        actions: [
          IconButton(
            onPressed: () => updateItemEvent(context),
            icon: const Icon(Icons.edit),
            tooltip: "메모 수정",
          ),
          IconButton(
            onPressed: () => deleteItemEvent(context),
            icon: const Icon(CupertinoIcons.delete_solid),
            tooltip: "메모 삭제",
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Builder(builder: (context) {
            // 특정 메모 정보 출력
            memoInfo = context.watch<MemoUpdator>().memoList;

            return Stack(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(),
                    Text(
                      memoInfo[0]['memoTitle'],
                      style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const SizedBox(height: 35),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [Text('작성자 : ${memoInfo[0]['userName']}')],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [Text('작성일 : ${memoInfo[0]['createDate']}')],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [Text('수정일 : ${memoInfo[0]['updateDate']}')],
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: SizedBox(
                          height: double.infinity,
                          width: double.infinity,
                          child: Text(
                            memoInfo[0]['memoContent'],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
