import 'package:flutter/material.dart';

import '../appearance/bottom_label_behavior.dart';
import '../widgets/branch_badge_widget.dart';
import 'bottom_bar_renderer.dart';

/// Sliding/Clipped bottom bar renderer.
///
/// A highlight indicator slides horizontally behind the selected item.
/// Gives a smooth, animated sliding-selection effect.
class SlidingBottomBarRenderer extends BottomBarRenderer {
  /// Creates a sliding bottom bar renderer.
  const SlidingBottomBarRenderer({
    this.height = 64,
    this.indicatorHeight = 44,
    this.indicatorBorderRadius = 14,
    this.indicatorMargin = const EdgeInsets.symmetric(horizontal: 6),
  });

  /// Bar height.
  final double height;

  /// Height of the sliding indicator.
  final double indicatorHeight;

  /// Border radius of the indicator.
  final double indicatorBorderRadius;

  /// Margin around the indicator.
  final EdgeInsets indicatorMargin;

  @override
  Widget build(BuildContext context, BottomBarState state) {
    final colorScheme = Theme.of(context).colorScheme;
    final background = state.theme.backgroundColor ?? colorScheme.surface;
    final borderColor = state.theme.borderColor ?? colorScheme.outlineVariant;
    final selectedColor =
        state.theme.selectedItemColor ?? colorScheme.primary;
    final highContrast = MediaQuery.maybeOf(context)?.highContrast ?? false;
    final disableAnimations =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final duration =
        disableAnimations ? Duration.zero : state.animationStyle.duration;

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: background,
        border: Border(
          top: BorderSide(
            color: highContrast
                ? colorScheme.onSurface
                : borderColor.withValues(alpha: 0.5),
            width: highContrast ? 1 : 0.5,
          ),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final itemWidth =
              constraints.maxWidth / state.destinations.length;
          final indicatorLeft =
              itemWidth * state.selectedIndex + indicatorMargin.left;
          final indicatorWidth =
              itemWidth - indicatorMargin.horizontal;

          return Stack(
            alignment: Alignment.center,
            children: [
              // Sliding indicator
              AnimatedPositioned(
                duration: duration,
                curve: state.animationStyle.curve,
                left: indicatorLeft,
                width: indicatorWidth,
                height: indicatorHeight,
                child: Container(
                  decoration: BoxDecoration(
                    color: selectedColor.withValues(alpha: 0.12),
                    borderRadius:
                        BorderRadius.circular(indicatorBorderRadius),
                  ),
                ),
              ),
              // Items
              Row(
                children: [
                  for (var i = 0; i < state.destinations.length; i++)
                    Expanded(
                      child: _SlidingItem(
                        index: i,
                        state: state,
                      ),
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SlidingItem extends StatelessWidget {
  const _SlidingItem({
    required this.index,
    required this.state,
  });

  final int index;
  final BottomBarState state;

  bool get _isSelected => index == state.selectedIndex;

  @override
  Widget build(BuildContext context) {
    final disableAnimations =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final duration =
        disableAnimations ? Duration.zero : state.animationStyle.duration;
    final colorScheme = Theme.of(context).colorScheme;
    final destination = state.destinations[index];
    final selectedColor = destination.selectedColor ??
        state.theme.selectedItemColor ??
        colorScheme.primary;
    final unselectedColor =
        state.theme.unselectedItemColor ?? colorScheme.onSurfaceVariant;
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

    final labelStyle =
        (state.theme.labelTextStyle ??
                Theme.of(context).textTheme.labelSmall ??
                const TextStyle())
            .copyWith(
              color: effectiveColor,
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
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              iconWidget,
              if (showLabel) ...[
                const SizedBox(height: 3),
                AnimatedDefaultTextStyle(
                  duration: duration,
                  style: labelStyle,
                  child: Text(
                    destination.label,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
