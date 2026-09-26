import 'package:b2b_seller/core/common/widget/role_screen_widgets.dart';
import 'package:flutter/material.dart';

class MyRequestsScreen extends StatelessWidget {
  const MyRequestsScreen({super.key});

  static const path = '/my-requests';
  static const name = 'my-requests';

  @override
  Widget build(BuildContext context) => const FeaturePlaceholder(
    title: 'Мои заявки',
    icon: Icons.assignment_outlined,
  );
}
