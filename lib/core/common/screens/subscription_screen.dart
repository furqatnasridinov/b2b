import 'package:b2b_seller/core/common/widget/role_screen_widgets.dart';
import 'package:flutter/material.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  static const path = '/subscription';
  static const name = 'subscription';

  @override
  Widget build(BuildContext context) => const FeaturePlaceholder(
    title: 'Подписка',
    icon: Icons.workspace_premium_outlined,
  );
}
