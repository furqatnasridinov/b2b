import 'package:b2b_seller/core/common/screens/contracts_screen.dart';
import 'package:b2b_seller/core/common/screens/customers_screen.dart';
import 'package:b2b_seller/core/common/screens/my_offers_screen.dart';
import 'package:b2b_seller/core/common/widget/role_screen_widgets.dart';
import 'package:flutter/material.dart';

class SupplierRequestsScreen extends StatelessWidget {
  const SupplierRequestsScreen({super.key});

  static const path = '/supplier-requests';
  static const name = 'supplier-requests';

  @override
  Widget build(BuildContext context) {
    return const SectionMenu(
      title: 'Заявки заказчиков',
      subtitle: 'Работайте с заявками и предложениями',
      items: [
        SectionMenuItem(
          icon: Icons.business_center_outlined,
          title: 'Заказчики',
          path: CustomersScreen.path,
        ),
        SectionMenuItem(
          icon: Icons.local_offer_outlined,
          title: 'Мои предложения',
          path: MyOffersScreen.path,
        ),
        SectionMenuItem(
          icon: Icons.description_outlined,
          title: 'Договоры',
          path: ContractsScreen.path,
        ),
      ],
    );
  }
}
