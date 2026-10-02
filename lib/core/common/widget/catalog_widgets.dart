import 'dart:async';

import 'package:b2b_seller/core/common/widget/custom_cached_image.dart';
import 'package:b2b_seller/core/common/widget/custom_loader.dart';
import 'package:b2b_seller/core/common/widget/role_screen_widgets.dart';
import 'package:b2b_seller/core/services/enums.dart';
import 'package:b2b_seller/src/public/domain/entity/catalog_item_entity.dart';
import 'package:b2b_seller/src/public/domain/entity/media_entity.dart';
import 'package:b2b_seller/src/public/domain/entity/pricing_entity.dart';
import 'package:b2b_seller/src/public/presentation/bloc/catalog_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Sliver grid of catalog items driven by [CatalogCubit].
class CatalogGridSliver extends StatelessWidget {
  const CatalogGridSliver({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CatalogCubit, CatalogCubitState>(
      builder: (context, state) {
        if (state.isLoading && state.items.isEmpty) {
          return const SliverToBoxAdapter(
            child: SizedBox(
              height: 200,
              child: Center(child: CustomLoader()),
            ),
          );
        }
        if (state.isFailed && state.items.isEmpty) {
          return SliverToBoxAdapter(
            child: CatalogMessage(
              message: state.errorMessage ?? 'Не удалось загрузить каталог',
              onRetry: () => unawaited(context.read<CatalogCubit>().get()),
            ),
          );
        }
        final items = state.visibleItems;
        if (items.isEmpty) {
          final isSearching = state.isFiltered;
          return SliverToBoxAdapter(
            child: EmptyState(
              icon: isSearching
                  ? Icons.search_off_rounded
                  : Icons.inventory_2_outlined,
              title: isSearching ? 'Ничего не найдено' : 'Каталог пуст',
              description: isSearching
                  ? 'Попробуйте изменить запрос или фильтры.'
                  : 'Предложения исполнителей появятся здесь.',
            ),
          );
        }

        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          sliver: SliverGrid.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              mainAxisExtent: 310,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return CatalogCard(item: items[index]);
            },
          ),
        );
      },
    );
  }
}

class CatalogCard extends StatelessWidget {
  const CatalogCard({required this.item, super.key});

  final CatalogItemEntity item;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final category = item.category?.name.trim();
    final price = _priceLabel(item.pricing);
    final stats = item.stats;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colors.outlineVariant.withValues(alpha: 0.35),
        ),
      ),
      child: ClipRRect(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: _CatalogMedia(item: item),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 7),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title?.trim().isNotEmpty ?? false
                          ? item.title!.trim()
                          : 'Без названия',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w500,
                        height: 1.2,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      price ?? 'Цена по запросу',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: colors.primary.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.storefront_outlined,
                            size: 11,
                            color: colors.primary,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            category?.isNotEmpty ?? false
                                ? category!
                                : item.type?.nameTr ?? 'Каталог',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.labelSmall?.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.star_rounded,
                          size: 15,
                          color: Color(0xFFFFB800),
                        ),
                        Text(
                          '4.9',
                          style: textTheme.labelSmall?.copyWith(
                            color: colors.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${_compactNumber(stats?.views)} просмотров'
                      ' · ${_compactNumber(stats?.leads)} заявок',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.labelSmall?.copyWith(
                        color: colors.onSurfaceVariant.withValues(alpha: 0.75),
                      ),
                    ),
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

class _CatalogMedia extends StatelessWidget {
  const _CatalogMedia({required this.item});

  final CatalogItemEntity item;

  @override
  Widget build(BuildContext context) {
    final url = _imageUrl(item.media);
    return CustomCachedImage(
      url: url,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
    );
  }
}

class CatalogMessage extends StatelessWidget {
  const CatalogMessage({
    required this.message,
    required this.onRetry,
    super.key,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded, size: 42),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: onRetry,
              child: const Text('Повторить'),
            ),
          ],
        ),
      ),
    );
  }
}

String? _imageUrl(List<MediaEntity> media) {
  for (final item in media) {
    final url = item.fileUrl?.trim();
    if (url == null || url.isEmpty) continue;
    final uri = Uri.tryParse(url);
    if (uri != null && (uri.scheme == 'http' || uri.scheme == 'https')) {
      return url;
    }
  }
  return null;
}

String? _priceLabel(PricingEntity? pricing) {
  if (pricing == null) return null;
  final currency = pricing.currency?.trim() ?? '';
  final fixed = pricing.fixedPrice;
  final hourly = pricing.hourlyRate;
  final monthly = pricing.monthlyRate;
  if (fixed != null) return _amount(fixed, currency);
  if (hourly != null) return '${_amount(hourly, currency)}/час';
  if (monthly != null) return '${_amount(monthly, currency)}/мес';
  return null;
}

String _amount(num value, String currency) {
  final raw = value == value.roundToDouble()
      ? value.toInt().toString()
      : value.toStringAsFixed(2).replaceFirst(RegExp(r'\.?0+$'), '');
  final sign = raw.startsWith('-') ? '-' : '';
  final unsigned = sign.isEmpty ? raw : raw.substring(1);
  final parts = unsigned.split('.');
  final integer = parts.first.replaceAllMapped(
    RegExp(r'(?<=\d)(?=(\d{3})+$)'),
    (_) => ' ',
  );
  final text = '$sign$integer${parts.length > 1 ? '.${parts.last}' : ''}';
  final currencyLabel = switch (currency.toUpperCase()) {
    'RUB' || 'RUR' => '₽',
    'USD' => r'$',
    'EUR' => '€',
    _ => currency,
  };
  if (currencyLabel.isEmpty) return text;
  return '$text $currencyLabel';
}

String _compactNumber(int? value) {
  final number = value ?? 0;
  if (number >= 1000000) {
    return '${(number / 1000000).toStringAsFixed(1).replaceFirst('.0', '')}млн';
  }
  if (number >= 1000) {
    return '${(number / 1000).toStringAsFixed(1).replaceFirst('.0', '')}тыс.';
  }
  return number.toString();
}
