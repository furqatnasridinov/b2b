import 'package:b2b_seller/core/services/enums.dart';
import 'package:b2b_seller/src/catalog/domain/entity/catalog_item_entity.dart';
import 'package:b2b_seller/src/catalog/domain/usecase/get_catalog_items_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class CatalogCubit extends Cubit<CatalogCubitState> {
  CatalogCubit(this._getCatalogItemsUsecase) : super(const CatalogCubitState());

  final GetCatalogItemsUsecase _getCatalogItemsUsecase;

  Future<void> get() async {
    if (state.isLoading) return;

    emit(
      CatalogCubitState(
        status: ProgressStatus.inProgress,
        items: state.items,
      ),
    );

    final result = await _getCatalogItemsUsecase.call();

    result.fold(
      (failure) {
        emit(
          CatalogCubitState(
            status: ProgressStatus.failure,
            errorMessage: failure.errorMessage,
            items: state.items,
          ),
        );
      },
      (items) => emit(
        CatalogCubitState(
          status: ProgressStatus.success,
          items: items,
        ),
      ),
    );
  }
}

class CatalogCubitState {
  const CatalogCubitState({
    this.status = ProgressStatus.idle,
    this.errorMessage,
    this.items = const [],
  });

  final ProgressStatus status;
  final String? errorMessage;
  final List<CatalogItemEntity> items;

  bool get isIdle => status == ProgressStatus.idle;
  bool get isLoading => status == ProgressStatus.inProgress;
  bool get isCompleted => status == ProgressStatus.success;
  bool get isFailed => status == ProgressStatus.failure;
}
