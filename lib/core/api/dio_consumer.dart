import 'package:dio/dio.dart';
import 'package:football/core/api/end_points.dart';

import 'api_consumer.dart';

class DioConsumer extends ApiConsumer {
  final Dio dio;

  DioConsumer({required this.dio}) {
    dio.options
      ..baseUrl = EndPoints.baseUrl
      ..responseType = ResponseType.json
      ..followRedirects = false
      ..headers = {
        'X-RapidAPI-Key': "1b72214af9mshcc21786fce0b75cp15f9a7jsne17daf1dd4dc",
        'X-RapidAPI-Host': "exercisedb.p.rapidapi.com",
      };
    dio.options.receiveDataWhenStatusError = true;
    dio.options.connectTimeout = const Duration(seconds: 20);
    dio.options.receiveTimeout = const Duration(seconds: 20);
  }

  void setRapidApiKey() {
    dio.options.headers["X-RapidAPI-Key"] =
        "1b72214af9mshcc21786fce0b75cp15f9a7jsne17daf1dd4dc";
    dio.options.headers["X-RapidAPI-Host"] = "exercisedb.p.rapidapi.com";
  }

  @override
  Future get(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    setRapidApiKey();
    try {
      final res = await dio.get(path, queryParameters: queryParameters);
      return res.data;
    } on DioException {
      rethrow;
    }
  }

  @override
  Future post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool isFormData = false,
  }) async {
    setRapidApiKey();
    try {
      final res = await dio.post(
        path,
        data: isFormData ? FormData.fromMap(data) : data,
        queryParameters: queryParameters,
      );
      return res.data;
    } on DioException {
      rethrow;
    }
  }

  @override
  Future patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool isFormData = false,
  }) async {
    setRapidApiKey();
    try {
      final res = await dio.patch(
        path,
        data: isFormData ? FormData.fromMap(data) : data,
        queryParameters: queryParameters,
      );
      return res.data;
    } on DioException {
      rethrow;
    }
  }

  @override
  Future delete(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    setRapidApiKey();
    try {
      final res = await dio.delete(path, queryParameters: queryParameters);
      return res.data;
    } on DioException {
      rethrow;
    }
  }
}
