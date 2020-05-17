import "package:flutter/material.dart";
import 'package:flutter_app/model/common_model.dart';
import 'package:flutter_app/pages/home_page.dart';
import 'package:flutter_app/pages/my_page.dart';
import 'package:flutter_app/pages/search_page.dart';
import 'package:flutter_app/pages/travel_page.dart';

class SubNav extends StatelessWidget {
  final List<CommonModel> subNavList;
  const SubNav({Key key, this.subNavList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Padding(
          padding: EdgeInsets.all(7),
          child: _items(context),
        ),
      ),
    );
  }

  _items(BuildContext context){
    if(subNavList == null) return null;
    List<Widget> items = [];
    subNavList.forEach((model){
      items.add(_item(context,model));
    });
    // 计算每一行显示的数量
    int separate = (subNavList.length / 2 + 0.5).toInt();
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: items.sublist(0,separate)
        ),
        Padding(
          padding: EdgeInsets.only(top:10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: items.sublist(separate,subNavList.length),
          ),
        )
      ],
    );
  }
  Widget _item(BuildContext context,CommonModel model){
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: (){

        },
        child: Column(children: <Widget>[
          Image.network(
            model.icon,
            height: 18,
            width: 18,
          ),
          Padding(
            padding: EdgeInsets.only(top: 3),
            child: Text(
              model.title,
              style: TextStyle(fontSize: 12),
            ),
          )
        ],),
      ),
    );
  }
}