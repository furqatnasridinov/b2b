import 'package:b2b_seller/core/common/widget/custom_loader.dart';
import 'package:b2b_seller/core/extensions/context_extension.dart';
import 'package:b2b_seller/core/extensions/type_extension.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';



class CustomCachedImage extends StatelessWidget {
  const CustomCachedImage({
    required this.url,
    this.width,
    this.height,
    this.fit,
    this.borderRadius,
    this.errorWidget,
    super.key,
  });

  final String? url;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final double? borderRadius;
  final Widget? errorWidget;

  @override
  Widget build(BuildContext context) {
    final bool hasUrl = url.isNotNullOrEmpty;
    
    if (!hasUrl) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius ?? 0),
        child: SizedBox(
          width: width, 
          height: height,
          child: _error(context),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius ?? 0),
      child: CachedNetworkImage(
        imageUrl: url ?? '',
        width: width,
        height: height,
        fit: fit ?? BoxFit.cover,
        placeholder: (context, url) => _placeholder(context),
        errorWidget: (context, url, error) => errorWidget ?? _error(context),
        fadeInDuration: Duration.zero,
        fadeOutDuration: Duration.zero,
        placeholderFadeInDuration: Duration.zero,
      ),
    );
  }

  Widget _placeholder(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainer,
      ),
      child: const CustomLoader(),
    );
  }

  Widget _error(BuildContext context) {    
    return DecoratedBox(
        decoration: BoxDecoration(
          color: context.colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Icon(
            Icons.image_not_supported_outlined,
            color: context.colorScheme.onSurfaceVariant,
            size: 40,
          ),
        ),
      );
  }

   /* Widget _noImage(BuildContext context) {
    return DecoratedBox(
        decoration: BoxDecoration(
          color: context.colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            'Нет изображения',
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      );
  } */
}
