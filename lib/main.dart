import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/navigator/tab_navigator.dart';

void main(){
  // 强制竖屏
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown
  // ]);
  runApp(new MyApp()); 
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo2',
      theme: ThemeData( 
        primarySwatch: Colors.blue,
      ),
      home: TabNavigator(),
    );
  }
}
