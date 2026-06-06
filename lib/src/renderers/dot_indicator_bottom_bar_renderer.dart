import 'package:flutter/material.dart';

import '../widgets/branch_badge_widget.dart';
import 'bottom_bar_renderer.dart';

/// Dot indicator bottom bar renderer.
///
/// Displays a small animated dot below the selected item icon.
class DotIndicatorBottomBarRenderer extends BottomBarRenderer {
  /// Creates a dot indicator renderer.
  const DotIndicatorBottomBarRenderer({
    this.height = 64,
    this.dotSize = 5,
    this.dotSpacing = 4,
  });

  /// Bar height.
  final double height;

  /// Diameter of the dot indicator.
  final double dotSize;

  /// Spacing between icon and dot.
  final double dotSpacing;

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
        children: [
          for (var i = 0; i < state.destinations.length; i++)
            Expanded(
              child: _DotItem(
                index: i,
                state: state,
                dotSize: dotSize,
                dotSpacing: dotSpacing,
              ),
            ),
        ],
      ),
    );
  }
}

class _DotItem extends StatelessWidget {
  const _DotItem({
    required this.index,
    required this.state,
    required this.dotSize,
    required this.dotSpacing,
  });

  final int index;
  final BottomBarState state;
  final double dotSize;
  final double dotSpacing;

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
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedScale(
                scale: _isSelected ? 1.1 : 1.0,
                duration: duration,
                curve: state.animationStyle.curve,
                child: iconWidget,
              ),
              SizedBox(height: dotSpacing),
              AnimatedContainer(
                duration: duration,
                curve: state.animationStyle.curve,
                width: _isSelected ? dotSize : 0,
                height: _isSelected ? dotSize : 0,
                decoration: BoxDecoration(
                  color: selectedColor,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
