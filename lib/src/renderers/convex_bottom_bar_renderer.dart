import 'package:flutter/material.dart';

import '../appearance/bottom_label_behavior.dart';
import '../widgets/branch_badge_widget.dart';
import 'bottom_bar_renderer.dart';

/// Convex/FAB center bottom bar renderer.
///
/// A clean bottom bar where the center item is elevated as a circular
/// FAB-style button. The bar has a smooth concave notch around the center
/// button, and the remaining items are evenly distributed on either side.
class ConvexBottomBarRenderer extends BottomBarRenderer {
  /// Creates a convex bottom bar renderer.
  ///
  /// [centerIndex] defaults to the middle item. If -1, uses
  /// `destinations.length ~/ 2`.
  const ConvexBottomBarRenderer({
    this.height = 56,
    this.centerIndex = -1,
    this.convexSize = 54,
    this.convexElevation = 20,
    this.convexBorderRadius = 27,
  });

  /// Bar height.
  final double height;

  /// Index of the center convex item. -1 means auto (middle).
  final int centerIndex;

  /// Size of the convex (FAB) button.
  final double convexSize;

  /// How far the convex button rises above the bar top edge.
  final double convexElevation;

  /// Corner radius of the convex button.
  final double convexBorderRadius;

  @override
  Widget build(BuildContext context, BottomBarState state) {
    final colorScheme = Theme.of(context).colorScheme;
    final background = state.theme.backgroundColor ?? colorScheme.surface;
    final selectedColor =
        state.theme.selectedItemColor ?? colorScheme.primary;
    final unselectedColor =
        state.theme.unselectedItemColor ?? colorScheme.onSurfaceVariant;
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;

    final effectiveCenterIndex =
        centerIndex < 0 ? state.destinations.length ~/ 2 : centerIndex;

    final totalHeight = height + convexElevation;

    return SizedBox(
      height: totalHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Bar background with shadow
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: height,
              decoration: BoxDecoration(
                color: background,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  for (var i = 0; i < state.destinations.length; i++)
                    Expanded(
                      child: i == effectiveCenterIndex
                          ? const SizedBox.shrink()
                          : _SideItem(
                              index: i,
                              state: state,
                              selectedColor: selectedColor,
                              unselectedColor: unselectedColor,
                            ),
                    ),
                ],
              ),
            ),
          ),
          // Center FAB button
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Center(
              child: _CenterFab(
                index: effectiveCenterIndex,
                state: state,
                size: convexSize,
                borderRadius: convexBorderRadius,
                selectedColor: selectedColor,
                scaffoldColor: scaffoldBg,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ───────────────────────────── Center FAB ─────────────────────────────

class _CenterFab extends StatelessWidget {
  const _CenterFab({
    required this.index,
    required this.state,
    required this.size,
    required this.borderRadius,
    required this.selectedColor,
    required this.scaffoldColor,
  });

  final int index;
  final BottomBarState state;
  final double size;
  final double borderRadius;
  final Color selectedColor;
  final Color scaffoldColor;

  bool get _isSelected => index == state.selectedIndex;

  @override
  Widget build(BuildContext context) {
    final disableAnimations =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final duration =
        disableAnimations ? Duration.zero : state.animationStyle.duration;
    final destination = state.destinations[index];
    final isEnabled = state.canSelect(index);
    final isPending = state.isPending(index);

    final fabColor = _isSelected
        ? selectedColor
        : selectedColor.withValues(alpha: 0.85);

    final icon = isPending
        ? const SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: Colors.white,
            ),
          )
        : Icon(
            _isSelected
                ? destination.effectiveSelectedIcon
                : destination.icon,
            size: state.theme.iconSize + 2,
            color: Colors.white,
          );

    final iconWidget = destination.badge == null
        ? icon
        : BranchBadgeWidget(
            badge: destination.badge!,
            theme: state.theme,
            child: icon,
          );

    return Semantics(
      label: destination.effectiveTooltip,
      button: true,
      enabled: isEnabled,
      selected: _isSelected,
      child: GestureDetector(
        onTap: isEnabled ? () => state.onSelect(index) : null,
        child: AnimatedScale(
          scale: _isSelected ? 1.0 : 0.92,
          duration: duration,
          curve: state.animationStyle.curve,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: fabColor,
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(color: scaffoldColor, width: 4),
              boxShadow: [
                BoxShadow(
                  color: selectedColor.withValues(alpha: 0.25),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(child: iconWidget),
          ),
        ),
      ),
    );
  }
}

// ───────────────────────────── Side Item ─────────────────────────────

class _SideItem extends StatelessWidget {
  const _SideItem({
    required this.index,
    required this.state,
    required this.selectedColor,
    required this.unselectedColor,
  });

  final int index;
  final BottomBarState state;
  final Color selectedColor;
  final Color unselectedColor;

  bool get _isSelected => index == state.selectedIndex;

  @override
  Widget build(BuildContext context) {
    final disableAnimations =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final duration =
        disableAnimations ? Duration.zero : state.animationStyle.duration;
    final destination = state.destinations[index];
    final isEnabled = state.canSelect(index);
    final isPending = state.isPending(index);

    final effectiveColor = !isEnabled
        ? unselectedColor.withValues(alpha: 0.38)
        : _isSelected
            ? selectedColor
            : unselectedColor;

    final icon = isPending
        ? SizedBox(
            width: state.theme.iconSize,
            height: state.theme.iconSize,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: effectiveColor,
            ),
          )
        : Icon(
            _isSelected
                ? destination.effectiveSelectedIcon
                : destination.icon,
            size: state.theme.iconSize,
            color: effectiveColor,
          );

    final iconWidget = destination.badge == null
        ? icon
        : BranchBadgeWidget(
            badge: destination.badge!,
            theme: state.theme,
            child: icon,
          );

    final labelStyle = TextStyle(
      color: effectiveColor,
      fontSize: 11,
      fontWeight: _isSelected ? FontWeight.w700 : FontWeight.w500,
    );

    final showLabel =
        state.labelBehavior != BottomLabelBehavior.alwaysHide &&
            (state.labelBehavior == BottomLabelBehavior.alwaysShow ||
                _isSelected);

    return Semantics(
      label: destination.effectiveTooltip,
      button: true,
      enabled: isEnabled,
      selected: _isSelected,
      child: GestureDetector(
        onTap: isEnabled ? () => state.onSelect(index) : null,
        behavior: HitTestBehavior.opaque,
        child: SizedBox.expand(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedScale(
                scale: _isSelected ? 1.1 : 1.0,
                duration: duration,
                curve: state.animationStyle.curve,
                child: iconWidget,
              ),
              if (showLabel) ...[
                const SizedBox(height: 2),
                Text(
                  destination.label,
                  style: labelStyle,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
