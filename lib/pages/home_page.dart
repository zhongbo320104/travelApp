import "package:flutter/material.dart";
import 'package:flutter_app/dao/home_dao.dart';
import 'package:flutter_app/model/common_model.dart';
import 'package:flutter_app/model/home_model.dart';
import 'package:flutter_app/navigator/local_nav.dart';
import 'package:flutter_app/utils/Api.dart';
import 'package:flutter_app/utils/DiaUtils.dart';
import "package:flutter_swiper/flutter_swiper.dart";
import "dart:convert";

import "package:dio/dio.dart";
import "dart:async";
import "dart:io";

const APPBAR_SCROLL_OFFSET = 80;

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List _imageList = [
    { "url":"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=3320548298,2876777688&fm=26&gp=0.jpg" },
    { "url":"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=1600080888,3399045086&fm=11&gp=0.jpg" },
    { "url":"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=1111943471,1325978613&fm=26&gp=0.jpg" }
  ];
  double appBarAlpha = 0;
  // 接收服务端请求过来的数据
  String resultString = "";

  List<CommonModel> localNavList;

  // 初始化数据

  @override
  void initState() {
    super.initState();
    loadData();
  }

  _onScroll(offset){
    double alpha = offset/APPBAR_SCROLL_OFFSET;
    if(alpha < 0){
      alpha = 0;
    }else if(alpha > 1){
      alpha = 1;
    }
    setState(() {
     appBarAlpha = alpha; 
    });
  }

  request(url) async {
    try{
      Response response;
      Dio dio = new Dio();
      dio.options.contentType = ContentType.parse('application/x-www-form-urlencoded');
      response = await dio.get(url);
      if(response.statusCode == 200){
        return response;
      }else {
        throw Exception('后端接口异常，请检查测试代码和服务器运行情况');
      }
    } catch(e){
      return print('error ::: ${e}');
    }
  }

  Future req() async{
    Response response;
    Dio dio = new Dio();
    dio.options.contentType = ContentType.parse('application/x-www-form-urlencoded');
    response = await dio.get('http://www.devio.org/io/flutter_app/json/home_page.json');
    return response;
  }

  loadData() async{ 
    try{
      HomeModel model = await HomeDao.fetch();
      setState((){
        // resultString = json.encode(model.config);
        // resultString = json.encode(model.gridNav);
        // resultString = json.encode(model.salesBox);
        localNavList = model.localNavList;
      });
    }catch(err){

    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
       child: Scaffold(
         backgroundColor: Color(0xfff2f2f2),
         // 移除顶部padding 适配用
         body: Stack(
           children: <Widget>[
             // 自定义appbar
             MediaQuery.removePadding(
                removeTop: true,
                context: context,
                // 监听页面滚动 NotificationListener
                child: NotificationListener(
                    onNotification: (scrollNotification){
                      if(scrollNotification is ScrollUpdateNotification 
                        // 深度表示从NotificationListener开始往下找 找到第一层 ListView 即停下来，防止swiper滑动对滚动值造成影响
                        // depth为0 表示第一层
                        && scrollNotification.depth == 0){
                        // 滚动且是列表滚动的时候
                        _onScroll(scrollNotification.metrics.pixels);
                      }
                    },
                    child: ListView(
                      children: <Widget>[
                        Container(
                          height: 160,
                          child: Swiper(
                              itemCount: _imageList.length,
                              autoplay: true,
                              itemBuilder: (BuildContext context,int index){
                                return Image.network(
                                  _imageList[index]['url'],
                                  fit:BoxFit.fill,
                                );
                              },
                              pagination: SwiperPagination(),
                            )
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(7,4,7,4),
                          child:LocalNav(localNavList:localNavList),
                        ),
                        Container(
                          height: 800,
                          child: ListTile(
                            title: Text(resultString),
                          ),
                        )
                      ],
                    ),
                )
              ),
              Opacity(
                opacity: appBarAlpha,
                child: Container(
                  height: 80,
                  decoration: BoxDecoration(color: Colors.white),
                  child: Center(
                    child: Padding(
                      padding:EdgeInsets.only(top: 20),child: Text('首页'),
                    ),
                  ),
                ),
              )
           ],
         )
       ),
    );
  }
}