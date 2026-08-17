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
}