import "package:flutter/material.dart";

class MyPage extends StatefulWidget {
  MyPage({Key key}) : super(key: key);

  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
       child: Scaffold(
         body: Center(
           child: Text('my page'),
         ),
       ),
    );
  }
}