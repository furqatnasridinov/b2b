import 'package:b2b_seller/core/common/widget/custom_loader.dart';
import 'package:b2b_seller/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.onPressed,
    required this.title,
    this.width,
    this.height,
    this.isLoading = false,
    super.key,
    this.backgroundColor,
    this.foregroundColor,
    this.isDisabled = false,
    this.child,
  });

  final VoidCallback onPressed;
  final String title;
  final double? width;
  final double? height;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool isDisabled;
  final Widget? child; // second widget to show instead of title

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? context.width,
      height: height ?? 40,
      child: FilledButton(
        //onLongPress: () {},
        onPressed: isLoading || isDisabled ? null : onPressed,
        style: FilledButton.styleFrom(
          foregroundColor: foregroundColor ?? context.colorScheme.onPrimary,
          backgroundColor: backgroundColor ?? context.colorScheme.primary,
          disabledBackgroundColor: context.colorScheme.primary.withValues(
            alpha: 0.3,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: isLoading ? const CustomLoader() : child ?? Text(title),
      ),
    );
  }
}
