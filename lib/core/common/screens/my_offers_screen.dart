import 'package:b2b_seller/core/common/widget/role_screen_widgets.dart';
import 'package:flutter/material.dart';

class MyOffersScreen extends StatelessWidget {
  const MyOffersScreen({super.key});

  static const path = '/my-offers';
  static const name = 'my-offers';

  @override
  Widget build(BuildContext context) => const FeaturePlaceholder(
    title: 'Мои предложения',
    icon: Icons.local_offer_outlined,
  );
}
