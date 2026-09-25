import 'package:b2b_seller/core/services/enums.dart';
import 'package:b2b_seller/src/auth/domain/entity/user_entity.dart';
import 'package:b2b_seller/src/auth/domain/usecase/auth_user_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class MeCubit extends Cubit<MeCubitState> {
  MeCubit(
    this._getCurrentUserUsecase,
  ) : super(const MeCubitState());

  final GetCurrentUserUsecase _getCurrentUserUsecase;

  Future<void> get() async {
    emit(
      const MeCubitState(status: ProgressStatus.inProgress),
    );

    final result = await _getCurrentUserUsecase.call();

    result.fold(
      (failure) {
        emit(
          MeCubitState(
            status: ProgressStatus.failure,
            errorMessage: failure.errorMessage,
            statusCode: failure.statusCode,
          ),
        );
      },
      (response) => emit(
        MeCubitState(
          status: ProgressStatus.success,
          user: response,
        ),
      ),
    );
  }
}

class MeCubitState {
  const MeCubitState({
    this.status = ProgressStatus.idle,
    this.errorMessage,
    this.user,
    this.statusCode,
  });

  final ProgressStatus status;
  final String? errorMessage;
  final UserEntity? user;
  final int? statusCode;

  bool get isIdle => status == ProgressStatus.idle;
  bool get isLoading => status == ProgressStatus.inProgress;
  bool get isCompleted => status == ProgressStatus.success;
  bool get isFailed => status == ProgressStatus.failure;
}
