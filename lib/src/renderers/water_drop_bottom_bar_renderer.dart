import 'package:flutter/material.dart';

import '../widgets/branch_badge_widget.dart';
import 'bottom_bar_renderer.dart';

/// Water drop bottom bar renderer.
///
/// The selected icon has a water-drop animation where the icon
/// appears to drop into a colored circle below.
class WaterDropBottomBarRenderer extends BottomBarRenderer {
  /// Creates a water drop renderer.
  const WaterDropBottomBarRenderer({
    this.height = 68,
    this.dropHeight = 22,
    this.dropRadius = 20,
  });

  /// Bar height.
  final double height;

  /// How far the drop moves down.
  final double dropHeight;

  /// Radius of the drop circle.
  final double dropRadius;

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
              child: _WaterDropItem(
                index: i,
                state: state,
                dropHeight: dropHeight,
                dropRadius: dropRadius,
              ),
            ),
        ],
      ),
    );
  }
}

class _WaterDropItem extends StatelessWidget {
  const _WaterDropItem({
    required this.index,
    required this.state,
    required this.dropHeight,
    required this.dropRadius,
  });

  final int index;
  final BottomBarState state;
  final double dropHeight;
  final double dropRadius;

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
            ? Colors.white
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
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Drop circle behind icon
              AnimatedContainer(
                duration: duration,
                curve: Curves.easeOutCubic,
                width: _isSelected ? dropRadius * 2 : 0,
                height: _isSelected ? dropRadius * 2 : 0,
                transform: Matrix4.translationValues(
                  0,
                  _isSelected ? dropHeight * 0.2 : dropHeight,
                  0,
                ),
                decoration: BoxDecoration(
                  color: selectedColor,
                  shape: BoxShape.circle,
                ),
              ),
              // Icon with vertical translation
              AnimatedContainer(
                duration: duration,
                curve: Curves.easeOutBack,
                transform: Matrix4.translationValues(
                  0,
                  _isSelected ? dropHeight * 0.2 : 0,
                  0,
                ),
                child: iconWidget,
              ),
              // Top indicator line
              Positioned(
                top: 2,
                child: AnimatedContainer(
                  duration: duration,
                  curve: state.animationStyle.curve,
                  width: _isSelected ? 12 : 0,
                  height: 3,
                  decoration: BoxDecoration(
                    color: selectedColor,
                    borderRadius: BorderRadius.circular(2),
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
