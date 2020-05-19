import 'package:flutter/material.dart';

// 两种使用场景 首页 与 搜索页 外加一种高亮的状态
enum SearchBarType {home,nomal,homeLight}
class SearchBar extends StatefulWidget {
  final bool enabled; // 是否禁止搜索
  final bool hideLeft; 
  final SearchBarType searchBarType;
  final String hint;  // 默认提示文案
  final String defaultText;
  final void Function() leftButtonClick;
  final void Function() rightButtonClick;
  final void Function() speackClick;
  final void Function() inputBoxClick;
  final ValueChanged<String> onChanged;
  SearchBar({
    Key key,
    this.defaultText,
    this.enabled= true,
    this.hideLeft,
    this.hint,
    this.inputBoxClick,
    this.leftButtonClick,
    this.rightButtonClick,
    this.searchBarType = SearchBarType.nomal,
    this.speackClick,
    this.onChanged
    }) : super(key: key);

  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  bool showClear = false; // 是否显示clear按钮
  final TextEditingController _controller = TextEditingController();  // 监听文字变化
  @override
  void initState(){
    if(widget.defaultText != null){
      setState(() {
       _controller.text = widget.defaultText; 
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
       child: widget.searchBarType == SearchBarType.nomal?
       _genNormalSearch():_genHomeSearch(),
    );
  }

  _genNormalSearch(){
    return Container(
      child: Row( 
        children: <Widget>[
        _wrapTap(
          Container(
            padding: EdgeInsets.fromLTRB(6,5,10,5),
            child: widget?.hideLeft ?? false?null:Icon(
              Icons.arrow_back_ios,
              color: Colors.grey,
              size: 26,
            ),
          ),
          widget.leftButtonClick
        ),
        Expanded(
          flex:1,
          child: _inputBox(),
        ),
        _wrapTap(
          Container(
            padding: EdgeInsets.fromLTRB(10,5,10,5),
            child: Text(
              '搜索',
              style:TextStyle(color: Colors.blue,fontSize:17)
            ),
          ),
          widget.rightButtonClick
        )
      ],),
    );
  }

  _inputBox(){
    Color inputBoxColor;
    if(widget.searchBarType == SearchBarType.home){
      inputBoxColor = Colors.white;
    }else {
      inputBoxColor = Color(int.parse('0xffededed'));
    }
    return Container(
      padding: EdgeInsets.fromLTRB(10,0,10,0),
      decoration: BoxDecoration(
        color: inputBoxColor,
        borderRadius: BorderRadius.circular(
          widget.searchBarType == SearchBarType.nomal?5:15
        )
      ),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.search,
            size: 20,
            color: widget.searchBarType == SearchBarType.nomal?Color(0xffA9A9A9A):Colors.blue
          ),
          Expanded(
            flex: 1,
            child: widget.searchBarType == SearchBarType.nomal?
                TextField(
                      controller: _controller, 
                      onChanged: _onchanged,
                      textAlignVertical:TextAlignVertical.top,
                      autofocus:false,
                      style:TextStyle(
                        fontSize: 18,
                        color:Colors.black,
                        fontWeight: FontWeight.w300
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(5,0,5,0),
                        border:InputBorder.none,
                        hintText:widget.hint,
                        hintStyle:TextStyle(fontSize: 15),
                      ),
                  ) : _wrapTap(
                  Container(
                    child: Text(
                      widget.defaultText,
                      style: TextStyle(fontSize: 13,color:Colors.grey),
                    ),
                  ),
                  widget.inputBoxClick
                ),
          ),
          !showClear?
          _wrapTap(
            Icon(
              Icons.mic,
              size: 22,
              color: widget.searchBarType == SearchBarType.nomal ? Colors.blue : Colors.grey,
            ), widget.speackClick)
          : _wrapTap(
            Icon(
              Icons.clear,
              size:22,
              color:Colors.grey
            ), (){
              setState(() {
                _controller.clear(); 
              });
              _onchanged('');
            })
        ],
      ),
    );
  }

  _wrapTap(Widget child, void Function() callback){
    return GestureDetector(
      onTap: (){
        if(callback != null) callback();
      },
      child:child,
    );
  }

  _onchanged(String text){
    if(text.length > 0){
      setState(() {
       showClear = true; 
      });
    }else {
      setState(() {
       showClear = false; 
      });
    }
    if(widget.onChanged != null){
      widget.onChanged(text);
    }
  }

  _genHomeSearch(){
    return Container(
      child: Row( 
        children: <Widget>[
        _wrapTap(
          Container(
            padding: EdgeInsets.fromLTRB(6,5,5,5),
            child: Row(children: <Widget>[
              Text(
                '深圳',
                style: TextStyle(
                  color: _homeFontColor(),
                  fontSize: 14
                ),
              ),
              Icon(
                Icons.expand_more,
                color: _homeFontColor(),
                size: 22,
              )
            ],),
          ),
          widget.leftButtonClick
        ),
        Expanded(
          flex:1,
          child: _inputBox(),
        ),
        _wrapTap(
          Container(
            padding: EdgeInsets.fromLTRB(10,5,10,5),
            child: Icon(
              Icons.comment,
              color: _homeFontColor(),
              size: 26,
            ),
          ),
          widget.rightButtonClick
        )
      ],),
    );
  }

  _homeFontColor(){
    return widget.searchBarType == SearchBarType.homeLight ? Colors.black54 : Colors.white;
  }
}