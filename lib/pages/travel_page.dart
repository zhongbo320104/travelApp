import "package:flutter/material.dart";
import 'package:flutter_app/dao/travel_dao.dart';
import 'package:flutter_app/dao/travel_tab_dao.dart';
import 'package:flutter_app/model/tavel_tab_model.dart';
import 'package:flutter_app/model/travel_model.dart';
import 'package:flutter_app/pages/travel_tab_page.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// tabbar page
class TravelPage extends StatefulWidget {
  TravelPage({Key key}) : super(key: key);

  _TravelPageState createState() => _TravelPageState();
}

class _TravelPageState extends State<TravelPage> with TickerProviderStateMixin {
  TabController _controller;
  List<TravelTabs> tabs = [];
  TravelTabModel travelModel;

  @override
  void initState() { 
    _controller = TabController(length: tabs.length,vsync: this);
    TravelTabDao.fetch().then((TravelTabModel model){ 
      _controller = TabController(length: model.tabs.length,vsync: this);
      setState(() {
        tabs = model.tabs;
        travelModel = model;
      });
    });
    super.initState();
  }
  @override
  void dispose() {
    _controller.dispose(); //对controller 进行回收 避免页面关闭导致性能问题
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
       child: Scaffold(
         body: Column(
           children: <Widget>[
             Container(
               color: Colors.white,
               padding: EdgeInsets.only(top:30),
               child: TabBar(
                 controller: _controller,
                 isScrollable: true,
                 labelColor: Colors.black,
                 labelPadding: EdgeInsets.fromLTRB(20,0,10,0),
                 indicator: UnderlineTabIndicator(
                   borderSide: BorderSide(color: Colors.blue,width: 3),
                   insets: EdgeInsets.only(bottom: 0)
                 ),
                 tabs: tabs.map<Tab>((TravelTabs tab){
                   return Tab(text: tab.labelName,);
                 }).toList(),
               ),
             ),
             Expanded(  // 此处用 Flexible 也可以
               flex: 1,
               child:TabBarView(  // 需给定指定高度
                  controller: _controller,
                  children: tabs.map((TravelTabs tab){
                    return TravelTabPage(travelUrl: travelModel.url,groupChannelCode: tab.groupChannelCode);
                  }).toList(),
               )
             )
           ],
         )
       ),
    );
  }
}