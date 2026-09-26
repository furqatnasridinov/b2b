import 'dart:ui';

import 'package:flutter/material.dart';

class GlassNavBar extends StatefulWidget {
  const GlassNavBar({
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.destinations,
    this.isScrollingDown,
    super.key,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<NavDestinationData> destinations;
  final ValueNotifier<bool>? isScrollingDown;

  @override
  State<GlassNavBar> createState() => _GlassNavBarState();
}

class _GlassNavBarState extends State<GlassNavBar> {
  double? _dragOffset;
  double? _pillStartDx;
  double? _dragStartGlobalX;
  bool _isDragging = false;
  int _hoveredIndex = -1;

  @override
  void initState() {
    super.initState();
    widget.isScrollingDown?.addListener(_onScrollDirectionChanged);
  }

  @override
  void didUpdateWidget(GlassNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isScrollingDown != widget.isScrollingDown) {
      oldWidget.isScrollingDown?.removeListener(_onScrollDirectionChanged);
      widget.isScrollingDown?.addListener(_onScrollDirectionChanged);
    }
  }

  @override
  void dispose() {
    widget.isScrollingDown?.removeListener(_onScrollDirectionChanged);
    super.dispose();
  }

  void _onScrollDirectionChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isScrollingDown = widget.isScrollingDown?.value ?? false;
    final horizontalPadding = widget.destinations.length > 3 ? 16.0 : 40.0;

    final bar = SizedBox(
      height: 60,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: colors.primary.withValues(alpha: 0.75),
              ),
              boxShadow: [
                BoxShadow(
                  color: colors.shadow.withValues(alpha: 0.12),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final itemCount = widget.destinations.length;
                  final segmentWidth = constraints.maxWidth / itemCount;
                  final pillWidth = segmentWidth - 6;
                  final pillLeft =
                      (_dragOffset ?? (widget.selectedIndex * segmentWidth)) +
                      3;

                  return GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTapUp: (details) {
                      final index = (details.localPosition.dx / segmentWidth)
                          .floor()
                          .clamp(0, itemCount - 1);
                      widget.onDestinationSelected(index);
                    },
                    child: Stack(
                      children: [
                        AnimatedPositioned(
                          duration: _dragOffset == null
                              ? const Duration(milliseconds: 300)
                              : Duration.zero,
                          curve: Curves.easeInOutCirc,
                          left: pillLeft - 5,
                          top: 5,
                          bottom: 5,
                          width: pillWidth + 10,
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onHorizontalDragStart: (details) {
                              _dragStartGlobalX = details.globalPosition.dx;
                              _pillStartDx =
                                  widget.selectedIndex * segmentWidth;
                              setState(() {
                                _isDragging = true;
                                _dragOffset = _pillStartDx;
                              });
                            },
                            onHorizontalDragUpdate: (details) {
                              if (_dragStartGlobalX == null) return;
                              final moved =
                                  details.globalPosition.dx -
                                  _dragStartGlobalX!;
                              final raw = (_pillStartDx ?? 0) + moved;
                              final maxOffset = (itemCount - 1) * segmentWidth;
                              setState(() {
                                _dragOffset = raw.clamp(0, maxOffset);
                                _hoveredIndex = (_dragOffset! / segmentWidth)
                                    .round()
                                    .clamp(0, itemCount - 1);
                              });
                            },
                            onHorizontalDragEnd: (_) {
                              final index = ((_dragOffset ?? 0) / segmentWidth)
                                  .round()
                                  .clamp(0, itemCount - 1);
                              setState(() {
                                _dragOffset = null;
                                _hoveredIndex = -1;
                                _isDragging = false;
                              });
                              widget.onDestinationSelected(index);
                              _pillStartDx = null;
                              _dragStartGlobalX = null;
                            },
                            child: AnimatedScale(
                              scale: _isDragging ? 1.16 : 1,
                              duration: const Duration(milliseconds: 250),
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: colors.primary.withValues(alpha: 0.5),
                                  borderRadius: BorderRadius.circular(32),
                                ),
                              ),
                            ),
                          ),
                        ),
                        IgnorePointer(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: List.generate(
                              itemCount,
                              (index) => Expanded(
                                child: _NavItem(
                                  destination: widget.destinations[index],
                                  isSelected: widget.selectedIndex == index,
                                  isActive: _dragOffset == null
                                      ? widget.selectedIndex == index
                                      : _hoveredIndex == index,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );

    return Container(
      height: 88,
      alignment: Alignment.topCenter,
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            colors.surface.withValues(alpha: 0),
            colors.surface.withValues(alpha: 0.5),
            colors.surface.withValues(alpha: 0.9),
          ],
          stops: const [0, 0.55, 1],
        ),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: AnimatedScale(
          duration: const Duration(milliseconds: 230),
          curve: Curves.easeInOut,
          scale: (isScrollingDown ? 0.86 : 1) + (_isDragging ? 0.03 : 0),
          child: bar,
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.destination,
    required this.isSelected,
    required this.isActive,
  });

  final NavDestinationData destination;
  final bool isSelected;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final color = isSelected ? colors.onSurface : colors.onSurface;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: isActive ? 1 : 0.58,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? destination.activeIcon : destination.icon,
              color: color,
              size: 19,
            ),
            const SizedBox(height: 2),
            Text(
              destination.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: color,
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NavDestinationData {
  const NavDestinationData({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
}
