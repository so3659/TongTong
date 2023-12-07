import 'package:mysql_client/mysql_client.dart';

Future<MySQLConnection> dbConnector() async {
  print("Connecting to mysql server...");

  // MySQL 접속 설정
  final conn = await MySQLConnection.createConnection(
    host: '10.0.2.2',
    port: 3306,
    userName: 'root',
    password: 'so36593659',
    databaseName: 'tongtong', // optional
  );

  await conn.connect();

  print("Connected");

  return conn;
}
