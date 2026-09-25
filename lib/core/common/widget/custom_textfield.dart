import 'package:b2b_seller/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextfield extends StatelessWidget {
  const CustomTextfield({
    this.controller,
    this.labelText,
    super.key,
    this.keyboardType,
    this.enabled,
    this.minLines,
    this.maxLines,
    this.validator,
    this.suffixIcon,
    this.filled,
    this.fillColor,
    this.label,
    this.initialValue,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.showClearButton = false,
    this.hintText,
    this.floatingLabelBehavior,
    this.contentPadding,
    this.labelStyle,
    this.style,
    this.focusNode,
    this.prefixIcon,
    this.suffixIconConstraints,
    this.autovalidateMode,
    this.cursorColor,
    this.obscureText = false,
    this.prefixIconConstraints,
    this.maxLength,
    this.errorStyle,
    this.border,
    this.isDense = false,
    this.textInputAction,
    this.autofillHints,
    this.onFieldSubmitted,
    this.textCapitalization = TextCapitalization.sentences,
  });

  final TextEditingController? controller;
  final String? labelText;
  final TextInputType? keyboardType;
  final bool? enabled;
  final int? minLines;
  final int? maxLines;
  final String? Function(String?)? validator; // Validator parameter
  final Widget? suffixIcon;
  final bool? filled;
  final Color? fillColor;
  final Widget? label;
  final String? initialValue;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final bool readOnly;
  final bool showClearButton;
  final String? hintText;
  final FloatingLabelBehavior? floatingLabelBehavior;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? labelStyle;
  final TextStyle? style;
  final FocusNode? focusNode;
  final Widget? prefixIcon;
  final BoxConstraints? suffixIconConstraints;
  final AutovalidateMode? autovalidateMode;
  final Color? cursorColor;
  final bool obscureText;
  final BoxConstraints? prefixIconConstraints;
  final int? maxLength;
  final TextStyle? errorStyle;
  final bool isDense;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final ValueChanged<String>? onFieldSubmitted;
  final TextCapitalization textCapitalization;

  /// When set, used instead of the default [OutlineInputBorder].
  /// Color/width are applied per state via [BorderSide].
  final InputBorder? border;

  InputBorder _borderFor(Color color, double width) {
    final base = border;
    if (base == InputBorder.none) return InputBorder.none;
    if (base is UnderlineInputBorder) {
      return UnderlineInputBorder(
        borderSide: BorderSide(color: color, width: width),
        borderRadius: base.borderRadius,
      );
    }
    if (base != null) return base;
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Resolve once — ScreenUtil (.sp/.w/.r) inflates badly on tablet.
    const labelSize = 13.0; //context.byBreakpoint(phone: 12.sp, tablet: 12.0);
    const leftPad = 10.0; //context.byBreakpoint(phone: 10.w, tablet: 10.0);
    const iconMax = 48.0;
    const iconMin = 40.0; //context.byBreakpoint(phone: 40.w, tablet: 40.0);

    return AnimatedBuilder(
      animation: controller ?? TextEditingController(),
      builder: (context, _) {
        final colors = context.colorScheme;
        return TextFormField(
          focusNode: focusNode,
          textCapitalization: textCapitalization,
          validator: validator, //Apply the validator
          cursorColor: cursorColor ?? colors.primary,
          autovalidateMode: autovalidateMode,
          enabled: enabled,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          autofillHints: autofillHints,
          minLines: minLines,
          initialValue: initialValue,
          maxLines: maxLines,
          maxLength: maxLength,
          readOnly: readOnly,
          obscureText: obscureText,
          onChanged: onChanged,
          onFieldSubmitted: onFieldSubmitted,
          onTap: onTap,
          onTapOutside: (event) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          inputFormatters:
              keyboardType ==
                  const TextInputType.numberWithOptions(
                    decimal: true,
                  )
              ? <TextInputFormatter>[DecimalTextInputFormatter()]
              : null,
          controller: controller,
          style:
              style ??
              context.textTheme.bodyMedium?.copyWith(
                fontSize: 14,
              ),
          decoration: InputDecoration(
            isDense: isDense,
            label: label,
            filled: filled,
            fillColor: fillColor,
            labelText: labelText,
            hintText: hintText,
            hintMaxLines: 1,
            alignLabelWithHint: true,
            hintStyle: context.textTheme.bodyMedium?.copyWith(
              color: colors.onSurface.withValues(alpha: 0.5),
              fontSize: labelSize,
            ),
            contentPadding:
                contentPadding ?? EdgeInsets.zero.copyWith(left: leftPad),
            labelStyle:
                labelStyle ??
                context.textTheme.bodyMedium?.copyWith(
                  color: colors.onSurface.withValues(alpha: 0.5),
                  fontSize: labelSize,
                ),
            prefixIcon: prefixIcon,
            prefixIconConstraints:
                prefixIconConstraints ??
                const BoxConstraints(
                  maxWidth: iconMax,
                  minWidth: iconMin,
                ),
            floatingLabelBehavior:
                floatingLabelBehavior ?? FloatingLabelBehavior.auto,
            suffixIcon:
                suffixIcon ??
                ((controller?.text.isNotEmpty ?? false) &&
                        (enabled ?? true) &&
                        showClearButton
                    ? IconButton(
                        icon: const Icon(
                          Icons.close,
                          weight: 0.5,
                          size: 16,
                        ),
                        color: colors.onSurface.withValues(alpha: 0.5),
                        onPressed: controller?.clear,
                      )
                    : null),
            suffixIconConstraints:
                suffixIconConstraints ??
                const BoxConstraints(
                  maxWidth: iconMax,
                  minWidth: iconMin,
                ),
            border: _borderFor(colors.outline, 0.6),
            enabledBorder: _borderFor(colors.outline, 0.6),
            disabledBorder: _borderFor(colors.outline, 0.3),
            focusedBorder: _borderFor(colors.primary, 0.7),
            errorBorder: _borderFor(colors.error, 0.5),
            focusedErrorBorder: _borderFor(colors.error, 0.5),
            errorStyle:
                errorStyle ??
                context.textTheme.bodyMedium?.copyWith(
                  color: colors.error,
                  fontSize: labelSize,
                  fontWeight: FontWeight.w400,
                ),
            errorMaxLines: 2, // Optional: Set max lines for error
            counterText: '',
          ),
        );
      },
    );
  }
}

class DecimalTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    // Allow empty input
    if (text.isEmpty) {
      return newValue;
    }

    // Allow only digits and a single decimal point
    final regex = RegExp(r'^\d*\.?\d*$');
    if (regex.hasMatch(text)) {
      return newValue;
    }

    // If the input doesn't match the pattern, return the old value
    return oldValue;
  }
}

/* class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) return newValue;

    final digits = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    if (digits.isEmpty) return newValue.copyWith(text: '');

    final number = int.tryParse(digits);
    if (number == null) return oldValue;

    final formatted = NumberFormat('#,###', 'en_US')
        .format(number)
        .replaceAll(',', ' '); // 30 000

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
} */
