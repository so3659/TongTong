import 'package:flutter/material.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tongtong/db/mySqlConnector.dart';

Future<IResultSet?> selectMemoALL() async {
  // MySQL 접속 설정
  final conn = await dbConnector();

  // 유저 식별 정보 호출
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('token');

  IResultSet result;

  // 유저의 모든 글 보기
  try {
    result = await conn.execute(
        "SELECT p.id, u.userIndex, u.userName, memoContent, createDate FROM post AS p LEFT JOIN users AS u ON p.userIndex = u.userIndex WHERE p.userIndex = :token",
        {"token": token});
    if (result.numOfRows > 0) {
      return result;
    }
  } catch (e) {
    print('Error : $e');
  } finally {
    await conn.close();
  }
  return null;
}

// 메모 작성
Future<String?> addMemo(String content) async {
  // MySQL 접속 설정
  final conn = await dbConnector();

  // 유저 식별 정보 호출
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('token');

  // 쿼리 수행 결과 저장 변수
  IResultSet? result;

  // 유저의 아이디를 저장할 변수
  String? userName;

  // 메모 추가
  try {
    // 유저 이름 확인
    result = await conn.execute(
      "SELECT userName FROM users WHERE id = :token",
      {"token": token},
    );

    // 유저 이름 저장
    for (final row in result.rows) {
      userName = row.colAt(0);
    }

    // 글 추가
    result = await conn.execute(
      "INSERT INTO post (userIndex, memoContent) VALUES (:userIndex, :content)",
      {"userIndex": token, "content": content},
    );
  } catch (e) {
    print(token);
    print('Error : $e');
  } finally {
    await conn.close();
  }
  // 예외처리용 에러코드 '-1' 반환
  return '-1';
}

// 메모 수정
Future<void> updateMemo(String id, String title, String content) async {
  // MySQL 접속 설정
  final conn = await dbConnector();

  // 유저 식별 정보 호출
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('token');

  // 쿼리 수행 결과 저장 변수
  IResultSet? result;

  // 메모 수정
  try {
    await conn.execute(
        "UPDATE memo SET memoTitle = :title, memoContent = :content where id = :id and userIndex = :token",
        {"id": id, "token": token, "title": title, "content": content});
  } catch (e) {
    print('Error : $e');
  } finally {
    await conn.close();
  }
}

// 특정 메모 조회
Future<IResultSet?> selectMemo(String id) async {
  // MySQL 접속 설정
  final conn = await dbConnector();

  // 유저 식별 정보 호출
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('token');

  // 쿼리 수행 결과 저장 변수
  IResultSet? result;

  // 메모 수정
  try {
    result = await conn.execute(
        "SELECT m.id, userIndex, u.userName,  memoContent, createDate FROM memo AS m LEFT JOIN users AS u ON m.userIndex = u.userIndex WHERE userIndex = :token and m.id = :id",
        {"token": token, "id": id});
    return result;
  } catch (e) {
    print('Error : $e');
  } finally {
    await conn.close();
  }

  return null;
}

// 특정 메모 삭제
Future<void> deleteMemo(String id) async {
  // MySQL 접속 설정
  final conn = await dbConnector();

  // 메모 수정
  try {
    await conn.execute("DELETE FROM memo WHERE id = :id", {"id": id});
  } catch (e) {
    print('Error : $e');
  } finally {
    await conn.close();
  }
}
