import 'package:flutter/material.dart';

class MemoUpdator extends ChangeNotifier {
  List _memoList = [];
  List get memoList => _memoList;

  // 리스트 업데이트
  void updateList(List newList) {
    _memoList = newList;
    notifyListeners();
  }
}
