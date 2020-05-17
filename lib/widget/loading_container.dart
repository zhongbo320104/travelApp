import 'package:flutter/material.dart';
// 加载进度条
class LoadingContainer extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final bool cover;

  const LoadingContainer({Key key,@required this.child,this.cover=false,@required this.isLoading}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 如果不是cover 不是loading 就显示child 否则显示loadingview
    return !cover?!isLoading?child:_loadingView:Stack(
      children: <Widget>[
        child,isLoading?_loadingView:null
      ],
    );
  }
  Widget get _loadingView{
    return Center(
      child:CircularProgressIndicator(),
    );
  }
}