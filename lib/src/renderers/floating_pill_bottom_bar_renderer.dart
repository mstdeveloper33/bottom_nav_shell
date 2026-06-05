import 'package:flutter/material.dart';

import '../widgets/bottom_bar_item.dart';
import 'bottom_bar_renderer.dart';

/// Floating pill bottom bar renderer.
class FloatingPillBottomBarRenderer extends BottomBarRenderer {
  /// Creates a floating pill renderer.
  const FloatingPillBottomBarRenderer({
    this.height = 72,
    this.borderRadius = 32,
    this.margin = const EdgeInsets.fromLTRB(20, 0, 20, 12),
    this.selectedFlex = 2,
    this.unselectedFlex = 1,
  }) : assert(selectedFlex > 0, 'selectedFlex must be positive.'),
       assert(unselectedFlex > 0, 'unselectedFlex must be positive.');

  /// Pill height.
  final double height;

  /// Pill corner radius.
  final double borderRadius;

  /// Outer margin around the pill.
  final EdgeInsets margin;

  /// Flex used by the selected destination.
  final int selectedFlex;

  /// Flex used by unselected destinations.
  final int unselectedFlex;

  @override
  Widget build(BuildContext context, BottomBarState state) {
    final colorScheme = Theme.of(context).colorScheme;
    final highContrast = MediaQuery.maybeOf(context)?.highContrast ?? false;
    final background = state.theme.backgroundColor ?? colorScheme.surface;
    final borderColor = state.theme.borderColor ?? colorScheme.outlineVariant;
    final shadowColor =
        state.theme.shadowColor ?? Colors.black.withValues(alpha: 0.14);

    return Padding(
      padding: state.theme.margin == EdgeInsets.zero
          ? margin
          : state.theme.margin,
      child: Material(
        color: Colors.transparent,
        child: Container(
          height: height,
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: highContrast ? colorScheme.onSurface : borderColor,
              width: highContrast ? 1.2 : 0.6,
            ),
            boxShadow: [
              BoxShadow(
                color: shadowColor,
                blurRadius: 22,
                spreadRadius: -8,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Row(
            children: [
              for (var index = 0; index < state.destinations.length; index++)
                Expanded(
                  flex: index == state.selectedIndex
                      ? selectedFlex
                      : unselectedFlex,
                  child: _FloatingItemShell(
                    isSelected: index == state.selectedIndex,
                    state: state,
                    child: BottomBarItem(
                      destination: state.destinations[index],
                      index: index,
                      state: state,
                      expandedSelected: true,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FloatingItemShell extends StatelessWidget {
  const _FloatingItemShell({
    required this.isSelected,
    required this.state,
    required this.child,
  });

  final bool isSelected;
  final BottomBarState state;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final disableAnimations =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final duration = disableAnimations
        ? Duration.zero
        : state.animationStyle.duration;
    final colorScheme = Theme.of(context).colorScheme;
    final indicator =
        state.theme.indicatorColor ?? colorScheme.primaryContainer;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
      child: AnimatedContainer(
        duration: duration,
        curve: state.animationStyle.curve,
        decoration: BoxDecoration(
          color: isSelected ? indicator : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
        ),
        child: child,
      ),
    );
  }
}
