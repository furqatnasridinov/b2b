extension StringExtension on String? {
  bool get isNullOrEmpty => this == null || this!.trim().isEmpty;
  bool get isNotNullOrEmpty => !isNullOrEmpty;
}

extension BooleanEx on bool? {
  bool notNullAndTrue() {
    return this != null && this!;
  }

  bool notNullAndFalse() {
    return this != null && !this!;
  }
}

extension NumExtension on num {
  String toK() {
    if (abs() < 1000) {
      return this == roundToDouble() ? toInt().toString() : toString();
    }

    final isMillion = abs() >= 1000000;
    final value = this / (isMillion ? 1000000 : 1000);
    final formatted = value == value.roundToDouble()
        ? value.toInt().toString()
        : value.toStringAsFixed(1);
    return '$formatted${isMillion ? 'M' : 'K'}';
  }
}
