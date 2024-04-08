import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:base_ecom_appsure/features/auth/models/tokens.dart';
import 'package:base_ecom_appsure/features/auth/providers/login_state_provider.dart';
import 'hive_repo.dart';

class AppInterceptor extends Interceptor {
  const AppInterceptor(this.ref);
  final Ref ref;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['AccessToken'] = HiveRepo.instance.getAccessToken() ?? '';
    options.headers['UserName'] = HiveRepo.instance.userName;
    options.headers['IsMobile'] = '1';
    options.headers['Access-Control-Allow-Origin'] = true;
    options.headers['Content-Type'] = 'application/json';


    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final status = response.data['status'] as bool?;
    if (status != null && status == false) {
      print('##onResponse: ${response.data}');
      handler.reject(DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: response.data['message'] as String? ?? 'ErrorPageMessage',
        type: DioExceptionType.badResponse,
      ));
    } else {
      handler.next(response);
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      getTokens(err, handler);
    } else {
      handler.next(err);
    }
  }

  Future<Response<dynamic>> retryRequest(RequestOptions options) async {
    options.headers['AccessToken'] = HiveRepo.instance.getAccessToken() ?? '';
    options.headers['UserName'] = HiveRepo.instance.userName;
    options.headers['IsMobile'] = "1";
    options.headers['Access-Control-Allow-Origin'] = true;
    options.headers['Content-Type'] = 'application/json';

    final dio = Dio(
      BaseOptions(
        baseUrl: options.baseUrl,
        connectTimeout: options.connectTimeout,
        receiveTimeout: options.receiveTimeout,
        headers: options.headers,
      ),
    );

    return dio.request(
      options.path,
      data: options.data,
      options: Options(method: options.method),
    );
  }

  Future<void> getTokens(
      DioException err,
      ErrorInterceptorHandler handler,
      ) async {
    AuthTokensResp? tokensResp;
    final isLoggedIn = ref.read(loginStateProvider) is LoggedIn;
    logOut() {
      handler.next(err);
      ref.read(loginStateProvider.notifier).state = const LoggedOut();
    }

    final dio = Dio(
      BaseOptions(
        baseUrl: err.requestOptions.baseUrl,
        connectTimeout: err.requestOptions.connectTimeout,
        receiveTimeout: err.requestOptions.receiveTimeout,
        headers: {'Content-Type': 'application/json',},
      ),
    );

    try {
      if (HiveRepo.instance.getRefreshToken() == null && !isLoggedIn) {
        tokensResp = await getToken(dio);
      } else if (HiveRepo.instance.getRefreshToken() != null) {
        try {
          tokensResp = await refreshToken(dio);
        } catch (e) {
          tokensResp = await getToken(dio);
        }
      } else {
        logOut();
        return;
      }
    } catch (e) {
      logOut();
      return;
    }
    HiveRepo.instance.setTokens(
      accessToken: tokensResp.result?.accessToken,
      refreshToken: tokensResp.result?.refreshToken,
    );

    try {
      handler.resolve(await retryRequest(err.requestOptions));
    } catch (e) {
      logOut();
    }
  }

  Future<AuthTokensResp> getToken(Dio dio) async {
    final response = await dio.request(
      '/GetTokens',
      data: {
        "key": "TfzGsUibDwQSPbE3Gs5NUQ==",
        "Username": HiveRepo.instance.userName,
      },
      options: Options(method: 'POST'),
    );
    return AuthTokensResp.fromJson(response.data);
  }

  Future<AuthTokensResp> refreshToken(Dio dio) async {
    final isLoggedIn = ref.read(loginStateProvider) is LoggedIn;
    final response = await dio.request(
      '/GetNewTokens',
      data: {
        "RefreshToken": HiveRepo.instance.getRefreshToken(),
        "Username": HiveRepo.instance.userName,
        "Role": isLoggedIn ? 'user' : 'default',
      },
      options: Options(method: 'POST'),
    );
    return AuthTokensResp.fromJson(response.data);
  }
}
