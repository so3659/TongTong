import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';
import 'package:tongtong/theme/theme.dart';
import 'package:tongtong/widgets/customWidgets.dart';
import 'package:go_router/go_router.dart';
import 'package:tongtong/db/memoDB.dart';
import 'package:provider/provider.dart';
import 'package:tongtong/community/memoListProvider.dart';

class MakePost extends StatefulWidget {
  const MakePost({Key? key}) : super(key: key);

  @override
  State<MakePost> createState() => MakePostState();
}

class MakePostState extends State<MakePost> {
  final TextEditingController contentController = TextEditingController();

  @override
  void dispose() {
    contentController.dispose();
    super.dispose();
  }

  Future<void> getMemoList() async {
    List memoList = [];
    // DB에서 메모 정보 호출
    var result = await selectMemoALL();

    print(result?.numOfRows);

    // 메모 리스트 저장
    if (result != null) {
      for (final row in result.rows) {
        print('Row: $row');
        var memoInfo = {
          'id': row.colByName('id'),
          'userIndex': row.colByName('userIndex'),
          'userName': row.colByName('userName'),
          'memoContent': row.colByName('memoContent'),
          'createDate': row.colByName('createDate'),
        };
        memoList.add(memoInfo);
      }
    }

    print('MemoMainPage - getMemoList : $memoList');
    if (mounted) {
      context.read<MemoUpdator>().updateList(memoList);
    }
  }

  void _onImageIconSelected(File file) {
    setState(() {
      _image = file;
    });
  }

  File? _image;

  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   theme: ThemeData(
    //       fontFamily: 'SunflowerMedium',
    //       colorScheme:
    //           ColorScheme.fromSeed(seedColor: (Colors.lightBlue[200])!)),
    //   home:
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
          icon: const Icon(Icons.close),
          color: Colors.lightBlue[200],
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              String content = contentController.text;
              await addMemo(content);

              setState(() {
                // 메모 리스트 새로고침
                print("MemoMainPage - addMemo/setState");
                getMemoList();
              });

              Navigator.of(context, rootNavigator: true).pop();
            },
            icon: const Icon(Icons.send),
            color: Colors.lightBlue[200],
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          const SingleChildScrollView(),
          Expanded(
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'What\'s happening?',
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 16),
              ),
              keyboardType: TextInputType.multiline,
              maxLines: null,
              controller: contentController,
            ),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: (Colors.grey[200])!)),
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                child: Row(
                  children: <Widget>[
                    IconButton(
                        onPressed: () {},
                        icon: customIcon(context,
                            icon: AppIcon.image,
                            isTwitterIcon: true,
                            iconColor: Colors.lightBlue[200])),
                    IconButton(
                        onPressed: () {},
                        icon: customIcon(context,
                            icon: AppIcon.camera,
                            isTwitterIcon: true,
                            iconColor: Colors.lightBlue[200])),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
