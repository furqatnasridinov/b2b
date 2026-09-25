import 'package:b2b_seller/core/errors/failures.dart';
import 'package:b2b_seller/core/services/enums.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class HealthCheckCubit extends Cubit<HealthCheckState> {
  HealthCheckCubit() : super(const HealthCheckState());

  static const String _errorText = 'Сервер недоступен';

  Future<void> healthCheck(String baseUrl) async {
    if (state.isLoading) {
      return;
    }

    emit(const HealthCheckState(status: ProgressStatus.inProgress));

    try {
      final normalized = baseUrl.trim().replaceAll(RegExp(r'/+$'), '');
      final dio = Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(minutes: 3),
          headers: {
            Headers.acceptHeader: 'application/json',
          },
        ),
      );

      final response = await dio.get<Map<String, dynamic>>(
        '$normalized/health',
      );

      final status = response.data?['status'] as String? ?? '';
      if (status != 'ok') {
        emit(
          const HealthCheckState(
            status: ProgressStatus.failure,
            errorMessage: _errorText,
          ),
        );
        return;
      }

      emit(
        HealthCheckState(
          status: ProgressStatus.success,
          connectedUrl: normalized,
        ),
      );
    } on DioException catch (exception) {
      final failure = GeneralFailure.fromDioException(exception);
      emit(
        HealthCheckState(
          status: ProgressStatus.failure,
          errorMessage: '$_errorText - ${failure.errorMessage}',
        ),
      );
    } on Object catch (exception) {
      final failure = GeneralFailure.fromObject(exception);
      emit(
        HealthCheckState(
          status: ProgressStatus.failure,
          errorMessage: failure.message,
        ),
      );
    }
  }

  void reset() {
    emit(const HealthCheckState());
  }
}

class HealthCheckState {
  const HealthCheckState({
    this.status = ProgressStatus.idle,
    this.errorMessage,
    this.statusCode,
    this.connectedUrl,
  });

  final ProgressStatus status;
  final String? errorMessage;
  final String? connectedUrl;
  final int? statusCode;

  bool get isIdle => status == ProgressStatus.idle;
  bool get isLoading => status == ProgressStatus.inProgress;
  bool get isCompleted => status == ProgressStatus.success;
  bool get isFailed => status == ProgressStatus.failure;
}
