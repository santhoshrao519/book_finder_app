import 'package:book_finder_app/core/error/app_exception.dart';
import 'package:dio/dio.dart';

class NetworkExceptionHandler {
  static AppException handle(DioException e) {
    final statusCode = e.response?.statusCode ?? 0;
    final errorStr = e.error?.toString().toLowerCase() ?? '';

    // 🌐 No internet connection
    if (e.type == DioExceptionType.unknown &&
        (errorStr.contains('socket') ||
         errorStr.contains('network') ||
         errorStr.contains('host') ||
         errorStr.contains('failed') ||
         errorStr.contains('dns') ||
         errorStr.contains('unreachable') ||
         errorStr.contains('refused') ||
         errorStr.contains('connection'))) {
      return AppException(
        'No internet connection. Please check your network.',
        code: 0,
      );
    }

    // ⏱️ Timeout
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return AppException(
        'Connection timed out. Please try again.',
        code: statusCode,
      );
    }

    // 🔒 Unauthorized, 404, 500, etc.
    if (e.type == DioExceptionType.badResponse) {
      switch (statusCode) {
        case 400:
          return AppException('Bad request.', code: 400);
        case 401:
          return AppException('Unauthorized. Please login again.', code: 401);
        case 403:
          return AppException('Forbidden access.', code: 403);
        case 404:
          return AppException('Book not found.', code: 404);
        case 500:
          return AppException('Server error. Try again later.', code: 500);
        default:
          return AppException(
            'Unexpected error occurred.',
            code: statusCode,
          );
      }
    }

    // ❌ Canceled request
    if (e.type == DioExceptionType.cancel) {
      return AppException('Request was cancelled.', code: 499);
    }

    // 🧯 Final fallback
    return AppException(
      'Something went wrong. Please check again.',
      code: statusCode,
    );
  }
}
