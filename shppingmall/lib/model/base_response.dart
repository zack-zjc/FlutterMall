

//通用的返回数据结构
class BaseResponse {

  //成功
  static const int STATUS_OK = 0;
  //失败
  static const int STATUS_FAIL = 0;

  //状态码
  int status = STATUS_FAIL;

  //返回数据结构
  dynamic response;

  //是否返回成功
  bool isStatusOk() => status == STATUS_OK;

  ///format返回数据
  static formatResponse(dynamic data){
    var response = BaseResponse();
    response.status = data["status"];
    response.response = data["response"];
    return response;
  }

}