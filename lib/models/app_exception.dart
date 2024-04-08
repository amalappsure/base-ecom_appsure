import 'package:dio/dio.dart';

class AppException implements Exception {
  final dynamic error;

  AppException([this.error]);

  @override
  String toString() {
    if (error == null) return "Exception";
    if (error is String) {
      return error as String;
    }
    if (error is Exception) {
      try {
        if (error is DioException) {
          final error = this.error as DioException;
          switch (error.type) {
            case DioExceptionType.cancel:
              return "Request to API server was cancelled";
            case DioExceptionType.connectionTimeout:
              return "Connection timeout with API server";

            case DioExceptionType.unknown:
              return "No internet";

            case DioExceptionType.receiveTimeout:
              return "Receive timeout in connection with API server";

            case DioExceptionType.badResponse:
              switch (error.response?.statusCode) {
                case 404:
                case 500:
                case 503:
                case 504:
                  return error.response?.statusMessage ??
                      "Something went wrong";
                default:
                  if (error.response?.data['message'] != null) {
                    return (error.response?.data['message']).toString();
                  } else {
                    return "Failed to load data - status code: ${error.response?.statusCode}";
                  }
              }
            case DioExceptionType.sendTimeout:
              return "Send timeout with server";
            case DioExceptionType.badCertificate:
              return "Something went wrong";
            case DioExceptionType.connectionError:
              return "Something went wrong";
          }
        } else {
          return "Unexpected error occurred";
        }
      } on FormatException catch (e) {
        return e.toString();
      }
    } else {
      return error.toString();
    }
  }
}
