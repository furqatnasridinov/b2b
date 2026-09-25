import 'package:b2b_seller/core/extensions/context_extension.dart';
import 'package:flutter/cupertino.dart';

class CustomLoader extends StatelessWidget {
  const CustomLoader({
    super.key,
    this.color,
    this.radius,
  });

  final Color? color;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return CupertinoActivityIndicator(
      color: color ?? context.colorScheme.primary,
      radius: radius ?? 12,
    );
  }
}