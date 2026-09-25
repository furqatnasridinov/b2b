import 'dart:async';
import 'package:b2b_seller/core/injection/injection.dart';
import 'package:b2b_seller/core/router/router.dart';
import 'package:b2b_seller/core/services/services.dart';
import 'package:b2b_seller/src/auth/domain/usecase/token_usecase.dart';
import 'package:b2b_seller/src/auth/presentation/view/login_screen.dart';
import 'package:dio/dio.dart';

class DioHttpClient {
  const DioHttpClient._();

  static Dio? _dioInstance;
  static Dio get instance {
    _dioInstance ??= _buildDio();
    return _dioInstance!;
  }

  static Dio _buildDio() {
    final dio = Dio(_options);
    dio.interceptors.add(RequestInterceptor());
    //dio.interceptors.add(sl<IDebugService>().dioLogger as Interceptor);
    return dio;
  }

  static void refreshInstance() {
    final url = resolvedBaseUrl;
    if (_dioInstance != null) {
      _dioInstance!.options.baseUrl = url;
      return;
    }
    _dioInstance = _buildDio();
  }

  // for changing base url in developer settings screen
  static String get resolvedBaseUrl {
    final storedBaseUrl = LocalDataStorage.getString(
      LocalDataStorageKeys.baseUrl,
    ).trim();
    if (storedBaseUrl.isEmpty) {
      return '';
    }
    return '$storedBaseUrl/api/v1';
  }

  static BaseOptions get _options => BaseOptions(
    baseUrl: resolvedBaseUrl,
    connectTimeout: const Duration(minutes: 1),
    sendTimeout: const Duration(minutes: 10),
    receiveTimeout: const Duration(minutes: 3),
    headers: {
      Headers.contentTypeHeader: Headers.jsonContentType,
      Headers.acceptHeader: 'application/json, text/plain, */*',
      //'User-Agent': LocalDataStorage.getString(LocalDataStorageKeys.userAgent),
    },
  );
}

class RequestInterceptor extends Interceptor {
  static const _retriedExtraKey = '_retried';
  static const skipDirectingLoginExtraKey = 'skipDirectingLogin';
  static const skipTokenRefreshExtraKey = 'skipTokenRefresh';

  static Future<bool>? _refreshTokenFuture;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // User-Agent
    //final userAgent = await UserAgentProvider.getUserAgent();
    //options.headers['User-Agent'] = userAgent;

    // Accept-Language
    //final locale = LocalDataStorage.getLocale();
    //options.headers['Accept-Language'] = locale;

    // Гео (по желанию — не логируйте в прод)
    /* final latitude = LocalDataStorage.getLatitude();
    final longitude = LocalDataStorage.getLongitude();
    if (latitude.isNotEmpty && longitude.isNotEmpty) {
      options.headers['x-geo-lat'] = latitude;
      options.headers['x-geo-lng'] = longitude;
    } */
    final accessTokenResult = await sl<GetAccessTokenUseCase>()();
    accessTokenResult.fold(
      (_) {},
      (token) {
        if (token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
      },
    );
    return handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final statusCode = err.response?.statusCode;
    if (statusCode != 401) {
      return handler.next(err);
    }

    final requestOptions = err.requestOptions;
    final skipDirectingLogin = requestOptions.extra.containsKey(
      skipDirectingLoginExtraKey,
    );
    final skipTokenRefresh = requestOptions.extra.containsKey(
      skipTokenRefreshExtraKey,
    );
    final isRetried = requestOptions.extra[_retriedExtraKey] == true;
    final isAuthPath = _isAuthPath(requestOptions.path);

    if (skipTokenRefresh || isRetried || isAuthPath) {
      await _clearTokensAndRedirect(
        err: err,
        handler: handler,
        skipDirectingLogin: skipDirectingLogin,
      );
      return;
    }

    try {
      final refreshed = await _refreshTokenIfNeeded();
      if (!refreshed) {
        await _clearTokensAndRedirect(
          err: err,
          handler: handler,
          skipDirectingLogin: skipDirectingLogin,
        );
        return;
      }

      // Get new access token from local storage after waiting previous request
      final accessTokenResult = await sl<GetAccessTokenUseCase>()();
      var accessToken = '';
      accessTokenResult.fold(
        (_) {},
        (token) => accessToken = token,
      );

      requestOptions.headers['Authorization'] = 'Bearer $accessToken';
      requestOptions.extra[_retriedExtraKey] = true;

      final response = await DioHttpClient.instance.fetch<dynamic>(
        requestOptions,
      );
      return handler.resolve(response);
    } on DioException catch (retryError) {
      await _clearTokensAndRedirect(
        err: retryError,
        handler: handler,
        skipDirectingLogin: skipDirectingLogin,
      );
    } catch (_) {
      await _clearTokensAndRedirect(
        err: err,
        handler: handler,
        skipDirectingLogin: skipDirectingLogin,
      );
    }
  }

  bool _isAuthPath(String path) {
    return path.contains('/auth/login') ||
        path.contains('/auth/register') ||
        path.contains('/auth/refresh');
  }

  Future<bool> _refreshTokenIfNeeded() async {
    if (_refreshTokenFuture != null) {
      return _refreshTokenFuture!;
    }

    _refreshTokenFuture = _performRefresh();
    try {
      return await _refreshTokenFuture!;
    } finally {
      _refreshTokenFuture = null;
    }
  }

  Future<bool> _performRefresh() async {
    // Get refresh token from local storage
    final refreshTokenResult = await sl<GetRefreshTokenUseCase>()();
    var refreshToken = '';
    refreshTokenResult.fold(
      (_) {},
      (token) => refreshToken = token,
    );

    if (refreshToken.isEmpty) {
      return false;
    }

    // Refresh token request using refresh token
    final result = await sl<RefreshTokenUseCase>()(refreshToken);
    return result.fold(
      (_) => false,
      (data) async {
        final accessToken = data['access_token'] as String? ?? '';
        final newRefreshToken = data['refresh_token'] as String? ?? '';

        if (accessToken.isEmpty) {
          return false;
        }

        // Save new access token and refresh token to local storage
        await sl<SaveAccessTokenUseCase>()(accessToken);
        if (newRefreshToken.isNotEmpty) {
          await sl<SaveRefreshTokenUseCase>()(newRefreshToken);
        }
        return true;
      },
    );
  }

  Future<void> _clearTokensAndRedirect({
    required DioException err,
    required ErrorInterceptorHandler handler,
    required bool skipDirectingLogin,
  }) async {
    final deleteAccessTokenResult = await sl<DeleteAccessTokenUseCase>()();
    deleteAccessTokenResult.fold((_) {}, (_) {});
    final deleteRefreshTokenResult = await sl<DeleteRefreshTokenUseCase>()();
    deleteRefreshTokenResult.fold((_) {}, (_) {});

    if (!skipDirectingLogin) {
      AppRouter.routerConfig.go(LoginScreen.path);
    }
    handler.next(err);
  }
}
