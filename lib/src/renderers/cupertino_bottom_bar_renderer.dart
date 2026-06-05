import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../appearance/bottom_label_behavior.dart';
import '../widgets/branch_badge_widget.dart';
import 'bottom_bar_renderer.dart';

/// iOS-style bottom tab bar renderer.
class CupertinoBottomBarRenderer extends BottomBarRenderer {
  /// Creates a Cupertino bottom bar renderer.
  const CupertinoBottomBarRenderer();

  @override
  Widget build(BuildContext context, BottomBarState state) {
    final colorScheme = Theme.of(context).colorScheme;
    final activeColor = state.theme.selectedItemColor ?? colorScheme.primary;
    final inactiveColor =
        state.theme.unselectedItemColor ?? colorScheme.onSurfaceVariant;
    final background = state.theme.backgroundColor ?? colorScheme.surface;

    return CupertinoTabBar(
      currentIndex: state.selectedIndex,
      activeColor: activeColor,
      inactiveColor: inactiveColor,
      backgroundColor: background,
      onTap: (index) {
        if (state.canSelect(index)) {
          state.onSelect(index);
        }
      },
      items: [
        for (var index = 0; index < state.destinations.length; index++)
          BottomNavigationBarItem(
            icon: Opacity(
              opacity: state.canSelect(index) ? 1 : 0.38,
              child: _CupertinoIcon(
                index: index,
                state: state,
                selected: false,
              ),
            ),
            activeIcon: _CupertinoIcon(
              index: index,
              state: state,
              selected: true,
            ),
            label: state.labelBehavior == BottomLabelBehavior.alwaysHide
                ? ''
                : state.destinations[index].label,
          ),
      ],
    );
  }
}

class _CupertinoIcon extends StatelessWidget {
  const _CupertinoIcon({
    required this.index,
    required this.state,
    required this.selected,
  });

  final int index;
  final BottomBarState state;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final destination = state.destinations[index];
    if (state.isPending(index)) {
      return SizedBox(
        width: state.theme.iconSize,
        height: state.theme.iconSize,
        child: const CupertinoActivityIndicator(),
      );
    }
    final icon = Icon(
      selected ? destination.effectiveSelectedIcon : destination.icon,
      size: state.theme.iconSize,
    );

    if (destination.badge == null) {
      return icon;
    }
    return BranchBadgeWidget(
      badge: destination.badge!,
      theme: state.theme,
      child: icon,
    );
  }
}
