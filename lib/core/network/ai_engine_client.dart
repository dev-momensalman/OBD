import 'dart:developer' as dev;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:obd_vision/core/config/app_env.dart';
import 'package:obd_vision/core/errors/exceptions.dart';

/// HTTP client wrapper around [Dio] for communicating with the OBD AI Engine.
class AiEngineClient {
  final Dio _dio;

  AiEngineClient({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: AppEnv.aiEngineBaseUrl,
                connectTimeout: const Duration(seconds: 8),
                receiveTimeout: const Duration(seconds: 20),
                sendTimeout: const Duration(seconds: 10),
                headers: const {
                  'Content-Type': 'application/json',
                  'Accept': 'application/json',
                },
              ),
            ) {
    if (kDebugMode && dio == null) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: false,
          responseBody: false,
          logPrint: (obj) => dev.log(obj.toString(), name: 'AiEngineClient'),
        ),
      );
    }
  }

  Future<Map<String, dynamic>> postJson(
    String path, {
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await _dio.post<dynamic>(path, data: data);
      if (response.data is Map<String, dynamic>) {
        return response.data as Map<String, dynamic>;
      }
      throw const ServerException('Unexpected response format from AI Engine');
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw const NetworkTimeoutException('AI Engine request timed out');
      }
      throw ServerException(
        e.message ?? 'AI Engine communication failure',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
