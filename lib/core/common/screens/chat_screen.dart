import 'package:b2b_seller/core/common/widget/role_screen_widgets.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  static const path = '/chat';
  static const name = 'chat';

  @override
  Widget build(BuildContext context) {
    return const SectionScreenLayout(
      title: 'Чат',
      child: EmptyState(
        icon: Icons.forum_outlined,
        title: 'Сообщений пока нет',
        description: 'Здесь появятся диалоги с заказчиками и исполнителями.',
      ),
    );
  }
}
