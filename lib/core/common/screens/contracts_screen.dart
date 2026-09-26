import 'package:b2b_seller/core/common/widget/role_screen_widgets.dart';
import 'package:flutter/material.dart';

class ContractsScreen extends StatelessWidget {
  const ContractsScreen({super.key});

  static const path = '/contracts';
  static const name = 'contracts';

  @override
  Widget build(BuildContext context) => const FeaturePlaceholder(
    title: 'Договоры',
    icon: Icons.description_outlined,
  );
}
