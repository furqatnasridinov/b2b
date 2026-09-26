import 'package:b2b_seller/core/common/widget/role_screen_widgets.dart';
import 'package:flutter/material.dart';

class AdminProfileScreen extends StatelessWidget {
  const AdminProfileScreen({super.key});

  static const path = '/admin-profile';
  static const name = 'admin-profile';

  @override
  Widget build(BuildContext context) {
    return const SectionScreenLayout(
      title: 'Профиль',
      child: EmptyState(
        icon: Icons.admin_panel_settings_outlined,
        title: 'Профиль администратора',
        description: 'Раздел находится в разработке.',
      ),
    );
  }
}
