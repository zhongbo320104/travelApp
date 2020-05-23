import 'package:flutter/material.dart';
import 'package:flutter_app/model/search_model.dart';
import 'package:flutter_app/widget/search_bar.dart';
import 'package:flutter_app/dao/search_dao.dart';

const URL = "https://m.ctrip.com/restapi/h5api/globalsearch/search?source=mobileweb&action=mobileweb&keyword=";

String showText = "";
class SearchPage extends StatefulWidget {
  final bool hideLeft;
  final String searchUrl;
  final String keyword;
  final String hint;


  SearchPage({Key key,this.hideLeft,this.hint,this.keyword,this.searchUrl = URL}) : super(key: key);

  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  SearchModel searchModel;
  String keyword;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // _appBar(),  // 自定义appBar
      //  appBar: AppBar(),
       body: Column(children: <Widget>[
         _appBar(),
         MediaQuery.removePadding(
           removeTop: true,
           context: context,
           child: Expanded(
            flex: 1,
            child: ListView.builder(
                itemCount: searchModel?.data?.length??0,
                itemBuilder: (BuildContext context,int position){
                  return _item(position);
                },
              ),
          ),
         )
       ],),
    );
  }
  _onTextChange(text){
    keyword = text;
    if(text.length == 0){
        setState(() {
        searchModel = null; 
        });
        return; 
    }
    String url = widget.searchUrl + text;
    SearchDao.fetch(url,text).then((SearchModel model){
      // 当本地传递的text 与后端响应时 text 保持一致则认为是发生了更新，否则容易出现bug
      if(model.keyword == keyword){
        setState(() {
          searchModel = model; 
        });
      }
    }).catchError((err){
       print(err);
    });
  }

  _appBar(){
    return Column(children: <Widget>[
      Container(
        decoration:BoxDecoration(
          gradient: LinearGradient(
            // appbar 渐变
            colors:[Color(0x66000000),Colors.transparent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )
        ),
        child: Container(
          padding: EdgeInsets.only(top:10),
          height: 80,
          decoration: BoxDecoration(color:Colors.white ),
          child: SearchBar(
            hideLeft: widget.hideLeft,
            defaultText: widget.keyword,
            hint: widget.hint,
            leftButtonClick: (){
              Navigator.pop(context);
            },
            onChanged: _onTextChange,
          ),
        ),
      )
    ],);
  }

  _item(int position){
    if(searchModel == null || searchModel.data == null) return null;
    SearchItem item = searchModel.data[position];
    return GestureDetector(
      onTap: (){
         
      },
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border:Border(bottom: BorderSide(width: 0.3,color: Colors.grey))
        ),
        child: Row(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  width: 300,
                  child: Text('${item.word} ${item.districtname??''} ${item.zonename??''}'),
                ),
                Container(
                  width: 300,
                  child: Text('${item.price??'0'} ${item.type??''}'),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}