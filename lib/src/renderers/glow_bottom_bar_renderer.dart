import 'package:flutter/material.dart';

import '../appearance/bottom_label_behavior.dart';
import '../widgets/branch_badge_widget.dart';
import 'bottom_bar_renderer.dart';

/// Glow bottom bar renderer.
///
/// A dark floating pill bar where the selected icon emits a colored
/// glow/neon effect behind it. Unselected icons remain subtle.
class GlowBottomBarRenderer extends BottomBarRenderer {
  /// Creates a glow bottom bar renderer.
  const GlowBottomBarRenderer({
    this.height = 64,
    this.borderRadius = 40,
    this.margin = const EdgeInsets.fromLTRB(24, 0, 24, 16),
    this.backgroundColor = const Color(0xFF1E1E2C),
    this.surfaceColor = Colors.transparent,
    this.surfacePadding = const EdgeInsets.all(0),
    this.glowRadius = 24,
    this.glowSpread = 8,
    this.glowOpacity = 0.55,
  });

  /// Bar height.
  final double height;

  /// Corner radius of the pill bar.
  final double borderRadius;

  /// Outer margin around the bar.
  final EdgeInsets margin;

  /// Background color of the bar (typically dark).
  final Color backgroundColor;

  /// Color of the outer card/surface that the bar sits on.
  final Color surfaceColor;

  /// Padding applied between the outer surface and the clipped bar.
  final EdgeInsets surfacePadding;

  /// Blur radius of the glow behind the selected icon.
  final double glowRadius;

  /// Spread of the glow.
  final double glowSpread;

  /// Opacity of the glow color.
  final double glowOpacity;

  @override
  Widget build(BuildContext context, BottomBarState state) {
    final selectedColor =
        state.theme.selectedItemColor ??
        Theme.of(context).colorScheme.primary;
    final radius = BorderRadius.circular(borderRadius);

    return Padding(
      padding: margin,
      child: Container(
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: radius,
        ),
        child: Padding(
          padding: surfacePadding,
          child: ClipRRect(
            borderRadius: radius,
            child: Container(
              height: height,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: radius,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (var i = 0; i < state.destinations.length; i++)
                    Expanded(
                      child: _GlowItem(
                        index: i,
                        state: state,
                        selectedColor: selectedColor,
                        glowRadius: glowRadius,
                        glowSpread: glowSpread,
                        glowOpacity: glowOpacity,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GlowItem extends StatelessWidget {
  const _GlowItem({
    required this.index,
    required this.state,
    required this.selectedColor,
    required this.glowRadius,
    required this.glowSpread,
    required this.glowOpacity,
  });

  final int index;
  final BottomBarState state;
  final Color selectedColor;
  final double glowRadius;
  final double glowSpread;
  final double glowOpacity;

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

    final itemColor = destination.selectedColor ?? selectedColor;
    final unselectedColor = destination.unselectedColor ??
        state.theme.unselectedItemColor ?? Colors.white60;
    final activeColor = _isSelected ? itemColor : unselectedColor;
    final effectiveColor =
        isEnabled ? activeColor : activeColor.withValues(alpha: 0.3);

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
        child: SizedBox.expand(
          child: Center(
            child: AnimatedContainer(
              duration: duration,
              curve: state.animationStyle.curve,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: _isSelected
                    ? [
                        BoxShadow(
                          color: itemColor.withValues(alpha: glowOpacity),
                          blurRadius: glowRadius,
                          spreadRadius: glowSpread,
                        ),
                        BoxShadow(
                          color: itemColor.withValues(alpha: glowOpacity * 0.4),
                          blurRadius: glowRadius * 2,
                          spreadRadius: glowSpread * 0.5,
                        ),
                      ]
                    : [],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedScale(
                    scale: _isSelected ? 1.15 : 1.0,
                    duration: duration,
                    curve: state.animationStyle.curve,
                    child: iconWidget,
                  ),
                  if (showLabel) ...[
                    const SizedBox(height: 2),
                    Text(
                      destination.label,
                      style: TextStyle(
                        color: effectiveColor,
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
