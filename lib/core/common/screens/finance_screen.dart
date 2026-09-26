import 'package:b2b_seller/core/common/widget/role_screen_widgets.dart';
import 'package:flutter/material.dart';

class FinanceScreen extends StatelessWidget {
  const FinanceScreen({super.key});

  static const path = '/finance';
  static const name = 'finance';

  @override
  Widget build(BuildContext context) => const FeaturePlaceholder(
    title: 'Финансы',
    icon: Icons.payments_outlined,
  );
}
