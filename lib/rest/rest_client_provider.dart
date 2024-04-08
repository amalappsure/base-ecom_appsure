import 'package:base_ecom_appsure/rest/rest_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:base_ecom_appsure/app_config/config.dart';
import 'package:base_ecom_appsure/foundation/app_interceptor.dart';
import 'package:base_ecom_appsure/foundation/logging_interceptor.dart';

export 'rest_client.dart';

final appInterceptorProvider = StateProvider<AppInterceptor>(
      (ref) => AppInterceptor(ref),
);

final restClientProvider = StateProvider(
      (ref) {
    final config = GetIt.I.get<Config>();
    return RestClient(
      Dio(
        BaseOptions(
          baseUrl: config.baseUrl,
          connectTimeout: const Duration(seconds: 120),
          receiveTimeout: const Duration(seconds: 120),
        ),
      )
        ..interceptors.add(ref.read(appInterceptorProvider))
        ..interceptors.add(const LoggingInterceptor(
          log: true,
          logResponseBody: true,
          logRequestHeader: true,
          logResponseHeader: false,
        )),
      baseUrl: config.baseUrl,
    );
  },
);
