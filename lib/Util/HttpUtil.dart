import 'dart:async';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:dio/dio.dart';

class HttpUtil{
  static HttpUtil httpUtil;
  String baseUrl = "https://openapi.youdao.com/api";
  String APP_KEY = "726fe69e371f0507";
  String APP_SECRET = "P6dWFYQzyMzcXC7kvmS9TquWeCrHKop3";
  Dio dio;
  BaseOptions options;

  static HttpUtil getInstance(){
    if(httpUtil == null){
      httpUtil = HttpUtil();
    }
    return httpUtil;
  }

  HttpUtil(){
    options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: 10000,
      receiveTimeout: 3000,
      headers: {},
    );
    dio = Dio();
  }

  Future<Response> get(String url,{options,callBack,data})async{
    Response response;
    response = await dio.get(url,);
    return response;
  }

  Future<Response> post(String url,{options,callBack,data})async{
    Response response;

    response = await dio.post(url,
      data: data,
      cancelToken: callBack,
      options: options
    );
    return response;
  }


  Future<Response> RequsetTranslate(String q,String from,String to,{options,callBack})async{
    Response response;
    FormData formData = FormData();
    String salt =(DateTime.now().millisecondsSinceEpoch).toString();
    formData.add('from', from);
    formData.add('to', to);
    //formData.add('signType', "v3");
//    String time = (DateTime.now().millisecondsSinceEpoch / 1000 ).toString();
//    formData.add('curtime', time);
    var bytes = utf8.encode(APP_KEY+q+salt+APP_SECRET);
    var sign = md5.convert(bytes);
    formData.add("appKey", APP_KEY);
    var qBytes = utf8.encode(q);
    q = utf8.decode(qBytes);
    formData.add("q", q);
    formData.add("salt", salt);
    formData.add("sign", sign);
    response = await dio.post(baseUrl,
        data: formData,
        cancelToken: callBack,
        options: options
    );
    return response;
  }


  String truncate(String q) {
    if (q == null) {
      return null;
    }
    int len = q.length;
    String result;
    return len <= 20 ? q : (q.substring(0, 10) + "$len" + q.substring(len - 10, len));
  }
}

