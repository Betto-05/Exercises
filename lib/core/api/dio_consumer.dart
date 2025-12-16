import 'package:dio/dio.dart';

import 'api_consumer.dart';

class DioConsumer extends ApiConsumer {
  final Dio dio;

  DioConsumer({required this.dio});

  //!POST
  @override
  Future post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool isFormData = false,
  }) async {
    setRapidApiKey();
    final res = await dio.post(
      path,
      data: isFormData ? FormData.fromMap(data) : data,
      queryParameters: queryParameters,
    );
    return res.data;
  }

  //!GET
  @override
  Future get(
    String path, {
    Object? data, // MUST include this to match ApiConsumer
    Map<String, dynamic>? queryParameters,
  }) async {
    setRapidApiKey();
    final res = await dio.get(path, queryParameters: queryParameters);
    return res.data;
  }

  @override
  Future delete(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) {
    throw UnimplementedError();
  }

  @override
  Future patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool isFormData = false,
  }) {
    throw UnimplementedError();
  }

  void setRapidApiKey() {
    dio.options.headers["X-RapidAPI-Key"] = "YOUR_RAPIDAPI_KEY";
    dio.options.headers["X-RapidAPI-Host"] = "exercisedb.p.rapidapi.com";
  }
}
