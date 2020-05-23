import 'dart:async';
import 'dart:convert';
import 'package:flutter_app/model/search_model.dart';
import 'package:http/http.dart' as http;
class SearchDao{
  static Future<SearchModel> fetch(String url, String text) async {
    final response = await http.get(url);
    if(response.statusCode == 200) {
      // 响应数据中有中文会乱码 加入以下代码
      Utf8Decoder utf8decoder=Utf8Decoder();  // 修复中文乱码 配合import 'dart:convert';
      var result = json.decode(utf8decoder.convert(response.bodyBytes));

      // 优化点 只有用户输入的text 与 服务端 返回的text一致才能进行渲染
      SearchModel model = SearchModel.fromJson(result);
      model.keyword = text;
      return model;
    }else {
      throw Exception('请求接口失败');
    }
  }
}