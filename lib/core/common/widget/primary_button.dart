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
    this.addShadow = false,
  });

  final VoidCallback onPressed;
  final String title;
  final double? width;
  final double? height;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool isDisabled;
  final Widget? child;
  final bool addShadow;

  @override
  Widget build(BuildContext context) {
    final resolvedBackground = backgroundColor ?? context.colorScheme.primary;

    return Container(
      width: width ?? context.width,
      height: height ?? 40,
      decoration: addShadow
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: resolvedBackground.withValues(alpha: 0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 5),
                ),
              ],
            )
          : null,
      child: FilledButton(
        onPressed: isLoading || isDisabled ? null : onPressed,
        style: FilledButton.styleFrom(
          foregroundColor: foregroundColor ?? context.colorScheme.onPrimary,
          backgroundColor: resolvedBackground,
          disabledBackgroundColor: context.colorScheme.primary.withValues(
            alpha: 0.3,
          ),
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: isLoading
            ? CustomLoader(
                color: context.colorScheme.onPrimary,
              )
            : child ?? Text(title),
      ),
    );
  }
}
