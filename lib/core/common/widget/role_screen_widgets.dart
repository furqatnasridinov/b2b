import 'package:b2b_seller/core/extensions/context_extension.dart';
import 'package:b2b_seller/core/services/enums.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SectionScreenLayout extends StatelessWidget {
  const SectionScreenLayout({
    required this.title,
    required this.child,
    super.key,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
            child: Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
              ),
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class SectionMenu extends StatelessWidget {
  const SectionMenu({
    required this.title,
    required this.items,
    this.subtitle,
    this.showProfileHeader = false,
    this.footer,
    super.key,
  });

  final String title;
  final String? subtitle;
  final List<SectionMenuItem> items;
  final bool showProfileHeader;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return SectionScreenLayout(
      title: title,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 100),
        children: [
          if (showProfileHeader) ...[
            const ProfileHeader(),
            const SizedBox(height: 22),
          ],
          if (subtitle != null) ...[
            Text(
              subtitle!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 16),
          ],
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _MenuTile(item: item),
            ),
          ),
          if (footer != null) ...[
            const SizedBox(height: 6),
            footer!,
          ],
        ],
      ),
    );
  }
}

class SectionMenuItem {
  const SectionMenuItem({
    required this.icon,
    required this.title,
    required this.path,
  });

  final IconData icon;
  final String title;
  final String path;
}

class EmptyState extends StatelessWidget {
  const EmptyState({
    required this.icon,
    required this.title,
    required this.description,
    super.key,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 68,
              height: 68,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(icon, size: 30, color: colors.primary,),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              description,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FeaturePlaceholder extends StatelessWidget {
  const FeaturePlaceholder({
    required this.title,
    required this.icon,
    super.key,
  });

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: EmptyState(
        icon: icon,
        title: title,
        description: 'Экран готов для дальнейшего наполнения.',
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final user = context.me;
    final fullName = [
      user?.firstName,
      user?.lastName,
    ].whereType<String>().where((part) => part.trim().isNotEmpty).join(' ');

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colors.outlineVariant.withValues(alpha: 0.45),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: colors.primary.withValues(alpha: 0.12),
              child: Icon(
                Icons.person_rounded,
                color: colors.primary,
                size: 28,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fullName.isEmpty ? 'Мой профиль' : fullName,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.role?.nameTr ?? 'Настройки аккаунта',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({required this.item});

  final SectionMenuItem item;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => context.push(item.path),
      child: DecoratedBox(
        decoration: BoxDecoration(
          //color: colors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: colors.outlineVariant.withValues(alpha: 0.45),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(item.icon, color: colors.primary, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  item.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: colors.onSurfaceVariant.withValues(alpha: 0.7),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
