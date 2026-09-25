import 'package:b2b_seller/core/errors/exceptions.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

/// Abstraction of [Exception] class
///
/// [Failure] implementation will takes [message].
abstract class Failure extends Equatable {
  const Failure({
    required this.message,
    this.statusCode,
  });

  final String message;
  final int? statusCode;

  /// returns stringified [message].
  String get errorMessage => '$statusCode: $message';

  @override
  List<Object?> get props => [message, statusCode];
}

/// Implementation of [Failure] to handle cache-related failures
///
/// [CacheFailure] can be instantiated from an [CacheException] using
/// [CacheFailure.fromException]
class CacheFailure extends Failure {
  const CacheFailure({
    required this.prefix,
    required super.message,
  });

  factory CacheFailure.fromException(CacheException exception) {
    return CacheFailure(
      message: exception.message,
      prefix: 'Cache Failure',
    );
  }

  final String prefix;

  @override
  String get errorMessage => '$prefix: $message';

  @override
  List<Object?> get props => [message, prefix];
}

/// Implementation of [Failure] to handle server-related failures
///
/// [HttpFailure] can be instantiated from an [HttpException] using
/// [HttpFailure.fromException]
class HttpFailure extends Failure {
  const HttpFailure({
    required super.message,
    required this.statusCode,
  });

  factory HttpFailure.fromException(HttpException exception) {
    return HttpFailure(
      message: exception.message,
      statusCode: exception.statusCode,
    );
  }

  final int statusCode;

  @override
  String get errorMessage => '$statusCode: $message';
}

/// Implementation of [Failure] to handle client-related failures
///
/// [ClientFailure] can be instantiated from an [ClientException] using
/// [ClientFailure.fromException]
class ClientFailure extends Failure {
  const ClientFailure({
    required super.message,
    this.prefix = '',
  });

  factory ClientFailure.fromException(ClientException exception) {
    return ClientFailure(
      message: exception.message,
      prefix: exception.prefix,
    );
  }

  @override
  String get errorMessage => '$prefix: $message';

  final String prefix;
}

/// Implementation of [Failure] to handle custom failures.
///
/// [GeneralFailure] can be instantiated from an [ClientException] using
/// [GeneralFailure.fromException].
class GeneralFailure extends Failure {
  const GeneralFailure({
    required super.message,
    super.statusCode,
  });

  factory GeneralFailure.fromException(GeneralException exception) {
    return GeneralFailure(
      message: exception.message,
    );
  }

  factory GeneralFailure.fromDioException(DioException exception) {
    String message = exception.message ?? '';
    try {
      final responseData = exception.response?.data;
      final statusCode = exception.response?.statusCode;
      if (responseData is Map<String, dynamic>) {
        message =
            responseData['detail'] as String? ??
            responseData['message'] as String? ??
            responseData['error'] as String? ??
            'Could not get error message from DioException ';
      }

      // try to get message from error (not from server)
      if (message.isEmpty) {
        message = 'Something went wrong';
      }
      return GeneralFailure(
        message: message,
        statusCode: statusCode,
      );
    } catch (e) {
      return const GeneralFailure(
        message: 'Could not get error message from DioException ',
      );
    }
  }

  factory GeneralFailure.fromObject(Object exception) {
    if (exception is DioException) {
      return GeneralFailure.fromDioException(exception);
    }
    return GeneralFailure(
      message: exception.toString(),
    );
  }

  @override
  String get errorMessage => message;
}

/// Implementation of [Failure] to handle no internet connection failures
///
/// [NoInternetFailure] represents a failure due to lack of internet connection.
class NoInternetFailure extends Failure {
  const NoInternetFailure() : super(message: 'No internet connection');

  @override
  String get errorMessage => message;
}
