import 'dart:async';

import 'package:b2b_seller/core/common/widget/glass_nav_bar.dart';
import 'package:b2b_seller/core/services/enums.dart';
import 'package:b2b_seller/src/auth/presentation/bloc/me/me_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

abstract final class ShellBranchIndex {
  static const home = 0;
  static const buyerProducts = 1;
  static const supplierRequests = 2;
  static const chat = 3;
  static const buyerProfile = 4;
  static const supplierProfile = 5;
  static const adminProfile = 6;
}

class ScaffoldWithNavigationShell extends StatefulWidget {
  const ScaffoldWithNavigationShell({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  @override
  State<ScaffoldWithNavigationShell> createState() =>
      _ScaffoldWithNavigationShellState();
}

class _ScaffoldWithNavigationShellState
    extends State<ScaffoldWithNavigationShell> {
  final ValueNotifier<bool> _isScrollingDown = ValueNotifier(false);
  bool _branchResetScheduled = false;

  @override
  void initState() {
    super.initState();
    final meCubit = context.read<MeCubit>();
    if (meCubit.state.user == null && !meCubit.state.isLoading) {
      unawaited(meCubit.get());
    }
  }

  @override
  void dispose() {
    _isScrollingDown.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MeCubit, MeCubitState>(
      builder: (context, state) {
        final role = state.user?.role;
        if (role == null) {
          // Success without a role must not look like "still loading".
          return _UserStateView(
            state: state,
            isMissingRole: state.isCompleted && state.user != null,
          );
        }

        final items = _itemsFor(role);
        final selectedIndex = items.indexWhere(
          (item) => item.branchIndex == widget.navigationShell.currentIndex,
        );

        if (selectedIndex == -1 && !_branchResetScheduled) {
          _branchResetScheduled = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _branchResetScheduled = false;
            if (mounted) {
              widget.navigationShell.goBranch(ShellBranchIndex.home);
            }
          });
        }

        final colors = Theme.of(context).colorScheme;
        final selected = selectedIndex < 0 ? 0 : selectedIndex;
        const topRadius = BorderRadius.vertical(top: Radius.circular(24));

        return Scaffold(
          extendBody: true,
          body: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is ScrollUpdateNotification &&
                  notification.metrics.axis == Axis.vertical) {
                final scrollingDown =
                    (notification.scrollDelta ?? 0) > 0 &&
                    notification.metrics.pixels > 0;
                if (_isScrollingDown.value != scrollingDown) {
                  _isScrollingDown.value = scrollingDown;
                }
              }
              return false;
            },
            child: widget.navigationShell,
          ),
          // bottomNavigationBar: GlassNavBar(
          //   selectedIndex: selectedIndex < 0 ? 0 : selectedIndex,
          //   destinations: items.map((item) => item.destination).toList(),
          //   isScrollingDown: _isScrollingDown,
          //   onDestinationSelected: (index) {
          //     final branchIndex = items[index].branchIndex;
          //     widget.navigationShell.goBranch(
          //       branchIndex,
          //       initialLocation:
          //           branchIndex == widget.navigationShell.currentIndex,
          //     );
          //   },
          // ),
          bottomNavigationBar: DecoratedBox(
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: topRadius,
              border: Border(
                top: BorderSide(
                  color: colors.outlineVariant.withValues(alpha: 0.45),
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: colors.shadow.withValues(alpha: 0.08),
                  blurRadius: 20,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: topRadius,
              child: NavigationBar(
                height: 70,
                elevation: 0,
                backgroundColor: colors.surface,
                indicatorColor: colors.primary.withValues(alpha: 0.14),
                selectedIndex: selected,
                labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                onDestinationSelected: (index) {
                  final branchIndex = items[index].branchIndex;
                  widget.navigationShell.goBranch(
                    branchIndex,
                    initialLocation:
                        branchIndex == widget.navigationShell.currentIndex,
                  );
                },
                destinations: items
                    .map(
                      (item) => NavigationDestination(
                        icon: Icon(
                          item.destination.icon,
                          color: colors.onSurfaceVariant,
                        ),
                        selectedIcon: Icon(
                          item.destination.activeIcon,
                          color: colors.primary,
                        ),
                        label: item.destination.label,
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}

List<_RoleNavItem> _itemsFor(Role role) {
  switch (role) {
    case Role.buyer:
      return const [
        _RoleNavItem(
          branchIndex: ShellBranchIndex.home,
          destination: NavDestinationData(
            icon: Icons.home_outlined,
            activeIcon: Icons.home_rounded,
            label: 'Главная',
          ),
        ),
        _RoleNavItem(
          branchIndex: ShellBranchIndex.buyerProducts,
          destination: NavDestinationData(
            icon: Icons.shopping_bag_outlined,
            activeIcon: Icons.shopping_bag,
            label: 'Товары и услуги',
          ),
        ),
        _RoleNavItem(
          branchIndex: ShellBranchIndex.chat,
          destination: NavDestinationData(
            icon: Icons.chat_bubble_outline,
            activeIcon: Icons.chat_bubble,
            label: 'Чат',
          ),
        ),
        _RoleNavItem(
          branchIndex: ShellBranchIndex.buyerProfile,
          destination: NavDestinationData(
            icon: Icons.person_outline,
            activeIcon: Icons.person,
            label: 'Профиль',
          ),
        ),
      ];
    case Role.supplier:
      return const [
        _RoleNavItem(
          branchIndex: ShellBranchIndex.home,
          destination: NavDestinationData(
            icon: Icons.home_outlined,
            activeIcon: Icons.home_rounded,
            label: 'Главная',
          ),
        ),
        _RoleNavItem(
          branchIndex: ShellBranchIndex.supplierRequests,
          destination: NavDestinationData(
            icon: Icons.assignment_outlined,
            activeIcon: Icons.assignment,
            label: 'Заявки',
          ),
        ),
        _RoleNavItem(
          branchIndex: ShellBranchIndex.chat,
          destination: NavDestinationData(
            icon: Icons.chat_bubble_outline,
            activeIcon: Icons.chat_bubble,
            label: 'Чат',
          ),
        ),
        _RoleNavItem(
          branchIndex: ShellBranchIndex.supplierProfile,
          destination: NavDestinationData(
            icon: Icons.person_outline,
            activeIcon: Icons.person,
            label: 'Профиль',
          ),
        ),
      ];
    case Role.admin:
      return const [
        _RoleNavItem(
          branchIndex: ShellBranchIndex.home,
          destination: NavDestinationData(
            icon: Icons.home_outlined,
            activeIcon: Icons.home_rounded,
            label: 'Главная',
          ),
        ),
        _RoleNavItem(
          branchIndex: ShellBranchIndex.adminProfile,
          destination: NavDestinationData(
            icon: Icons.person_outline,
            activeIcon: Icons.person,
            label: 'Профиль',
          ),
        ),
      ];
  }
}

class _RoleNavItem {
  const _RoleNavItem({
    required this.branchIndex,
    required this.destination,
  });

  final int branchIndex;
  final NavDestinationData destination;
}

class _UserStateView extends StatelessWidget {
  const _UserStateView({
    required this.state,
    this.isMissingRole = false,
  });

  final MeCubitState state;
  final bool isMissingRole;

  @override
  Widget build(BuildContext context) {
    final showError = state.isFailed || isMissingRole;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: showError
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline_rounded, size: 48),
                      const SizedBox(height: 16),
                      Text(
                        isMissingRole
                            ? 'Роль пользователя не определена'
                            : state.errorMessage ??
                                  'Не удалось загрузить данные пользователя',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      FilledButton(
                        onPressed: () =>
                            unawaited(context.read<MeCubit>().get()),
                        child: const Text('Повторить'),
                      ),
                    ],
                  )
                : const CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
