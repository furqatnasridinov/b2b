import 'package:b2b_seller/core/services/enums.dart';
import 'package:b2b_seller/src/public/domain/entity/category_entity.dart';
import 'package:b2b_seller/src/public/domain/usecase/get_categories_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class CategoriesCubit extends Cubit<CategoriesCubitState> {
  CategoriesCubit(this._getCategoriesUsecase)
    : super(const CategoriesCubitState());

  final GetCategoriesUsecase _getCategoriesUsecase;

  Future<void> get() async {
    if (state.isLoading) return;

    emit(
      CategoriesCubitState(
        status: ProgressStatus.inProgress,
        categories: state.categories,
      ),
    );

    final result = await _getCategoriesUsecase.call();

    result.fold(
      (failure) {
        emit(
          CategoriesCubitState(
            status: ProgressStatus.failure,
            errorMessage: failure.errorMessage,
            categories: state.categories,
          ),
        );
      },
      (categories) => emit(
        CategoriesCubitState(
          status: ProgressStatus.success,
          categories: categories,
        ),
      ),
    );
  }
}

class CategoriesCubitState {
  const CategoriesCubitState({
    this.status = ProgressStatus.idle,
    this.errorMessage,
    this.categories = const [],
  });

  final ProgressStatus status;
  final String? errorMessage;
  final List<CategoryEntity> categories;

  bool get isIdle => status == ProgressStatus.idle;
  bool get isLoading => status == ProgressStatus.inProgress;
  bool get isCompleted => status == ProgressStatus.success;
  bool get isFailed => status == ProgressStatus.failure;
}
