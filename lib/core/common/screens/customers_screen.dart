import 'package:b2b_seller/core/common/widget/role_screen_widgets.dart';
import 'package:flutter/material.dart';

class CustomersScreen extends StatelessWidget {
  const CustomersScreen({super.key});

  static const path = '/customers';
  static const name = 'customers';

  @override
  Widget build(BuildContext context) => const FeaturePlaceholder(
    title: 'Заказчики',
    icon: Icons.business_center_outlined,
  );
}
