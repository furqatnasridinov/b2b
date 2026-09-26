import 'package:b2b_seller/core/common/widget/role_screen_widgets.dart';
import 'package:flutter/material.dart';

class ContractorsScreen extends StatelessWidget {
  const ContractorsScreen({super.key});

  static const path = '/contractors';
  static const name = 'contractors';

  @override
  Widget build(BuildContext context) => const FeaturePlaceholder(
    title: 'Исполнители',
    icon: Icons.groups_outlined,
  );
}
