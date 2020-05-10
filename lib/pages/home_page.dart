import "package:flutter/material.dart";
import "package:flutter_swiper/flutter_swiper.dart";

const APPBAR_SCROLL_OFFSET = 80;
class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List _imageList = [
    'https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=3320548298,2876777688&fm=26&gp=0.jpg',
    'https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=1600080888,3399045086&fm=11&gp=0.jpg',
    'https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=1111943471,1325978613&fm=26&gp=0.jpg'
  ];
  double appBarAlpha = 0;
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
  @override
  Widget build(BuildContext context) {
    return Container(
       child: Scaffold(
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
                                  _imageList[index],
                                  fit:BoxFit.fill,
                                );
                              },
                              pagination: SwiperPagination(),
                            )
                        ),
                        Container(
                          height: 800,
                          child: ListTile(
                            title: Text('aha'),
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