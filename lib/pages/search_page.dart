import 'package:flutter/material.dart';
import 'package:flutter_app/model/search_model.dart';
import 'package:flutter_app/widget/search_bar.dart';
import 'package:flutter_app/dao/search_dao.dart';

const URL = "https://m.ctrip.com/restapi/h5api/globalsearch/search?source=mobileweb&action=mobileweb&keyword=";

const TYPES = [
  'channelgroup',
  'gs',
  'train',
  'cruise',
  'district',
  'food',
  'hotel',
  'huodong',
  'shop',
  'sight',
  'ticket',
  'travelgroup'
];

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
            Container(
              margin:EdgeInsets.all(1),
              child: Image(
                height: 26,
                width: 26,
                image: AssetImage(_typeImage(item.type)),
              ),
            ),
            Column(
              children: <Widget>[
                Container(
                  width: 300,
                  child: _title(item)
                ),
                Container(
                  width: 300,
                  margin: EdgeInsets.only(top: 5),
                  child: _subTitle(item)
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  _typeImage(String type){
    if(type == null) return "images/type_travelgroup.png";
    String path = 'travelgroup';
    for(final val in TYPES){
      if(type.contains(val)){
        path = val;
        break;
      }
    }
    return 'images/type_${path}.png'; 
  }

  _title(SearchItem item){
    if(item == null) return null;
    List<TextSpan>spans = [];
    spans.addAll(_keywordTextSpan(item.word,searchModel.keyword));
    spans.add(TextSpan(
      text: ' ' + (item.districtname ?? '') + ' ' + (item.zonename ?? ''),
      style: TextStyle(fontSize: 16,color: Colors.grey)
      ));
    return RichText(text: TextSpan(children: spans),);
      //Text('${item.word} ${item.districtname??''} ${item.zonename??''}'),
  }
  _subTitle(SearchItem item){
    return RichText(text: TextSpan(
      children: <TextSpan>[
        TextSpan(
          text: item.price ?? '',
          style: TextStyle(fontSize: 16,color: Colors.orange)
        ),
        TextSpan(
          text: ' ' + (item.star ?? ''),
          style: TextStyle(fontSize: 12,color: Colors.grey)
        )
      ]
    ),);
    //  return Text('${item.price??'0'} ${item.type??''}');
  }

  _keywordTextSpan(String word,String keyword){
    List<TextSpan>spans = [];
    if(word==null || word.length == 0){
      return spans;
    }
    List<String>arr=word.split(keyword);
    TextStyle normalStyle = TextStyle(fontSize: 16,color: Colors.black87);
    TextStyle keywordStyle = TextStyle(fontSize: 16,color: Colors.orange);
    for(int i=0;i<arr.length;i++){
      if((i+1)%2==0){
        spans.add(TextSpan(text:keyword,style:keywordStyle));
      }
      String val=arr[i];
      if(val != null && val.length > 0){
        spans.add(TextSpan(text:val,style: normalStyle));
      }
    }
    return spans;
  }
}