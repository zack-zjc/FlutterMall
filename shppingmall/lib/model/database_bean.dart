
//基础bean，工具类操作依赖此bean
import 'dart:convert';

abstract class DatabaseBean {

  /// 实体转换成存储数据库map,由于数据库只存储基本类型，可能需要区别convertToServerJson做一些转换
  /// 如果实体类中只存在基本类型，实现与convertToServerJson一致
  Map<String, dynamic> convertToDatabaseJson() => convertToServerJson();

  /// 转换数据库查询结构为当前bean
  DatabaseBean convertFromDatabaseJson(Map<String, dynamic> map);

  /// 转换成提交到服务器使用的数据结构
  Map<String, dynamic> convertToServerJson();

  /// 关联表名称
  String getTableName();

  ///获取decode后的数据,如果是String则转下处理源数据是list转string存数据库的数据
  dynamic getDecodeValue(dynamic value){
    if (value is String){
      return jsonDecode(value);
    }
    return value;
  }

}
