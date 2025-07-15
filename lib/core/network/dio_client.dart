import 'package:book_finder_app/core/constants/app_constants.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor/src/store/mem_cache_store.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  factory DioClient() => _instance;
  DioClient._internal();
  late Dio dio;

  void init() {
    final cacheOptions = CacheOptions(
      store: MemCacheStore(),
      policy: CachePolicy.request,
      hitCacheOnErrorExcept: [401, 403],
      priority: CachePriority.normal,
      maxStale: const Duration(days: 3),
    );

    dio = Dio(BaseOptions(
  baseUrl: AppConstants.baseUrl,
  connectTimeout: const Duration(milliseconds: AppConstants.connectTimeout),
  receiveTimeout: const Duration(milliseconds: AppConstants.receiveTimeout),
))
      ..interceptors.add(LogInterceptor(responseBody: true))
      ..interceptors.add(DioCacheInterceptor(options: cacheOptions));
  }
}