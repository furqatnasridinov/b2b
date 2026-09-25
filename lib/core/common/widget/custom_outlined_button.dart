import 'package:b2b_seller/core/common/widget/custom_loader.dart';
import 'package:b2b_seller/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class CustomOutlinedButton extends StatelessWidget {
  const CustomOutlinedButton({
    required this.onPressed,
    required this.title,
    this.width,
    this.height,
    this.isLoading = false,
    super.key,
    this.disabled = false,
  });

  final VoidCallback onPressed;
  final String title;
  final double? width;
  final double? height;
  final bool isLoading;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: disabled ? 0.5 : 1,
      child: SizedBox(
        width: width ?? context.width,
        height: height ?? 40,
        child: OutlinedButton(
          onPressed: disabled
              ? null
              : isLoading
              ? null
              : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: context.colorScheme.primary,
            disabledForegroundColor: context.colorScheme.primary.withValues(
              alpha: 0.3,
            ),
            side: BorderSide(color: context.colorScheme.primary),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: isLoading ? const CustomLoader() : Text(title),
        ),
      ),
    );
  }
}
