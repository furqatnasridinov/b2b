import 'package:b2b_seller/core/services/enums.dart';
import 'package:b2b_seller/src/public/domain/entity/supplier_public_entity.dart';
import 'package:b2b_seller/src/public/domain/usecase/get_suppliers_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class SuppliersCubit extends Cubit<SuppliersCubitState> {
  SuppliersCubit(this._getSuppliersUsecase)
    : super(const SuppliersCubitState());

  final GetSuppliersUsecase _getSuppliersUsecase;

  Future<void> get() async {
    if (state.isLoading) return;

    emit(
      SuppliersCubitState(
        status: ProgressStatus.inProgress,
        suppliers: state.suppliers,
      ),
    );

    final result = await _getSuppliersUsecase.call();

    result.fold(
      (failure) {
        emit(
          SuppliersCubitState(
            status: ProgressStatus.failure,
            errorMessage: failure.errorMessage,
            suppliers: state.suppliers,
          ),
        );
      },
      (suppliers) => emit(
        SuppliersCubitState(
          status: ProgressStatus.success,
          suppliers: suppliers,
        ),
      ),
    );
  }
}

class SuppliersCubitState {
  const SuppliersCubitState({
    this.status = ProgressStatus.idle,
    this.errorMessage,
    this.suppliers = const [],
  });

  final ProgressStatus status;
  final String? errorMessage;
  final List<SupplierPublicEntity> suppliers;

  bool get isIdle => status == ProgressStatus.idle;
  bool get isLoading => status == ProgressStatus.inProgress;
  bool get isCompleted => status == ProgressStatus.success;
  bool get isFailed => status == ProgressStatus.failure;
}
