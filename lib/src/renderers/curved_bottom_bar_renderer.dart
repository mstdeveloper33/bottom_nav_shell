import 'package:flutter/material.dart';

import '../widgets/branch_badge_widget.dart';
import 'bottom_bar_renderer.dart';

/// Curved/Notched bottom bar renderer inspired by curved_navigation_bar.
///
/// A solid colored bar with a smooth circular notch cut into the top edge.
/// The selected icon sits inside the notch area, elevated in a matching
/// colored circle that appears to emerge from the bar.
class CurvedBottomBarRenderer extends BottomBarRenderer {
  /// Creates a curved bottom bar renderer.
  const CurvedBottomBarRenderer({
    this.height = 62,
    this.curveDepth = 30,
    this.curveWidth = 75,
    this.elevation = 6,
    this.fabSize = 56,
    this.fabOffset = -18,
  });

  /// Bar height (the flat portion below the notch).
  final double height;

  /// How deep the notch dips into the bar from the top edge.
  final double curveDepth;

  /// Horizontal width of the notch opening.
  final double curveWidth;

  /// Shadow blur radius behind the bar.
  final double elevation;

  /// Diameter of the floating circle holding the selected icon.
  final double fabSize;

  /// Vertical offset of the circle center relative to the bar top.
  /// Negative means above the bar edge.
  final double fabOffset;

  @override
  Widget build(BuildContext context, BottomBarState state) {
    final colorScheme = Theme.of(context).colorScheme;
    final background = state.theme.backgroundColor ?? colorScheme.surface;
    final shadowColor =
        state.theme.shadowColor ?? Colors.black.withValues(alpha: 0.08);
    final selectedColor =
        state.theme.selectedItemColor ?? colorScheme.primary;
    final unselectedColor =
        state.theme.unselectedItemColor ?? colorScheme.onSurfaceVariant;
    final disableAnimations =
      MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final duration =
      disableAnimations ? Duration.zero : state.animationStyle.duration;

    // Total widget height = bar height + the part of FAB sticking above
    final fabAbove = (fabSize / 2) + fabOffset.abs() - curveDepth;
    final totalHeight = height + (fabAbove > 0 ? fabAbove : 0) + 4;

    return SizedBox(
      height: totalHeight,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final barWidth = constraints.maxWidth;
          final itemWidth = barWidth / state.destinations.length;
          final selectedCenterX =
              itemWidth * state.selectedIndex + itemWidth / 2;

          return Stack(
            clipBehavior: Clip.none,
            children: [
              // Bar with notch
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(end: selectedCenterX),
                  duration: duration,
                  curve: state.animationStyle.curve,
                  builder: (context, animatedCenterX, child) {
                    return CustomPaint(
                      painter: _NotchPainter(
                        notchCenterX: animatedCenterX,
                        notchWidth: curveWidth,
                        notchDepth: curveDepth,
                        barColor: background,
                        shadowColor: shadowColor,
                        shadowBlur: elevation,
                      ),
                      child: child,
                    );
                  },
                  child: SizedBox(height: height),
                ),
              ),
              // Unselected items
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: height,
                child: Row(
                  children: [
                    for (var i = 0; i < state.destinations.length; i++)
                      Expanded(
                        child: i == state.selectedIndex
                            ? const SizedBox.shrink()
                            : _UnselectedItem(
                                index: i,
                                state: state,
                                color: unselectedColor,
                              ),
                      ),
                  ],
                ),
              ),
              // Selected FAB circle
              _SelectedFab(
                state: state,
                barWidth: barWidth,
                fabSize: fabSize,
                selectedColor: selectedColor,
                bottomOffset: height - curveDepth + fabOffset.abs() -
                    fabSize / 2,
              ),
            ],
          );
        },
      ),
    );
  }
}

// ───────────────────────────── Selected FAB ─────────────────────────────

class _SelectedFab extends StatelessWidget {
  const _SelectedFab({
    required this.state,
    required this.barWidth,
    required this.fabSize,
    required this.selectedColor,
    required this.bottomOffset,
  });

  final BottomBarState state;
  final double barWidth;
  final double fabSize;
  final Color selectedColor;
  final double bottomOffset;

  @override
  Widget build(BuildContext context) {
    final disableAnimations =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final duration =
        disableAnimations ? Duration.zero : state.animationStyle.duration;

    final itemCount = state.destinations.length;
    final itemWidth = barWidth / itemCount;
    final leftPos =
        itemWidth * state.selectedIndex + itemWidth / 2 - fabSize / 2;

    final destination = state.destinations[state.selectedIndex];
    final isPending = state.isPending(state.selectedIndex);

    final icon = isPending
        ? SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: Colors.white,
            ),
          )
        : Icon(
            destination.effectiveSelectedIcon,
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

    return AnimatedPositioned(
      duration: duration,
      curve: state.animationStyle.curve,
      bottom: bottomOffset,
      left: leftPos,
      width: fabSize,
      height: fabSize,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: selectedColor,
          border: Border.all(
            color: Theme.of(context).scaffoldBackgroundColor,
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: selectedColor.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () => state.onSelect(state.selectedIndex),
            child: Center(child: iconWidget),
          ),
        ),
      ),
    );
  }
}

// ───────────────────────────── Unselected Item ─────────────────────────────

class _UnselectedItem extends StatelessWidget {
  const _UnselectedItem({
    required this.index,
    required this.state,
    required this.color,
  });

  final int index;
  final BottomBarState state;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final destination = state.destinations[index];
    final isEnabled = state.canSelect(index);
    final isPending = state.isPending(index);
    final effectiveColor =
        isEnabled ? color : color.withValues(alpha: 0.38);

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
            destination.icon,
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
      child: GestureDetector(
        onTap: isEnabled ? () => state.onSelect(index) : null,
        behavior: HitTestBehavior.opaque,
        child: SizedBox.expand(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              iconWidget,
              const SizedBox(height: 4),
              Text(
                destination.label,
                style: TextStyle(
                  color: effectiveColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ───────────────────────────── Notch Painter ─────────────────────────────

class _NotchPainter extends CustomPainter {
  _NotchPainter({
    required this.notchCenterX,
    required this.notchWidth,
    required this.notchDepth,
    required this.barColor,
    required this.shadowColor,
    required this.shadowBlur,
  });

  final double notchCenterX;
  final double notchWidth;
  final double notchDepth;
  final Color barColor;
  final Color shadowColor;
  final double shadowBlur;

  @override
  void paint(Canvas canvas, Size size) {
    final barPaint = Paint()
      ..color = barColor
      ..style = PaintingStyle.fill;

    final shadow = Paint()
      ..color = shadowColor
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, shadowBlur);

    // Notch geometry
    final halfW = notchWidth / 2;
    final notchLeft = notchCenterX - halfW;
    final notchRight = notchCenterX + halfW;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(notchLeft - 8, 0);

    // Smooth entry curve into the notch
    path.cubicTo(
      notchLeft + 2, 0, // cp1
      notchLeft + 2, notchDepth * 0.65, // cp2
      notchCenterX, notchDepth, // end: bottom of notch
    );

    // Smooth exit curve out of the notch
    path.cubicTo(
      notchRight - 2, notchDepth * 0.65, // cp1
      notchRight - 2, 0, // cp2
      notchRight + 8, 0, // end: back to top edge
    );

    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, shadow);
    canvas.drawPath(path, barPaint);
  }

  @override
  bool shouldRepaint(covariant _NotchPainter old) {
    return old.notchCenterX != notchCenterX ||
        old.notchWidth != notchWidth ||
        old.notchDepth != notchDepth ||
        old.barColor != barColor ||
        old.shadowColor != shadowColor ||
        old.shadowBlur != shadowBlur;
  }
}
