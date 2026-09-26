import 'package:b2b_seller/core/common/widget/role_screen_widgets.dart';
import 'package:flutter/material.dart';

class MyReviewsScreen extends StatelessWidget {
  const MyReviewsScreen({super.key});

  static const path = '/my-reviews';
  static const name = 'my-reviews';

  @override
  Widget build(BuildContext context) => const FeaturePlaceholder(
    title: 'Мои отзывы',
    icon: Icons.star_outline,
  );
}
