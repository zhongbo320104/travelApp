import 'package:flutter_app/model/common_model.dart';
// bannerList
class CommonModel{
  final String icon;
  final String title;
  final String url;
  final String statusBarColor;
  final bool hideAppBar;
  // 创建构造方法
  CommonModel({this.icon,this.title,this.url, this.statusBarColor, this.hideAppBar,});

  factory CommonModel.fromJson(Map<String,dynamic>json){
    return CommonModel(
      icon:json['icon'],
      title:json['title'],
      url:json['url'],
      statusBarColor:json['statusBarColor'],
      hideAppBar:json['hideAppBar'],
    );
  }
  
  Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = new Map<String, dynamic>();
      data['title'] = this.title;
      data['icon'] = this.icon;
      data['url'] = this.url;
      data['statusBarColor'] = this.statusBarColor;
      data['hideAppBar'] = this.hideAppBar;
      return data;
  }  
}