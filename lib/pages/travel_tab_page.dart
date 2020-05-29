import "package:flutter/material.dart";
import 'package:flutter_app/dao/travel_dao.dart';
import 'package:flutter_app/model/travel_model.dart';
import 'package:flutter_app/widget/loading_container.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

// 旅拍瀑布流页面  pageview 部分
const PAGE_SIZI=10;  // 每页显示10条数据
class TravelTabPage extends StatefulWidget {
  final String travelUrl;
  final Map params;
  final String groupChannelCode;
  final int type;
  TravelTabPage({Key key,this.travelUrl,this.groupChannelCode,this.params,this.type}) : super(key: key);

  _TravelTabPageState createState() => _TravelTabPageState();
}

class _TravelTabPageState extends State<TravelTabPage> with AutomaticKeepAliveClientMixin{
  List<TravelItem> travelItems;
  int pageIndex = 1;

  bool _loading = true;

  @override
  void initState() {
    _loadData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      removeTop: true,
      context: context,
      child: Container(
      child: Scaffold(
          body:LoadingContainer(
            isLoading: _loading,
            child: RefreshIndicator(
              onRefresh: _handleRefresh,
              child: StaggeredGridView.countBuilder(
                crossAxisCount: 4,
                itemCount: travelItems?.length??0,
                itemBuilder: (BuildContext context,int index)=> _travelItem(index: index,item:travelItems[index]),
                staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
              ),
            )
          )
        ),
      ),
    ); 
  }
  void _loadData(){
    TravelDao.fetch(params, widget.groupChannelCode, widget.type, pageIndex, PAGE_SIZI).then((model){
      setState(() {
        _loading = false;
       List<TravelItem>  items = _filterItems(model.resultList);
       if(travelItems != null){
         travelItems.addAll(items);
       }else {
         travelItems = items;
       }
      });
    });
  }

  List<TravelItem> _filterItems(List<TravelItem> resultList){
    if(resultList == null){
      return [];
    }
    List<TravelItem> filterItems = [];
    resultList.forEach((item){
      if(item.article != null){
        filterItems.add(item);  // 移除article为空的模型
      }
    });
    return filterItems;
  }

  @override
  bool get wantKeepAlive => true;

  Future<Null> _handleRefresh() async{
    _loadData();
    return null;
  }
}

class _travelItem extends StatelessWidget {
  final TravelItem item;
  final int index;
  const _travelItem({Key key,this.index,this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if(item.article?.urls != null && item.article.urls.length != 0){
          // Navigator.push(context, route)
        }
      },
      child: Card(
        child: PhysicalModel(
          color: Colors.transparent,
          clipBehavior: Clip.antiAlias,  // 裁切 去锯齿
          borderRadius: BorderRadius.circular(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _itemImage(),
              Container(
                padding: EdgeInsets.all(4),
                child: Text(
                  item.article.articleTitle,
                  maxLines:2,
                  overflow:TextOverflow.ellipsis,
                  style:TextStyle(fontSize:14,color:Colors.blue)
                ),
              ),
              _infoText(),
            ],
          ),
        ),
      ),
    );
  }

  _itemImage(){
    return Stack(
      children: <Widget>[
        Image.network(item.article.images[0]?.dynamicUrl),
        Positioned(
          bottom: 8,
          left: 8,
          child: Container(
            padding: EdgeInsets.fromLTRB(5,1,5,1),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(10)
            ),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 3),
                  child: Icon(Icons.location_on,color: Colors.white,size: 12,),
                ),
                LimitedBox(
                  maxWidth: 130,
                  child: Text(
                    _posName(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  _infoText(){
      return Container(
        padding: EdgeInsets.fromLTRB(6,0,6,10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                PhysicalModel(   // 裁切组件
                  color: Colors.transparent,
                  clipBehavior: Clip.antiAlias,
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    item.article.author?.coverImage?.dynamicUrl,
                    width: 24,
                    height: 24, 
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  width: 90,
                  child: Text(
                    item.article.author?.nickName,
                    maxLines:1,
                    overflow:TextOverflow.ellipsis,
                    style:TextStyle(fontSize:12)
                  ),
                )
              ],
            ),
            Row(children: <Widget>[
              Icon(Icons.thumb_up,size: 14,color: Colors.grey),
              Padding( 
                padding: EdgeInsets.only(left: 3),
                child: _getLikeCount(item.article.likeCount),
              ),
              
            ],)
          ],
        ),
      );
  }

  Text _getLikeCount(likeCount){
    if(likeCount == null) return Text("0",style:TextStyle(fontSize: 10),);
    if(item.article.likeCount > 9999){
      return Text(item.article.likeCount.toString().substring(0,1)+'w',style:TextStyle(fontSize: 10),);
    }
    return Text(item.article.likeCount.toString(),style:TextStyle(fontSize: 10),);
  }
  String _posName(){
    return item.article.pois == null  || item.article.pois.length == 0?"未知":
    item.article.pois[0]?.poiName ?? '未知';
  }
}