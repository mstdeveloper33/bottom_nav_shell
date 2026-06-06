import 'package:flutter/material.dart';

import '../appearance/bottom_label_behavior.dart';
import '../widgets/branch_badge_widget.dart';
import 'bottom_bar_renderer.dart';

/// Google-style pill navigation bar renderer.
///
/// Selected item expands into a pill shape with icon + label,
/// similar to the popular google_nav_bar package.
class GNavBottomBarRenderer extends BottomBarRenderer {
  /// Creates a GNav renderer.
  const GNavBottomBarRenderer({
    this.height = 64,
    this.gap = 8,
    this.tabBorderRadius = 100,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    this.tabMargin = const EdgeInsets.symmetric(horizontal: 4),
    this.tabPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
  });

  /// Bar height.
  final double height;

  /// Gap between icon and label inside the selected pill.
  final double gap;

  /// Border radius of the pill shape.
  final double tabBorderRadius;

  /// Padding inside the bar.
  final EdgeInsets padding;

  /// Margin around each tab.
  final EdgeInsets tabMargin;

  /// Padding inside each tab pill.
  final EdgeInsets tabPadding;

  @override
  Widget build(BuildContext context, BottomBarState state) {
    final colorScheme = Theme.of(context).colorScheme;
    final background = state.theme.backgroundColor ?? colorScheme.surface;
    final borderColor = state.theme.borderColor ?? colorScheme.outlineVariant;
    final highContrast = MediaQuery.maybeOf(context)?.highContrast ?? false;

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
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          for (var i = 0; i < state.destinations.length; i++)
            _GNavItem(
              index: i,
              state: state,
              gap: gap,
              tabBorderRadius: tabBorderRadius,
              tabMargin: tabMargin,
              tabPadding: tabPadding,
            ),
        ],
      ),
    );
  }
}

class _GNavItem extends StatelessWidget {
  const _GNavItem({
    required this.index,
    required this.state,
    required this.gap,
    required this.tabBorderRadius,
    required this.tabMargin,
    required this.tabPadding,
  });

  final int index;
  final BottomBarState state;
  final double gap;
  final double tabBorderRadius;
  final EdgeInsets tabMargin;
  final EdgeInsets tabPadding;

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
        destination.unselectedColor ??
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
                Theme.of(context).textTheme.labelMedium ??
                const TextStyle())
            .copyWith(
              color: effectiveColor,
              fontWeight: FontWeight.w600,
            );

    final showLabel = _isSelected &&
        state.labelBehavior != BottomLabelBehavior.alwaysHide;

    return Semantics(
      label: destination.effectiveTooltip,
      button: true,
      enabled: isEnabled,
      selected: _isSelected,
      child: GestureDetector(
        onTap: isEnabled ? () => state.onSelect(index) : null,
        onLongPress: isEnabled && state.onLongPress != null
            ? () => state.onLongPress!(index)
            : null,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: duration,
          curve: state.animationStyle.curve,
          margin: tabMargin,
          padding: tabPadding,
          decoration: BoxDecoration(
            color: _isSelected
                ? selectedColor.withValues(alpha: 0.12)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(tabBorderRadius),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              iconWidget,
              if (showLabel) ...[
                SizedBox(width: gap),
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
