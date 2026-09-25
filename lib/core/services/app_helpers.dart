import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:b2b_seller/core/extensions/context_extension.dart';

class AppHelpers {
  AppHelpers._();

  // Function to show adaptive confirmation dialog
  static Future<bool?> showExitConfirmationAdaptiveDialog(
    BuildContext context,
  ) {
    return showAdaptiveDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: context.theme.cardColor,
          title: Text(
            'Exit',
            style: context.textTheme.headlineMedium,
          ),
          content: Text(
            'Are you sure you want to exit?',
            style: context.textTheme.bodyMedium,
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                overlayColor: Colors.black,
              ),
              onPressed: () {
                Navigator.of(context).pop(false); // Stay on the page
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                overlayColor: Colors.black,
              ),
              onPressed: () {
                Navigator.of(context).pop(true); // Confirm closing
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  /// Helper method to parse a value to a specific type
  static T? tryParse<T>(dynamic value) {
    if (value == null) return null;
    if (value is T) return value;
    final trimmed = value.toString().trim();
    if (trimmed.isEmpty) return null;

    if (T == int) return int.tryParse(trimmed) as T?;
    if (T == double) return double.tryParse(trimmed) as T?;
    if (T == num) return num.tryParse(trimmed) as T?;
    if (T == bool) {
      // '1' or '0' to bool
      if (trimmed == '1') return true as T?;
      if (trimmed == '0') return false as T?;
      return bool.tryParse(trimmed) as T?;
    }
    if (T == BigInt) return BigInt.tryParse(trimmed) as T?;
    if (T == DateTime) return DateTime.tryParse(trimmed) as T?;
    if (T == Uri) return Uri.tryParse(trimmed) as T?;
    if (T == String) return trimmed as T?;
    return null;
  }

  static DateTime? tryParseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString());
  }

  static Map<String, dynamic>? parseNestedJson(dynamic value) {
    if (value == null) return null;
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    if (value is String) {
      try {
        final decoded = jsonDecode(value);
        if (decoded is Map) return Map<String, dynamic>.from(decoded);
      } catch (_) {}
    }
    return null;
  }
}
