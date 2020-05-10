import "package:flutter/material.dart";

class SearchPage extends StatefulWidget {
  SearchPage({Key key}) : super(key: key);

  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
       child: Scaffold(
         body: Center(
           child: Text('search page'),
         ),
       ),
    );
  }
}