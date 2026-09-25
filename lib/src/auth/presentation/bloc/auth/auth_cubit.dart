import 'package:b2b_seller/core/errors/failures.dart';
import 'package:b2b_seller/core/services/enums.dart';
import 'package:b2b_seller/core/utils/typedef.dart';
import 'package:b2b_seller/src/auth/domain/entity/register_entity.dart';
import 'package:b2b_seller/src/auth/domain/usecase/login_usecase.dart';
import 'package:b2b_seller/src/auth/domain/usecase/register_usecase.dart';
import 'package:b2b_seller/src/auth/domain/usecase/token_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class AuthCubit extends Cubit<AuthCubitState> {
  AuthCubit(
    this._loginUsecase,
    this._registerUsecase,
    this._saveAccessTokenUseCase,
    this._saveRefreshTokenUseCase,
  ) : super(const AuthCubitState());

  final LoginUsecase _loginUsecase;
  final RegisterUsecase _registerUsecase;
  final SaveAccessTokenUseCase _saveAccessTokenUseCase;
  final SaveRefreshTokenUseCase _saveRefreshTokenUseCase;

  Future<void> login({
    required String email,
    required String password,
    required Role role,
  }) async {
    if (state.isLoading) return;
    emit(const AuthCubitState(status: ProgressStatus.inProgress));

    final result = await _loginUsecase({
      'email': email,
      'password': password,
      'role': role,
    });

    await result.fold<Future<void>>(
      (failure) async => _emitFailure(failure),
      _saveTokensAndComplete,
    );
  }

  Future<void> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phone,
    required Role role,
  }) async {
    if (state.isLoading) return;
    emit(const AuthCubitState(status: ProgressStatus.inProgress));

    final result = await _registerUsecase(
      RegisterEntity(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        role: role,
      ),
    );

    await result.fold<Future<void>>(
      (failure) async => _emitFailure(failure),
      _saveTokensAndComplete,
    );
  }

  Future<void> _saveTokensAndComplete(DataMap tokens) async {
    final accessToken = tokens['access_token'] as String?;
    if (accessToken == null || accessToken.isEmpty) {
      emit(
        const AuthCubitState(
          status: ProgressStatus.failure,
          errorMessage: 'Не удалось получить токены',
        ),
      );
      return;
    }

    await _saveAccessTokenUseCase.call(accessToken);
    final refreshToken = tokens['refresh_token'] as String?;
    if (refreshToken != null && refreshToken.isNotEmpty) {
      await _saveRefreshTokenUseCase.call(refreshToken);
    }

    emit(const AuthCubitState(status: ProgressStatus.success));
  }

  void _emitFailure(Failure failure) {
    emit(
      AuthCubitState(
        status: ProgressStatus.failure,
        errorMessage: failure.errorMessage,
        statusCode: failure is HttpFailure ? failure.statusCode : null,
      ),
    );
  }
}

class AuthCubitState {
  const AuthCubitState({
    this.status = ProgressStatus.idle,
    this.errorMessage,
    this.statusCode,
  });

  final ProgressStatus status;
  final String? errorMessage;
  final int? statusCode;

  bool get isIdle => status == ProgressStatus.idle;
  bool get isLoading => status == ProgressStatus.inProgress;
  bool get isCompleted => status == ProgressStatus.success;
  bool get isFailed => status == ProgressStatus.failure;
}
