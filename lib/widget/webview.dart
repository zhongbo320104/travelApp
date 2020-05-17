import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class WebView extends StatefulWidget {
  final String url;
  final String statuBarColor;
  final String title;
  final bool hideAppBar;
  final bool backForbid;

  WebView({Key key,this.url,this.statuBarColor,this.title,this.backForbid,this.hideAppBar}) : super(key: key);
  _WebViewState createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  final webviewReference = FlutterWebviewPlugin();
  StreamSubscription<String> _onUrlChanged; 
  StreamSubscription<WebViewStateChanged> _onStateChanged;
  StreamSubscription<WebViewHttpError> _onHttpError;

  @override
  void initState() {
    super.initState();
    webviewReference.close();
    _onUrlChanged = webviewReference.onUrlChanged.listen((String url){

    });
    _onStateChanged = webviewReference.onStateChanged.listen((WebViewStateChanged state){
      switch(state.type){
        case WebViewState.startLoad:
        break;
        default:
        break;
      }
    });
    _onHttpError = webviewReference.onHttpError.listen((WebViewHttpError error){
      print(error);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _onUrlChanged.cancel();
    _onHttpError.cancel();
    _onStateChanged.cancel();
    webviewReference.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 初始化状态颜色
    String statusBarColorStr = widget.statuBarColor ?? 'ffffff';
    Color backButtonColor;
    if(statusBarColorStr == 'ffffff'){
      backButtonColor = Colors.black;
    }else {
      backButtonColor = Colors.white;
    }
    return Scaffold(
      body: Column(
        children: <Widget>[
           // 字符串拼接成int的色号
           _appBar(Color(int.parse('0xff'+statusBarColorStr)),backButtonColor),
           Expanded(child: WebviewScaffold(
             url: widget.url,
             withZoom:true,
             withLocalStorage:true,
             hidden: true,
             initialChild: Container(
               color: Colors.white,
               child: Center(child: Text('Waiting...'),),
             )
           ))
        ],
      ),
    );
  }

  _appBar(Color backgroundColor, Color backButtonColor){
    if(widget.hideAppBar??false){  // widget 对象相当于 构造函数中的this？
      return Container(
        color: backgroundColor,
        height: 30,
      );
    }
    return Container(
      child: FractionallySizedBox(  // 用于撑满整个屏幕
        widthFactor: 1,
        child: Stack(
          children: <Widget>[
            GestureDetector(
              child: Container(
                margin: EdgeInsets.only(left: 10),
                child: Icon(
                  Icons.close,
                  color: backButtonColor,
                  size: 26,
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  widget.title??'',
                  style: TextStyle(color: backButtonColor,fontSize: 20),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

}