class ConfigModel{
  final String searchUrl;
  // 创建构造方法
  ConfigModel({this.searchUrl});

  factory ConfigModel.fromJson(Map<String,dynamic>json){
    return ConfigModel(
      searchUrl:json['searchUrl']
    )
  }
}