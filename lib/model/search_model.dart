// 搜索模型
class SearchModel {
  List<SearchItem> data;
  String keyword;

  SearchModel({this.data,this.keyword=""});

  SearchModel.fromJson(Map<String, dynamic> json) {
    // var dataJson = json['data'] as List;
    // List<SearchItem> data = dataJson.map((v){
    //   return SearchItem.fromJson(v);
    // }).toList();
    if (json['data'] != null) {
      data = new List<SearchItem>();
      json['data'].forEach((v) {
        data.add(new SearchItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SearchItem {
  String code;
  String word;
  String type;
  String price;
  String zonename;
  String star;
  String districtname;
  String url;

  SearchItem(
      {this.code,
      this.word,
      this.type,
      this.price,
      this.zonename,
      this.star,
      this.districtname,
      this.url});

  SearchItem.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    word = json['word'];
    type = json['type'];
    price = json['price'];
    zonename = json['zonename'];
    star = json['star'];
    districtname = json['districtname'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['word'] = this.word;
    data['type'] = this.type;
    data['price'] = this.price;
    data['zonename'] = this.zonename;
    data['star'] = this.star;
    data['districtname'] = this.districtname;
    data['url'] = this.url;
    return data;
  }
}