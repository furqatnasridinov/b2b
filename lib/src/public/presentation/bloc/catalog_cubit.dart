import 'package:b2b_seller/core/services/enums.dart';
import 'package:b2b_seller/src/public/domain/entity/catalog_item_entity.dart';
import 'package:b2b_seller/src/public/domain/usecase/get_catalog_items_usecase.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class CatalogCubit extends Cubit<CatalogCubitState> {
  CatalogCubit(this._getCatalogItemsUsecase) : super(const CatalogCubitState());

  final GetCatalogItemsUsecase _getCatalogItemsUsecase;
  int _requestId = 0;

  /// Keeps the current search query when [search] is omitted.
  Future<void> get({String? search}) async {
    final query = search ?? state.search;
    if (state.isLoading && query == state.search) return;

    final requestId = ++_requestId;
    emit(
      state.copyWith(
        status: ProgressStatus.inProgress,
        errorMessage: () => null,
        search: query,
      ),
    );

    final result = await _getCatalogItemsUsecase.call(query);
    if (isClosed || requestId != _requestId) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ProgressStatus.failure,
          errorMessage: () => failure.errorMessage,
        ),
      ),
      (items) => emit(
        state.copyWith(status: ProgressStatus.success, items: items),
      ),
    );
  }

  /// `null` means all types.
  void selectType(CatalogType? type) {
    if (state.type == type) return;
    emit(state.copyWith(type: () => type));
  }

  /// Selecting the active category again clears the filter.
  void toggleCategory(int categoryId) {
    final next = state.categoryId == categoryId ? null : categoryId;
    emit(state.copyWith(categoryId: () => next));
  }

  void selectSort(CatalogSort sort) {
    if (state.sort == sort) return;
    emit(state.copyWith(sort: sort));
  }
}

class CatalogCubitState {
  const CatalogCubitState({
    this.status = ProgressStatus.idle,
    this.errorMessage,
    this.items = const [],
    this.search = '',
    this.type,
    this.categoryId,
    this.sort = CatalogSort.defaultOrder,
  });

  final ProgressStatus status;
  final String? errorMessage;
  final List<CatalogItemEntity> items;
  final String search;
  final CatalogType? type;
  final int? categoryId;
  final CatalogSort sort;

  bool get isIdle => status == ProgressStatus.idle;
  bool get isLoading => status == ProgressStatus.inProgress;
  bool get isCompleted => status == ProgressStatus.success;
  bool get isFailed => status == ProgressStatus.failure;

  bool get isFiltered =>
      search.isNotEmpty || type != null || categoryId != null;

  List<CatalogItemEntity> get visibleItems {
    final visible = [
      for (final item in items)
        if ((type == null || item.type == type) &&
            (categoryId == null ||
                item.categoryId == categoryId ||
                item.category?.parentId == categoryId))
          item,
    ];

    switch (sort) {
      case CatalogSort.defaultOrder:
        return visible;
      case CatalogSort.newest:
        visible.sort(
          (a, b) => _dateValue(b.createdAt).compareTo(
            _dateValue(a.createdAt),
          ),
        );
        return visible;
      case CatalogSort.priceLowToHigh:
        visible.sort((a, b) => _comparePrice(a, b));
        return visible;
      case CatalogSort.priceHighToLow:
        visible.sort((a, b) => _comparePrice(a, b, descending: true));
        return visible;
      case CatalogSort.popular:
        visible.sort(
          (a, b) => _popularity(b).compareTo(_popularity(a)),
        );
        return visible;
    }
  }

  CatalogCubitState copyWith({
    ProgressStatus? status,
    ValueGetter<String?>? errorMessage,
    List<CatalogItemEntity>? items,
    String? search,
    ValueGetter<CatalogType?>? type,
    ValueGetter<int?>? categoryId,
    CatalogSort? sort,
  }) {
    return CatalogCubitState(
      status: status ?? this.status,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      items: items ?? this.items,
      search: search ?? this.search,
      type: type != null ? type() : this.type,
      categoryId: categoryId != null ? categoryId() : this.categoryId,
      sort: sort ?? this.sort,
    );
  }
}

int _dateValue(DateTime? value) => value?.millisecondsSinceEpoch ?? 0;

num _popularity(CatalogItemEntity item) {
  return (item.stats?.views ?? 0) + (item.stats?.leads ?? 0);
}

num? _price(CatalogItemEntity item) {
  final pricing = item.pricing;
  return pricing?.fixedPrice ?? pricing?.hourlyRate ?? pricing?.monthlyRate;
}

int _comparePrice(
  CatalogItemEntity first,
  CatalogItemEntity second, {
  bool descending = false,
}) {
  final firstPrice = _price(first);
  final secondPrice = _price(second);
  if (firstPrice == null && secondPrice == null) return 0;
  if (firstPrice == null) return 1;
  if (secondPrice == null) return -1;
  return descending
      ? secondPrice.compareTo(firstPrice)
      : firstPrice.compareTo(secondPrice);
}
