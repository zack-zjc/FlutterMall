import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:mall/model/base_response.dart';
import 'package:mall/utils/cookie.dart';
import 'package:mall/utils/log.dart';

//cookie管理器
var _cookieHelper = CookieHelper();

//网络请求管理
var _networkHelper = NetworkHelper();

class NetWorkUtil {
  ///获取helper实例
  static NetworkHelper getNetHelper() => _networkHelper;

  ///取消所有网络请求
  static void cancelAllRequest([dynamic reason]) {
    _networkHelper.cancelAllRequest(reason);
  }

  ///清楚会话信息
  static Future<void> clearSession() {
    return _cookieHelper.clearCookie();
  }

  ///网络get请求
  static Future<BaseResponse> get(String url, {Map<String, dynamic> queryParams}) async {
    var response = await _networkHelper.request(url, RequestOptions(method: "GET", queryParameters: queryParams));
    if (response.statusCode == 200) {
      return BaseResponse.formatResponse(response.data);
    }
    return BaseResponse();
  }

  ///post请求
  static Future<BaseResponse> post(String url, {dynamic data, Map<String, dynamic> queryParams}) async {
    var response = await _networkHelper.request(url, RequestOptions(method: "POST", data: data, queryParameters: queryParams));
    if (response.statusCode == 200) {
      return BaseResponse.formatResponse(response.data);
    }
    return BaseResponse();
  }

  ///put请求
  static Future<BaseResponse> put(String url, {dynamic data, Map<String, dynamic> queryParams}) async {
    var response = await _networkHelper.request(url, RequestOptions(method: "PUT", data: data, queryParameters: queryParams));
    if (response.statusCode == 200) {
      return BaseResponse.formatResponse(response.data);
    }
    return BaseResponse();
  }

  ///delete请求
  static Future<BaseResponse> delete(String url, {dynamic data, Map<String, dynamic> queryParams}) async {
    var response = await _networkHelper.request(url, RequestOptions(method: "DELETE", data: data, queryParameters: queryParams));
    if (response.statusCode == 200) {
      return BaseResponse.formatResponse(response.data);
    }
    return BaseResponse();
  }

  ///提交表单，课用于上传文件
  static Future<BaseResponse> postFormData(String url, Map<String, dynamic> formData,
      {Map<String, dynamic> queryParams, ProgressCallback onSendProgress}) async {
    var response = await _networkHelper.request(
        url,
        RequestOptions(
            method: "POST", data: formData, queryParameters: queryParams, onSendProgress: onSendProgress, contentType: Headers.formUrlEncodedContentType));
    if (response.statusCode == 200) {
      return BaseResponse.formatResponse(response.data);
    }
    return BaseResponse();
  }

  ///下载文件
  static Future<bool> downloadFile<T>(String url, dynamic savePath, {ProgressCallback onProgress}) async {
    var response = await _networkHelper.download(url, savePath, onProgress: onProgress);
    return response.statusCode == 200;
  }
}

class NetworkHelper {
  //dio实例
  final Dio _dio = new Dio();
  //通用的取消token
  final CancelToken _cancelToken = CancelToken();
  //默认处理器
  var _defaultTransformer = DefaultTransformer();
  //使用cookie
  var _enableCookie = false;
  //代理地址例如"PROXY 30.10.26.193:8888"方便抓包，如为空则不抓包
  var _proxyHost = "";

  ///设置初始化option
  void setBaseOption(
      {String baseUrl = "",
      String contentType = Headers.jsonContentType,
      Map<String, dynamic> headers,
      ResponseType responseType = ResponseType.json,
      bool followRedirects = true}) {
    _dio.options = BaseOptions(
        baseUrl: baseUrl, contentType: contentType, headers: headers, responseType: responseType, connectTimeout: 15000, followRedirects: followRedirects);
  }

  ///修改请求内容处理器
  void setDefaultTransformer(Transformer transformer) {
    _defaultTransformer = transformer ?? DefaultTransformer();
  }

  ///是否启用cookie
  void setCookieEnable(bool enable) {
    _enableCookie = enable ?? false;
  }

  ///启用代理
  void setProxy(String proxy) {
    _proxyHost = proxy;
  }

  ///下载文件请求
  Future<Response> download(String url, dynamic savePath,
      {ProgressCallback onProgress, Options options, Map<String, dynamic> parameters, data, CancelToken cancelToken}) async {
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        return Response(statusCode: NetWorkConstants.HTTP_ERROR_DISCONNECT);
      }
      if (_enableCookie) {
        //添加cookieJar
        var cookieJar = await _cookieHelper.getCookieJar();
        _dio.interceptors.add(CookieManager(cookieJar));
      }
      //开始网络请求
      return _dio.download(url, savePath,
          onReceiveProgress: onProgress, queryParameters: parameters, options: options, data: data, cancelToken: cancelToken ?? _cancelToken);
    } catch (exception) {
      return Response(statusCode: NetWorkConstants.HTTP_ERROR_DEFAULT);
    }
  }

  ///通用网络请求封装
  Future<Response> request(String url, Options options,
      {data,
      Map<String, dynamic> queryParameters,
      CancelToken cancelToken,
      ProgressCallback onSendProgress,
      ProgressCallback onReceiveProgress,
      Transformer transformer}) async {
    cancelToken ??= _cancelToken;
    onSendProgress ??= _onSendProgress;
    onReceiveProgress ??= _onReceiveProgress;
    transformer ??= _defaultTransformer;
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        return Response(statusCode: NetWorkConstants.HTTP_ERROR_DISCONNECT);
      }
      //修改请求数据处理器
      _dio.transformer = transformer;
      //添加本地代理，抓包
      if (_proxyHost != null && _proxyHost.isNotEmpty) {
        (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
          client.findProxy = (uri) {
            return _proxyHost;
          };
        };
      }
      if (_enableCookie) {
        //添加cookieJar
        var cookieJar = await _cookieHelper.getCookieJar();
        _dio.interceptors.add(CookieManager(cookieJar));
      }
      //开始网络请求
      if (data != null) {
        return _dio.request(url,
            data: data,
            queryParameters: queryParameters,
            cancelToken: cancelToken,
            options: options,
            onSendProgress: onSendProgress,
            onReceiveProgress: onReceiveProgress);
      }
      return _dio.request(url,
          queryParameters: queryParameters, cancelToken: cancelToken, options: options, onSendProgress: onSendProgress, onReceiveProgress: onReceiveProgress);
    } on DioError catch (exception) {
      LogUtil.debug("request-error:type:${exception.type},message:${exception.message},error:${exception.error}");
      if (exception.type == DioErrorType.CONNECT_TIMEOUT || exception.type == DioErrorType.RECEIVE_TIMEOUT || exception.type == DioErrorType.SEND_TIMEOUT) {
        return Response(statusCode: NetWorkConstants.HTTP_ERROR_TIMEOUT);
      } else if (exception.type == DioErrorType.CANCEL) {
        return Response(statusCode: NetWorkConstants.HTTP_ERROR_CANCELED);
      } else if (exception.type == DioErrorType.RESPONSE) {
        return exception.response ?? Response(statusCode: NetWorkConstants.HTTP_ERROR_RESPONSE);
      }
      return Response(statusCode: NetWorkConstants.HTTP_ERROR_DEFAULT);
    } catch (exception) {
      LogUtil.debug("request-error:type:${exception.type},message:${exception.message},error:${exception.error}");
      return Response(statusCode: NetWorkConstants.HTTP_ERROR_DEFAULT);
    }
  }

  ///取消所有的请求
  void cancelAllRequest([dynamic reason]) {
    _dio.clear();
    _cancelToken.cancel(reason);
  }

  ///发送progress
  void _onSendProgress(int count, int total) {
    LogUtil.debug("sendProgress:count=$count,total=$total");
  }

  ///下载progress
  void _onReceiveProgress(int count, int total) {
    LogUtil.debug("receiveProgress:count=$count,total=$total");
  }
}

class NetWorkConstants {
  //网络未连接
  static const int HTTP_ERROR_DISCONNECT = -1;

  //网络通用错误
  static const int HTTP_ERROR_DEFAULT = -10;

  //网络连接超时
  static const int HTTP_ERROR_TIMEOUT = -11;

  //网络请求被取消
  static const int HTTP_ERROR_CANCELED = -12;

  //网络请求404等
  static const int HTTP_ERROR_RESPONSE = -13;
}
