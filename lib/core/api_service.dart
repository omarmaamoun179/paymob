import 'package:dio/dio.dart';

class DioHelper {
  static late Dio dio;
  static initDio() {
    dio = Dio(
      BaseOptions(
        contentType: 'application/json',
        baseUrl: 'https://accept.paymob.com/api/',
        receiveDataWhenStatusError: true,
      ),
    );
  }

  static Future<Response> postData(
      {required String endPoiont, required Map<String, dynamic> data}) async {
    return await dio.post(endPoiont, data: data);
  }

  static Future<Response> getData(
      {Map<String, dynamic>? data, required String endPoiont}) async {
    return await dio.get(endPoiont, queryParameters: data);
  }
}
