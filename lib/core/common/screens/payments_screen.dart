import 'package:b2b_seller/core/common/widget/role_screen_widgets.dart';
import 'package:flutter/material.dart';

class PaymentsScreen extends StatelessWidget {
  const PaymentsScreen({super.key});

  static const path = '/payments';
  static const name = 'payments';

  @override
  Widget build(BuildContext context) => const FeaturePlaceholder(
    title: 'Платежи',
    icon: Icons.account_balance_wallet_outlined,
  );
}
