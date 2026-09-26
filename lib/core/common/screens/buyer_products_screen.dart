import 'dart:async';

import 'package:b2b_seller/core/common/widget/custom_loader.dart';
import 'package:b2b_seller/core/common/widget/role_screen_widgets.dart';
import 'package:b2b_seller/core/injection/injection.dart';
import 'package:b2b_seller/core/services/app_snackbar.dart';
import 'package:b2b_seller/core/services/enums.dart';
import 'package:b2b_seller/src/catalog/domain/entity/catalog_item_entity.dart';
import 'package:b2b_seller/src/catalog/domain/entity/media_entity.dart';
import 'package:b2b_seller/src/catalog/domain/entity/pricing_entity.dart';
import 'package:b2b_seller/src/catalog/presentation/bloc/catalog_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BuyerProductsScreen extends StatelessWidget {
  const BuyerProductsScreen({super.key});

  static const path = '/buyer-products';
  static const name = 'buyer-products';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = sl<CatalogCubit>();
        unawaited(cubit.get());
        return cubit;
      },
      child: const _BuyerProductsView(),
    );
  }
}

class _BuyerProductsView extends StatelessWidget {
  const _BuyerProductsView();

  @override
  Widget build(BuildContext context) {
    return SectionScreenLayout(
      title: 'Товары и услуги',
      child: BlocListener<CatalogCubit, CatalogCubitState>(
        listenWhen: (previous, current) =>
            current.isFailed && current.items.isNotEmpty,
        listener: (context, state) {
          AppSnackBar.showError(
            context,
            message: state.errorMessage ?? 'Не удалось обновить каталог',
          );
        },
        child: BlocBuilder<CatalogCubit, CatalogCubitState>(
          builder: (context, state) {
            if (state.isLoading && state.items.isEmpty) {
              return const Center(child: CustomLoader());
            }
            if (state.isFailed && state.items.isEmpty) {
              return _CatalogMessage(
                message: state.errorMessage ?? 'Не удалось загрузить каталог',
                onRetry: () => unawaited(context.read<CatalogCubit>().get()),
              );
            }
            if (state.items.isEmpty) {
              return const EmptyState(
                icon: Icons.inventory_2_outlined,
                title: 'Каталог пуст',
                description: 'Предложения исполнителей появятся здесь.',
              );
            }

            return RefreshIndicator(
              onRefresh: () => context.read<CatalogCubit>().get(),
              child: GridView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 100),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  mainAxisExtent: 260,
                ),
                itemCount: state.items.length,
                itemBuilder: (context, index) {
                  return _CatalogCard(item: state.items[index]);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CatalogCard extends StatelessWidget {
  const _CatalogCard({required this.item});

  final CatalogItemEntity item;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final category = item.category?.name.trim();
    final price = _priceLabel(item.pricing);
    final description = item.description?.trim();

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colors.outlineVariant.withValues(alpha: 0.45),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(16),
            ),
            child: SizedBox(
              height: 112,
              child: _CatalogMedia(item: item),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (category != null && category.isNotEmpty)
                    Text(
                      category,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.labelMedium?.copyWith(
                        color: colors.primary,
                      ),
                    ),
                  const SizedBox(height: 4),
                  Text(
                    item.title?.trim().isNotEmpty ?? false
                        ? item.title!.trim()
                        : 'Без названия',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (description != null && description.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                        height: 1.3,
                      ),
                    ),
                  ],
                  const Spacer(),
                  if (price != null)
                    Text(
                      price,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CatalogMedia extends StatelessWidget {
  const _CatalogMedia({required this.item});

  final CatalogItemEntity item;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final url = _imageUrl(item.media);
    final placeholder = ColoredBox(
      color: colors.primary.withValues(alpha: 0.08),
      child: Icon(
        item.type == CatalogType.service
            ? Icons.design_services_outlined
            : Icons.inventory_2_outlined,
        color: colors.primary,
        size: 32,
      ),
    );

    if (url == null) return placeholder;

    return Image.network(
      url,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => placeholder,
    );
  }
}

class _CatalogMessage extends StatelessWidget {
  const _CatalogMessage({
    required this.message,
    required this.onRetry,
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
  final text = value == value.roundToDouble()
      ? value.toInt().toString()
      : value.toString();
  if (currency.isEmpty) return text;
  return '$text $currency';
}
