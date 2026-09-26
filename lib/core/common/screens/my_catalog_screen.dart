import 'package:b2b_seller/core/common/widget/role_screen_widgets.dart';
import 'package:flutter/material.dart';

class MyCatalogScreen extends StatelessWidget {
  const MyCatalogScreen({super.key});

  static const path = '/my-catalog';
  static const name = 'my-catalog';

  @override
  Widget build(BuildContext context) => const FeaturePlaceholder(
    title: 'Мой каталог',
    icon: Icons.inventory_2_outlined,
  );
}
