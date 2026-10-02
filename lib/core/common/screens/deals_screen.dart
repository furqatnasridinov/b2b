import 'package:b2b_seller/core/common/widget/role_screen_widgets.dart';
import 'package:flutter/material.dart';

class DealsScreen extends StatelessWidget {
  const DealsScreen({super.key});

  static const path = '/deals';
  static const name = 'deals';

  @override
  Widget build(BuildContext context) {
    return const SectionScreenLayout(
      title: 'Сделки',
      child: EmptyState(
        icon: Icons.handshake_outlined,
        title: 'Сделок пока нет',
        description: 'Здесь появятся ваши сделки с исполнителями.',
      ),
    );
  }
}
