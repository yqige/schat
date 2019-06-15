import 'dart:async';

import 'package:dio/dio.dart';

/*
 * 封装 restful 请求
 *
 * GET、POST、DELETE、PATCH
 * 主要作用为统一处理相关事务：
 *  - 统一处理请求前缀；
 *  - 统一打印请求信息；
 *  - 统一打印响应信息；
 *  - 统一打印报错信息；
 */
class HttpUtils {

  /// default options
//  static const String API_PREFIX = 'http://sc.abhwllm.com/order';
//  static const String API_PREFIX = 'http://d.dev.abh58.net';
//  static const String API_PREFIX = 'http://192.168.199.13:8082/order';
  static const String API_PREFIX = 'http://192.168.1.17:8081/wx-brand';
  static const int CONNECT_TIMEOUT = 10000;
  static const int RECEIVE_TIMEOUT = 30000;

  /// http request methods
  static const String GET = 'get';
  static const String POST = 'post';
  static const String PUT = 'put';
  static const String PATCH = 'patch';
  static const String DELETE = 'delete';
  static HttpUtils instance;
  static Dio _dio;
  static HttpUtils getInstance(){
    print("getInstance");
    if(instance == null){
      instance  = new HttpUtils();
    }
    return instance;
  }
  HttpUtils(){
    _dio = createInstance();
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest:(Options options){
        return options;
      },
      onResponse: (Response options){
        return options;
      },
      onError: (DioError e) {
        print(e);
        return e;
      }
    ));
  }
  /// request method
  Future request (String url,{ Map<String, dynamic> data, method }) async {

    data = data ?? {};
    method = method ?? 'GET';

    /// restful 请求处理
    /// /gysw/search/hist/:user_id        user_id=27
    /// 最终生成 url 为     /gysw/search/hist/27
    data.forEach((key, value) {
      if (url.indexOf(key) != -1) {
        url = url.replaceAll(':$key', value.toString());
      }
    });

    /// 打印请求相关信息：请求地址、请求方式、请求参数
    print('请求地址：【' + method + '  ' + url + '】');
    print('请求参数：' + data.toString());

    var result;

    try {
      Response response = await _dio.get(url, queryParameters: data, options: new Options(method: method));

      result = response.data;
      /// 打印响应相关信息
      print('响应数据：' + response.data.toString());
    } on DioError catch (e) {
      /// 打印请求失败相关信息
      print('请求出错：' + e.toString());
    }

    return result;
  }

  /// 创建 dio 实例对象
  static Dio createInstance () {
    if (_dio == null) {
      /// 全局属性：请求前缀、连接超时时间、响应超时时间
      BaseOptions options = new BaseOptions(
        baseUrl: API_PREFIX,
        connectTimeout: CONNECT_TIMEOUT,
        receiveTimeout: RECEIVE_TIMEOUT,
      );

      _dio = new Dio(options);
    }

    return _dio;
  }

  /// 清空 dio 对象
  static clear () {
    _dio = null;
  }

}
