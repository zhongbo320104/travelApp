import 'dart:async';
import 'dart:convert';
import 'package:flutter_app/model/home_model.dart';
import 'package:http/http.dart' as http;
const HOME_URL = 'http://www.devio.org/io/flutter_app/json/home_page.json';
class HomeDao{
  static Future<HomeModel> fetch() async {
    final response = await http.get(HOME_URL);
    if(response.statusCode == 200) {
      // 响应数据中有中文会乱码 加入以下代码
      Utf8Decoder utf8decoder=Utf8Decoder();  // 修复中文乱码 配合import 'dart:convert';
      var result = json.decode(utf8decoder.convert(response.bodyBytes));
      return HomeModel.fromJson(result);
    }else {
      throw Exception('请求接口失败');
    }
  }
}