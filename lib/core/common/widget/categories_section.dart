import 'package:b2b_seller/core/common/widget/role_screen_widgets.dart';
import 'package:b2b_seller/src/public/domain/entity/category_entity.dart';
import 'package:b2b_seller/src/public/presentation/bloc/catalog_cubit.dart';
import 'package:b2b_seller/src/public/presentation/bloc/categories_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key});

  static const _maxCollapsedLines = 3;
  static const _spacing = 8.0;

  @override
  Widget build(BuildContext context) {
    final selectedId = context.select<CatalogCubit, int?>(
      (cubit) => cubit.state.categoryId,
    );

    return BlocBuilder<CategoriesCubit, CategoriesCubitState>(
      builder: (context, state) {
        final categories = [
          for (final category in state.categories)
            if (category.parentId == null) category,
        ];

        if (categories.isEmpty && !state.isLoading) {
          return const SizedBox(height: 4);
        }

        return Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SectionHeader(
                title: 'Категории',
                padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: categories.isEmpty
                    ? const _CategoriesPlaceholder()
                    : LayoutBuilder(
                        builder: (context, constraints) {
                          final textTheme = Theme.of(context).textTheme;
                          final regularStyle =
                              textTheme.labelMedium?.copyWith(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ) ??
                              const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              );
                          final selectedStyle = regularStyle.copyWith(
                            fontWeight: FontWeight.w600,
                          );
                          final visibleCount = _visibleItemCount(
                            categories,
                            constraints.maxWidth,
                            selectedId,
                            regularStyle,
                            selectedStyle,
                            MediaQuery.textScalerOf(context),
                          );
                          final hasHiddenItems =
                              visibleCount < categories.length;
                          final visibleCategories = categories.take(
                            visibleCount,
                          );

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(
                                spacing: _spacing,
                                runSpacing: _spacing,
                                children: [
                                  for (final category in visibleCategories)
                                    CategoryChip(
                                      category: category,
                                      isSelected: category.id == selectedId,
                                      maxWidth: constraints.maxWidth,
                                    ),
                                ],
                              ),
                              if (hasHiddenItems) ...[
                                const SizedBox(height: 6),
                                TextButton(
                                  onPressed: () async {
                                    await _showAllCategories(
                                      context,
                                      categories,
                                    );
                                  },
                                  style: TextButton.styleFrom(
                                    minimumSize: const Size(0, 32),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                    ),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    textStyle: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  child: const Text('Показать все'),
                                ),
                              ],
                            ],
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  int _visibleItemCount(
    List<CategoryEntity> categories,
    double maxWidth,
    int? selectedId,
    TextStyle regularStyle,
    TextStyle selectedStyle,
    TextScaler textScaler,
  ) {
    var line = 1;
    var usedWidth = 0.0;
    var visibleCount = 0;

    for (final category in categories) {
      final painter = TextPainter(
        text: TextSpan(
          text: category.name.isEmpty ? 'Без названия' : category.name,
          style: category.id == selectedId ? selectedStyle : regularStyle,
        ),
        maxLines: 1,
        textDirection: TextDirection.ltr,
        textScaler: textScaler,
      )..layout();
      final chipWidth =
          (painter.width + CategoryChip.horizontalPadding * 2 + 2)
              .clamp(0.0, maxWidth)
              .toDouble();
      final requiredWidth = usedWidth == 0
          ? chipWidth
          : usedWidth + _spacing + chipWidth;

      if (requiredWidth > maxWidth) {
        line++;
        usedWidth = chipWidth;
      } else {
        usedWidth = requiredWidth;
      }

      if (line > _maxCollapsedLines) break;
      visibleCount++;
    }

    return visibleCount;
  }

  Future<void> _showAllCategories(
    BuildContext context,
    List<CategoryEntity> categories,
  ) {
    final catalogCubit = context.read<CatalogCubit>();

    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      showDragHandle: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      clipBehavior: Clip.antiAlias,
      builder: (_) => BlocProvider.value(
        value: catalogCubit,
        child: _AllCategoriesSheet(categories: categories),
      ),
    );
  }
}

class CategoryChip extends StatelessWidget {
  const CategoryChip({
    required this.category,
    required this.isSelected,
    required this.maxWidth,
    this.onTap,
    super.key,
  });

  static const horizontalPadding = 12.0;

  final CategoryEntity category;
  final bool isSelected;
  final double maxWidth;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap:
          onTap ??
          () => context.read<CatalogCubit>().toggleCategory(category.id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        constraints: BoxConstraints(minHeight: 32, maxWidth: maxWidth),
        padding: const EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? colors.primary
              : colors.surfaceContainerHighest.withValues(alpha: 0.55),
          borderRadius: BorderRadius.circular(11),
          border: Border.all(
            color: isSelected
                ? colors.primary
                : colors.outlineVariant.withValues(alpha: 0.4),
          ),
        ),
        child: Text(
          category.name.isEmpty ? 'Без названия' : category.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textTheme.labelMedium?.copyWith(
            color: isSelected ? colors.onPrimary : colors.onSurfaceVariant,
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _AllCategoriesSheet extends StatelessWidget {
  const _AllCategoriesSheet({required this.categories});

  final List<CategoryEntity> categories;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.62,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(top: 10, bottom: 12),
                decoration: BoxDecoration(
                  color: colors.onSurfaceVariant.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 10, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Все категории',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
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
            Divider(height: 1, color: colors.outlineVariant),
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                child: BlocBuilder<CatalogCubit, CatalogCubitState>(
                  builder: (context, state) {
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        return Wrap(
                          spacing: CategoriesSection._spacing,
                          runSpacing: CategoriesSection._spacing,
                          children: [
                            for (final category in categories)
                              CategoryChip(
                                category: category,
                                isSelected:
                                    category.id == state.categoryId,
                                maxWidth: constraints.maxWidth,
                                onTap: () {
                                  context
                                      .read<CatalogCubit>()
                                      .toggleCategory(category.id);
                                  Navigator.of(context).pop();
                                },
                              ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _CategoriesPlaceholder extends StatelessWidget {
  const _CategoriesPlaceholder();

  static const _widths = [
    96.0,
    72.0,
    110.0,
    84.0,
    64.0,
    102.0,
    76.0,
  ];

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onSurface.withValues(
      alpha: 0.06,
    );

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final width in _widths)
          Container(
            width: width,
            height: 32,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(11),
            ),
          ),
      ],
    );
  }
}
