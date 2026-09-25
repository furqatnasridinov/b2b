import 'package:b2b_seller/core/errors/failures.dart';
import 'package:b2b_seller/core/services/enums.dart';
import 'package:b2b_seller/src/auth/domain/usecase/token_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class LogOutCubit extends Cubit<LogOutState> {
  LogOutCubit(
    this._deleteAccessTokenUseCase,
    this._deleteRefreshTokenUseCase,
  ) : super(const LogOutState());

  final DeleteAccessTokenUseCase _deleteAccessTokenUseCase;
  final DeleteRefreshTokenUseCase _deleteRefreshTokenUseCase;

  Future<void> logOut() async {
    if (state.isLoading) return;
    emit(const LogOutState(status: ProgressStatus.inProgress));

    final results = await Future.wait([
      _deleteAccessTokenUseCase.call(),
      _deleteRefreshTokenUseCase.call(),
    ]);
    if (isClosed) return;

    Failure? failure;
    for (final result in results) {
      result.fold(
        (currentFailure) => failure ??= currentFailure,
        (_) {},
      );
    }

    final currentFailure = failure;
    if (currentFailure != null) {
      emit(
        LogOutState(
          status: ProgressStatus.failure,
          errorMessage: currentFailure.errorMessage,
          statusCode: currentFailure is HttpFailure
              ? currentFailure.statusCode
              : null,
        ),
      );
      return;
    }

    emit(const LogOutState(status: ProgressStatus.success));
  }
}

class LogOutState {
  const LogOutState({
    this.status = ProgressStatus.idle,
    this.errorMessage,
    this.statusCode,
  });

  final ProgressStatus status;
  final String? errorMessage;
  final int? statusCode;

  bool get isLoading => status == ProgressStatus.inProgress;
  bool get isCompleted => status == ProgressStatus.success;
  bool get isFailed => status == ProgressStatus.failure;
}
