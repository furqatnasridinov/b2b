import 'dart:async';

import 'package:b2b_seller/core/common/widget/catalog_widgets.dart';
import 'package:b2b_seller/core/common/widget/categories_section.dart';
import 'package:b2b_seller/core/common/widget/search_field_for_paginate.dart';
import 'package:b2b_seller/core/extensions/type_extension.dart';
import 'package:b2b_seller/core/injection/injection.dart';
import 'package:b2b_seller/core/services/app_snackbar.dart';
import 'package:b2b_seller/core/services/enums.dart';
import 'package:b2b_seller/src/public/presentation/bloc/catalog_cubit.dart';
import 'package:b2b_seller/src/public/presentation/bloc/categories_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BuyerHomeScreen extends StatelessWidget {
  const BuyerHomeScreen({super.key});

  static const path = '/buyer-home';
  static const name = 'buyer-home';

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) {
            final cubit = sl<CatalogCubit>();
            unawaited(cubit.get());
            return cubit;
          },
        ),
        BlocProvider(
          create: (_) {
            final cubit = sl<CategoriesCubit>();
            unawaited(cubit.get());
            return cubit;
          },
        ),
      ],
      child: const _BuyerHomeView(),
    );
  }
}

class _BuyerHomeView extends StatefulWidget {
  const _BuyerHomeView();

  @override
  State<_BuyerHomeView> createState() => _BuyerHomeViewState();
}

class _BuyerHomeViewState extends State<_BuyerHomeView> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refresh() {
    return Future.wait([
      context.read<CatalogCubit>().get(),
      context.read<CategoriesCubit>().get(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CatalogCubit, CatalogCubitState>(
      listenWhen: (previous, current) =>
          current.isFailed && current.items.isNotEmpty,
      listener: (context, state) {
        AppSnackBar.showError(
          context,
          message: state.errorMessage ?? 'Не удалось обновить каталог',
        );
      },
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: SearchFieldForPaginate(
                searchController: _searchController,
                hintText: 'Поиск товаров и услуг',
                onSearch: (query) => unawaited(
                  context.read<CatalogCubit>().get(search: query),
                ),
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refresh,
                child: const CustomScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20, 12, 20, 0),
                        child: _CatalogTypeTabs(),
                      ),
                    ),
                    SliverToBoxAdapter(child: CategoriesSection()),
                    SliverToBoxAdapter(child: _CatalogHeader()),
                    CatalogGridSliver(),
                    SliverToBoxAdapter(child: SizedBox(height: 110)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CatalogTypeTabs extends StatelessWidget {
  const _CatalogTypeTabs();

  static const _options = <CatalogType?>[null, ...CatalogType.values];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final selected = context.select<CatalogCubit, CatalogType?>(
      (cubit) => cubit.state.type,
    );
    return Container(
      height: 44,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          for (final option in _options)
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => context.read<CatalogCubit>().selectType(option),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOut,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: option == selected
                        ? colors.primary
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    option?.pluralName ?? 'Все',
                    style: textTheme.labelLarge?.copyWith(
                      color: option == selected
                          ? colors.onPrimary
                          : colors.onSurfaceVariant,
                      fontWeight: option == selected
                          ? FontWeight.w600
                          : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CatalogHeader extends StatelessWidget {
  const _CatalogHeader();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final type = context.select<CatalogCubit, CatalogType?>(
      (cubit) => cubit.state.type,
    );
    final count = context.select<CatalogCubit, int>(
      (cubit) => cubit.state.visibleItems.length,
    );
    final hasItems = context.select<CatalogCubit, bool>(
      (cubit) => cubit.state.items.isNotEmpty,
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 12, 12),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    type?.pluralName ?? 'Все предложения',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (hasItems) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: colors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: colors.outlineVariant.withValues(alpha: 0.45),
                      ),
                    ),
                    child: Text(
                      count.toK(),
                      style: textTheme.labelMedium?.copyWith(
                        color: colors.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (hasItems) ...[
            const SizedBox(width: 8),
            InkWell(
              onTap: () async => _showSortSheet(context),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 6,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Сортировка',
                      style: textTheme.labelMedium?.copyWith(
                        color: colors.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 3),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 20,
                      color: colors.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _showSortSheet(BuildContext context) {
    final catalogCubit = context.read<CatalogCubit>();

    return showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      showDragHandle: false,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      clipBehavior: Clip.antiAlias,
      builder: (_) => BlocProvider.value(
        value: catalogCubit,
        child: const _SortSheet(),
      ),
    );
  }
}

class _SortSheet extends StatelessWidget {
  const _SortSheet();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final selected = context.select<CatalogCubit, CatalogSort>(
      (cubit) => cubit.state.sort,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colors.onSurfaceVariant.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Сортировка',
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Выберите порядок предложений',
                        style: textTheme.bodySmall?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded),
                  tooltip: 'Закрыть',
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          for (final sort in CatalogSort.values) ...[
            _SortOption(
              sort: sort,
              isSelected: sort == selected,
              onTap: () {
                context.read<CatalogCubit>().selectSort(sort);
                Navigator.of(context).pop();
              },
            ),
            if (sort != CatalogSort.values.last) const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}

class _SortOption extends StatelessWidget {
  const _SortOption({
    required this.sort,
    required this.isSelected,
    required this.onTap,
  });

  final CatalogSort sort;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: isSelected
          ? colors.primaryContainer.withValues(alpha: 0.55)
          : colors.surfaceContainerLow,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(13),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isSelected
                      ? colors.primary
                      : colors.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _sortIcon(sort),
                  size: 21,
                  color: isSelected
                      ? colors.onPrimary
                      : colors.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sort.nameTr,
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      sort.description,
                      style: textTheme.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: isSelected ? colors.primary : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? colors.primary
                        : colors.outlineVariant,
                    width: 1.5,
                  ),
                ),
                child: isSelected
                    ? Icon(
                        Icons.check_rounded,
                        size: 15,
                        color: colors.onPrimary,
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

IconData _sortIcon(CatalogSort sort) {
  return switch (sort) {
    CatalogSort.defaultOrder => Icons.auto_awesome_motion_outlined,
    CatalogSort.newest => Icons.new_releases_outlined,
    CatalogSort.priceLowToHigh => Icons.trending_up_rounded,
    CatalogSort.priceHighToLow => Icons.trending_down_rounded,
    CatalogSort.popular => Icons.local_fire_department_outlined,
  };
}
