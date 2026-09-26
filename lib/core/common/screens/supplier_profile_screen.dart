import 'package:b2b_seller/core/common/screens/finance_screen.dart';
import 'package:b2b_seller/core/common/screens/my_catalog_screen.dart';
import 'package:b2b_seller/core/common/screens/subscription_screen.dart';
import 'package:b2b_seller/core/common/widget/role_screen_widgets.dart';
import 'package:b2b_seller/src/auth/presentation/widget/logout_button.dart';
import 'package:flutter/material.dart';

class SupplierProfileScreen extends StatelessWidget {
  const SupplierProfileScreen({super.key});

  static const path = '/supplier-profile';
  static const name = 'supplier-profile';

  @override
  Widget build(BuildContext context) {
    return const SectionMenu(
      title: 'Профиль',
      showProfileHeader: true,
      items: [
        SectionMenuItem(
          icon: Icons.inventory_2_outlined,
          title: 'Мой каталог',
          path: MyCatalogScreen.path,
        ),
        SectionMenuItem(
          icon: Icons.payments_outlined,
          title: 'Финансы',
          path: FinanceScreen.path,
        ),
        SectionMenuItem(
          icon: Icons.workspace_premium_outlined,
          title: 'Подписка',
          path: SubscriptionScreen.path,
        ),
      ],
      footer: LogOutButton(),
    );
  }
}
