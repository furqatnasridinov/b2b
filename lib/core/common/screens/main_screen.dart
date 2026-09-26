import 'package:b2b_seller/core/common/screens/my_requests_screen.dart';
import 'package:b2b_seller/core/common/screens/supplier_requests_screen.dart';
import 'package:b2b_seller/core/common/widget/primary_button.dart';
import 'package:b2b_seller/core/services/enums.dart';
import 'package:b2b_seller/core/utils/themes/app_colors.dart';
import 'package:b2b_seller/src/auth/presentation/bloc/me/me_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  static const path = '/main';
  static const name = 'main';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MeCubit, MeCubitState>(
      builder: (context, state) {
        final user = state.user;
        final nameParts = [user?.firstName, user?.lastName];
        final fullName = nameParts
            .whereType<String>()
            .map((part) => part.trim())
            .where((part) => part.isNotEmpty)
            .join(' ');
        final greeting = fullName.isEmpty
            ? 'Здравствуйте!'
            : 'Здравствуйте, $fullName!';

        return _Dashboard(
          greeting: greeting,
          role: user?.role,
        );
      },
    );
  }
}

class _Dashboard extends StatelessWidget {
  const _Dashboard({
    required this.greeting,
    required this.role,
  });

  final String greeting;
  final Role? role;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final config = _configFor(role);

    return ColoredBox(
      color: isDark ? colors.surface : const Color(0xFFF5F6F8),
      child: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 110),
          children: [
            Text(
              greeting,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: -0.4,
                height: 1.2,
                color: colors.onSurface,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              config.subtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
                height: 1.35,
              ),
            ),
            if (config.actionTitle != null) ...[
              const SizedBox(height: 16),
              PrimaryButton(
                title: config.actionTitle!,
                height: 48,
                onPressed: () => config.onAction(context),
              ),
            ],
            if (config.cards.isNotEmpty) ...[
              const SizedBox(height: 18),
              _StatsGrid(cards: config.cards),
            ],
          ],
        ),
      ),
    );
  }

  _DashboardConfig _configFor(Role? role) {
    return switch (role) {
      Role.supplier => _DashboardConfig(
        subtitle: 'Ваши договоры, заявки заказчиков и финансы',
        actionTitle: 'Добавить позицию',
        actionIcon: Icons.arrow_forward_rounded,
        iconAtEnd: true,
        onAction: (context) => context.go(SupplierRequestsScreen.path),
        cards: const [
          _StatCardData(
            icon: Icons.description_outlined,
            color: Color(0xFF22C55E),
            value: '0',
            label: 'Активные договоры',
          ),
          _StatCardData(
            icon: Icons.mail_outline_rounded,
            color: Color(0xFF3B82F6),
            value: '0',
            label: 'Новые заявки',
          ),
          _StatCardData(
            icon: Icons.chat_bubble_outline_rounded,
            color: Color(0xFFF59E0B),
            value: '0',
            label: 'непрочитанных\nВходящие сообщения',
          ),
          _StatCardData(
            icon: Icons.trending_up_rounded,
            color: Color(0xFF8B5CF6),
            value: '0 TJS',
            label: 'Выручка',
          ),
          _StatCardData(
            icon: Icons.account_balance_wallet_outlined,
            color: Color(0xFF94A3B8),
            value: '0 TJS',
            label: 'Ожидают выплаты',
          ),
          _StatCardData(
            icon: Icons.star_outline_rounded,
            color: Color(0xFFF5B942),
            value: '0.0',
            label: '0 отзывов\nРейтинг',
          ),
        ],
      ),
      Role.admin => const _DashboardConfig(
        subtitle: 'Управление системой и пользователями',
      ),
      Role.buyer || null => _DashboardConfig(
        subtitle: 'Ваши заявки, предложения и договоры',
        actionTitle: 'Создать заявку',
        actionIcon: Icons.add_rounded,
        onAction: (context) => context.push(MyRequestsScreen.path),
        cards: const [
          _StatCardData(
            icon: Icons.description_outlined,
            color: Color(0xFF3B82F6),
            value: '0',
            label: 'Активные заявки',
          ),
          _StatCardData(
            icon: Icons.mail_outline_rounded,
            color: Color(0xFF22C55E),
            value: '0',
            label: 'Входящие предложения',
          ),
          _StatCardData(
            icon: Icons.description_outlined,
            color: Color(0xFF94A3B8),
            value: '0',
            label: 'Активные договоры',
          ),
          _StatCardData(
            icon: Icons.account_balance_wallet_outlined,
            color: Color(0xFF94A3B8),
            value: '0 TJS',
            label: 'Ожидают оплаты',
          ),
          _StatCardData(
            icon: Icons.warning_amber_rounded,
            color: Color(0xFFEF4444),
            value: '0',
            label: 'Споры',
          ),
          _StatCardData(
            icon: Icons.chat_bubble_outline_rounded,
            color: Color(0xFFF59E0B),
            value: '0',
            label: 'непрочитанных\nСообщения',
          ),
        ],
      ),
    };
  }
}

class _DashboardConfig {
  const _DashboardConfig({
    required this.subtitle,
    this.actionTitle,
    this.actionIcon,
    this.iconAtEnd = false,
    this.onAction = _noop,
    this.cards = const [],
  });

  final String subtitle;
  final String? actionTitle;
  final IconData? actionIcon;
  final bool iconAtEnd;
  final void Function(BuildContext context) onAction;
  final List<_StatCardData> cards;

  static void _noop(BuildContext context) {}
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.title,
    required this.icon,
    required this.onPressed,
    this.iconAtEnd = false,
  });

  final String title;
  final IconData icon;
  final VoidCallback onPressed;
  final bool iconAtEnd;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!iconAtEnd) ...[
              Icon(icon, size: 20),
              const SizedBox(width: 8),
            ],
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (iconAtEnd) ...[
              const SizedBox(width: 8),
              Icon(icon, size: 18),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.cards});

  final List<_StatCardData> cards;

  @override
  Widget build(BuildContext context) {
    final columns = MediaQuery.sizeOf(context).width > 700 ? 3 : 2;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cards.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        mainAxisExtent: 148,
      ),
      itemBuilder: (context, index) => _StatCard(data: cards[index]),
    );
  }
}

class _StatCardData {
  const _StatCardData({
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final Color color;
  final String value;
  final String label;
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.data});

  final _StatCardData data;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: colors.outlineVariant.withValues(alpha: 0.45),
        ),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: data.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(data.icon, color: data.color, size: 20),
            ),
            const Spacer(),
            Text(
              data.value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              data.label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colors.onSurfaceVariant,
                height: 1.25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
