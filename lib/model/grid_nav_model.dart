import 'package:flutter_app/model/common_model.dart';

/**
  hotel Object NonNull
  flight Object NonNull
  travel Object NonNull
 */
// 首页网格卡片模型
class GridNavModel{
  final GridNavItem hotel;
  final GridNavItem flight;
  final GridNavItem travel;
  // 创建构造方法
  GridNavModel({
      this.hotel,
      this.flight,
      this.travel 
    });

  factory GridNavModel.fromJson(Map<String,dynamic>json){
    return json != null?
    GridNavModel(
      hotel: GridNavItem.fromJson(json['hotel']),
      flight: GridNavItem.fromJson(json['flight']),
      travel: GridNavItem.fromJson(json['travel']),
    ):null;
  }

   Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hotel'] = this.hotel;
    data['flight'] = this.flight;
    data['travel'] = this.travel;
    return data;
  }
}


class GridNavItem{
  final String startColor;
  final String endColor;
  final CommonModel mainItem;
  final CommonModel item1;
  final CommonModel item2;
  final CommonModel item3;
  final CommonModel item4;
  GridNavItem({
    this.startColor,
    this.endColor,
    this.mainItem,
    this.item1,
    this.item2,
    this.item3,
    this.item4
  });

  factory GridNavItem.fromJson(Map<String, dynamic> json){
    return GridNavItem(
      startColor:json['startColor'],
      endColor:json['endColor'],
      mainItem:CommonModel.fromJson(json['mainItem']),
      item1: CommonModel.fromJson(json['item1']),
      item2: CommonModel.fromJson(json['item2']),
      item3: CommonModel.fromJson(json['item3']),
      item4: CommonModel.fromJson(json['item4']),
    );
  }   

   Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['startColor'] = this.startColor;
    data['endColor'] = this.endColor;
    if (this.mainItem != null) {
      data['mainItem'] = this.mainItem;
    }
    if (this.item1 != null) {
      data['item1'] = this.item1;
    }
    if (this.item2 != null) {
      data['item2'] = this.item2;
    }
    if (this.item3 != null) {
      data['item3'] = this.item3;
    }
    if (this.item4 != null) {
      data['item4'] = this.item4;
    }
    return data;
  }
}





















