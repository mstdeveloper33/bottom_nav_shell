import 'package:flutter/material.dart';

import '../appearance/bottom_label_behavior.dart';
import '../widgets/branch_badge_widget.dart';
import 'bottom_bar_renderer.dart';

/// Bubble/Expanding bottom bar renderer.
///
/// The selected item expands into a bubble shape with a background
/// pill that contains icon and label.
class BubbleBottomBarRenderer extends BottomBarRenderer {
  /// Creates a bubble renderer.
  const BubbleBottomBarRenderer({
    this.height = 64,
    this.bubbleBorderRadius = 20,
    this.bubblePadding =
        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
  });

  /// Bar height.
  final double height;

  /// Border radius of the bubble pill.
  final double bubbleBorderRadius;

  /// Padding inside the bubble pill.
  final EdgeInsets bubblePadding;

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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          for (var i = 0; i < state.destinations.length; i++)
            _BubbleItem(
              index: i,
              state: state,
              bubbleBorderRadius: bubbleBorderRadius,
              bubblePadding: bubblePadding,
            ),
        ],
      ),
    );
  }
}

class _BubbleItem extends StatelessWidget {
  const _BubbleItem({
    required this.index,
    required this.state,
    required this.bubbleBorderRadius,
    required this.bubblePadding,
  });

  final int index;
  final BottomBarState state;
  final double bubbleBorderRadius;
  final EdgeInsets bubblePadding;

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
              color: selectedColor,
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
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: duration,
          curve: state.animationStyle.curve,
          padding: _isSelected ? bubblePadding : const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: _isSelected
                ? selectedColor.withValues(alpha: 0.15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(bubbleBorderRadius),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedScale(
                scale: _isSelected ? 1.15 : 1.0,
                duration: duration,
                curve: state.animationStyle.curve,
                child: iconWidget,
              ),
              if (showLabel) ...[
                const SizedBox(width: 8),
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
