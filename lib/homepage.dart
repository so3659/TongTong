import 'package:flutter/material.dart';

void main() {
  runApp(Homepage());
}

class Homepage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Test'),
        ),
      ),
    );
  }
}
