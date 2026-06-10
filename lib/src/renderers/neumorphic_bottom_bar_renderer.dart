import 'package:flutter/material.dart';

import '../appearance/bottom_label_behavior.dart';
import '../widgets/branch_badge_widget.dart';
import 'bottom_bar_renderer.dart';

/// The direction from which the neumorphic light is cast.
enum NeumorphicLightSource {
  /// Light from top-left (default).
  topLeft,

  /// Light from top-right.
  topRight,

  /// Light from bottom-left.
  bottomLeft,

  /// Light from bottom-right.
  bottomRight,
}

/// Neumorphic (Soft UI) bottom bar renderer.
///
/// Features a soft-shadow design where:
/// - Leading and trailing items are rendered as independent floating circles
/// - Middle items are grouped in a single neumorphic container
/// - Selected items appear convex (raised), unselected items appear concave (inset)
/// - Press animation provides tactile feedback with scale and depth change
///
/// Supports both light and dark neumorphic themes automatically based on
/// the provided background color.
class NeumorphicBottomBarRenderer extends BottomBarRenderer {
  /// Creates a neumorphic bottom bar renderer.
  const NeumorphicBottomBarRenderer({
    this.height = 80,
    this.detachedLeading = 1,
    this.detachedTrailing = 1,
    this.itemDiameter = 56,
    this.groupBorderRadius = 36,
    this.gap = 12,
    this.shadowIntensity = 0.25,
    this.depth = 6,
    this.pressScale = 0.92,
    this.animateSelection = true,
    this.lightSource = NeumorphicLightSource.topLeft,
    this.margin = const EdgeInsets.fromLTRB(16, 0, 16, 12),
    this.groupPadding = const EdgeInsets.symmetric(horizontal: 8),
  });

  /// Overall height of the bar area.
  final double height;

  /// Number of items detached on the leading (left) side.
  final int detachedLeading;

  /// Number of items detached on the trailing (right) side.
  final int detachedTrailing;

  /// Diameter of each item circle (both detached and grouped items).
  final double itemDiameter;

  /// Border radius of the grouped center container.
  final double groupBorderRadius;

  /// Gap between detached items and the center group.
  final double gap;

  /// Shadow intensity (0.0 - 1.0). Higher = more pronounced shadows.
  final double shadowIntensity;

  /// Depth of the neumorphic effect in logical pixels.
  final double depth;

  /// Scale factor when an item is pressed (0.0 - 1.0).
  final double pressScale;

  /// Whether selection changes are animated.
  final bool animateSelection;

  /// Direction of the neumorphic light source.
  final NeumorphicLightSource lightSource;

  /// Outer margin around the entire bar.
  final EdgeInsets margin;

  /// Padding inside the center group container.
  final EdgeInsets groupPadding;

  @override
  Widget build(BuildContext context, BottomBarState state) {
    final totalItems = state.destinations.length;
    final leadingCount = detachedLeading.clamp(0, totalItems);
    final trailingCount = detachedTrailing.clamp(0, totalItems - leadingCount);
    final groupStart = leadingCount;
    final groupEnd = totalItems - trailingCount;

    final colorScheme = Theme.of(context).colorScheme;
    final background =
        state.theme.backgroundColor ?? colorScheme.surface;
    final isDark = ThemeData.estimateBrightnessForColor(background) ==
        Brightness.dark;

    final shadowLight = isDark
        ? Colors.white.withValues(alpha: shadowIntensity * 0.4)
        : Colors.white.withValues(alpha: shadowIntensity * 2.5);
    final shadowDark = isDark
        ? Colors.black.withValues(alpha: shadowIntensity * 1.8)
        : Colors.black.withValues(alpha: shadowIntensity);

    final lightOffset = _lightOffset;
    final darkOffset = Offset(-lightOffset.dx, -lightOffset.dy);

    return Padding(
      padding: state.theme.margin == EdgeInsets.zero
          ? margin
          : state.theme.margin,
      child: SizedBox(
        height: height,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Leading detached items
            for (var i = 0; i < leadingCount; i++) ...[
              _NeumorphicItem(
                index: i,
                state: state,
                background: background,
                shadowLight: shadowLight,
                shadowDark: shadowDark,
                lightOffset: lightOffset,
                darkOffset: darkOffset,
                diameter: itemDiameter,
                depth: depth,
                pressScale: pressScale,
                animateSelection: animateSelection,
                isDetached: true,
                borderRadius: itemDiameter / 2,
              ),
              if (i < leadingCount - 1 || groupEnd > groupStart)
                SizedBox(width: gap),
            ],

            // Center grouped items
            if (groupEnd > groupStart)
              Flexible(
                child: Container(
                  height: itemDiameter + 16,
                  padding: groupPadding,
                  decoration: BoxDecoration(
                    color: background,
                    borderRadius: BorderRadius.circular(groupBorderRadius),
                    boxShadow: [
                      BoxShadow(
                        color: shadowDark,
                        offset: darkOffset * 0.8,
                        blurRadius: depth * 1.5,
                        spreadRadius: -1,
                      ),
                      BoxShadow(
                        color: shadowLight,
                        offset: lightOffset * 0.8,
                        blurRadius: depth * 1.5,
                        spreadRadius: -1,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (var i = groupStart; i < groupEnd; i++)
                        Flexible(
                          child: _NeumorphicItem(
                            index: i,
                            state: state,
                            background: background,
                            shadowLight: shadowLight,
                            shadowDark: shadowDark,
                            lightOffset: lightOffset,
                            darkOffset: darkOffset,
                            diameter: itemDiameter,
                            depth: depth,
                            pressScale: pressScale,
                            animateSelection: animateSelection,
                            isDetached: false,
                            borderRadius: itemDiameter / 2,
                          ),
                        ),
                    ],
                  ),
                ),
              ),

            // Trailing detached items
            for (var i = groupEnd; i < totalItems; i++) ...[
              if (i == groupEnd && groupEnd > groupStart)
                SizedBox(width: gap),
              _NeumorphicItem(
                index: i,
                state: state,
                background: background,
                shadowLight: shadowLight,
                shadowDark: shadowDark,
                lightOffset: lightOffset,
                darkOffset: darkOffset,
                diameter: itemDiameter,
                depth: depth,
                pressScale: pressScale,
                animateSelection: animateSelection,
                isDetached: true,
                borderRadius: itemDiameter / 2,
              ),
              if (i < totalItems - 1) SizedBox(width: gap),
            ],
          ],
        ),
      ),
    );
  }

  Offset get _lightOffset {
    return switch (lightSource) {
      NeumorphicLightSource.topLeft => Offset(-depth, -depth),
      NeumorphicLightSource.topRight => Offset(depth, -depth),
      NeumorphicLightSource.bottomLeft => Offset(-depth, depth),
      NeumorphicLightSource.bottomRight => Offset(depth, depth),
    };
  }
}

class _NeumorphicItem extends StatefulWidget {
  const _NeumorphicItem({
    required this.index,
    required this.state,
    required this.background,
    required this.shadowLight,
    required this.shadowDark,
    required this.lightOffset,
    required this.darkOffset,
    required this.diameter,
    required this.depth,
    required this.pressScale,
    required this.animateSelection,
    required this.isDetached,
    required this.borderRadius,
  });

  final int index;
  final BottomBarState state;
  final Color background;
  final Color shadowLight;
  final Color shadowDark;
  final Offset lightOffset;
  final Offset darkOffset;
  final double diameter;
  final double depth;
  final double pressScale;
  final bool animateSelection;
  final bool isDetached;
  final double borderRadius;

  @override
  State<_NeumorphicItem> createState() => _NeumorphicItemState();
}

class _NeumorphicItemState extends State<_NeumorphicItem>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  late final AnimationController _pressController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.pressScale,
    ).animate(CurvedAnimation(
      parent: _pressController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  bool get _isSelected => widget.index == widget.state.selectedIndex;

  void _handleTapDown(TapDownDetails details) {
    if (!widget.state.canSelect(widget.index)) return;
    setState(() => _isPressed = true);
    _pressController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _pressController.reverse();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _pressController.reverse();
  }

  void _handleTap() {
    if (widget.state.canSelect(widget.index)) {
      widget.state.onSelect(widget.index);
    }
  }

  void _handleLongPress() {
    if (widget.state.canSelect(widget.index) &&
        widget.state.onLongPress != null) {
      widget.state.onLongPress!(widget.index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final disableAnimations =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final duration = disableAnimations
        ? Duration.zero
        : widget.animateSelection
            ? widget.state.animationStyle.duration
            : const Duration(milliseconds: 80);

    final destination = widget.state.destinations[widget.index];
    final isEnabled = widget.state.canSelect(widget.index);
    final isPending = widget.state.isPending(widget.index);

    final colorScheme = Theme.of(context).colorScheme;
    final selectedColor = destination.selectedColor ??
        widget.state.theme.selectedItemColor ??
        colorScheme.primary;
    final unselectedColor = destination.unselectedColor ??
        widget.state.theme.unselectedItemColor ??
        colorScheme.onSurfaceVariant;

    final effectiveColor = !isEnabled
        ? unselectedColor.withValues(alpha: 0.38)
        : _isSelected
            ? selectedColor
            : unselectedColor;

    // Neumorphic states:
    // - Selected: convex (outer shadows) — raised look
    // - Unselected: concave (inner shadows) — sunken look
    // - Pressed: deeper concave + scale down
    final isConvex = _isSelected && !_isPressed;

    final outerShadows = isConvex
        ? [
            BoxShadow(
              color: widget.shadowDark,
              offset: widget.darkOffset,
              blurRadius: widget.depth * 1.5,
            ),
            BoxShadow(
              color: widget.shadowLight,
              offset: widget.lightOffset,
              blurRadius: widget.depth * 1.5,
            ),
          ]
        : <BoxShadow>[];

    final innerShadowDecoration = !isConvex
        ? _InnerShadowDecoration(
            shadowDark: widget.shadowDark,
            shadowLight: widget.shadowLight,
            darkOffset: widget.darkOffset,
            lightOffset: widget.lightOffset,
            blurRadius: widget.depth * (_isPressed ? 2.0 : 1.2),
            borderRadius: widget.borderRadius,
          )
        : null;

    final icon = isPending
        ? SizedBox(
            width: widget.state.theme.iconSize,
            height: widget.state.theme.iconSize,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: effectiveColor,
            ),
          )
        : Icon(
            _isSelected
                ? destination.effectiveSelectedIcon
                : destination.icon,
            size: widget.state.theme.iconSize,
            color: effectiveColor,
          );

    final iconWidget = destination.badge == null
        ? icon
        : BranchBadgeWidget(
            badge: destination.badge!,
            theme: widget.state.theme,
            child: icon,
          );

    final showLabel = switch (widget.state.labelBehavior) {
      BottomLabelBehavior.alwaysShow => true,
      BottomLabelBehavior.onlySelected => _isSelected,
      BottomLabelBehavior.alwaysHide => false,
    };

    final labelStyle =
        (widget.state.theme.labelTextStyle ??
                Theme.of(context).textTheme.labelSmall ??
                const TextStyle())
            .copyWith(
              color: effectiveColor,
              fontWeight: _isSelected ? FontWeight.w700 : FontWeight.w500,
              fontSize: 10,
            );

    return Semantics(
      label: destination.effectiveTooltip,
      button: true,
      enabled: isEnabled,
      selected: _isSelected,
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: _handleTap,
        onLongPress: _handleLongPress,
        behavior: HitTestBehavior.opaque,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) => Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          ),
          child: AnimatedContainer(
            duration: duration,
            curve: widget.state.animationStyle.curve,
            width: widget.diameter,
            height: widget.diameter,
            decoration: BoxDecoration(
              color: widget.background,
              shape: BoxShape.circle,
              boxShadow: outerShadows,
            ),
            child: CustomPaint(
              painter: innerShadowDecoration,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    iconWidget,
                    if (showLabel) ...[
                      const SizedBox(height: 2),
                      Text(
                        destination.label,
                        style: labelStyle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Custom painter that renders inner shadows for the concave neumorphic effect.
class _InnerShadowDecoration extends CustomPainter {
  _InnerShadowDecoration({
    required this.shadowDark,
    required this.shadowLight,
    required this.darkOffset,
    required this.lightOffset,
    required this.blurRadius,
    required this.borderRadius,
  });

  final Color shadowDark;
  final Color shadowLight;
  final Offset darkOffset;
  final Offset lightOffset;
  final double blurRadius;
  final double borderRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(
      rect,
      Radius.circular(borderRadius),
    );

    canvas.save();
    canvas.clipRRect(rrect);

    // Dark inner shadow (from light direction — top-left light means
    // the dark shadow is at bottom-right inside the shape)
    _paintInnerShadow(canvas, size, shadowDark, darkOffset);

    // Light inner shadow (opposite side)
    _paintInnerShadow(canvas, size, shadowLight, lightOffset);

    canvas.restore();
  }

  void _paintInnerShadow(
      Canvas canvas, Size size, Color color, Offset offset) {
    final paint = Paint()
      ..color = color
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, _convertRadiusToSigma(blurRadius));

    final inflatedRect = Rect.fromLTWH(
      -size.width,
      -size.height,
      size.width * 3,
      size.height * 3,
    );

    final hole = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        offset.dx,
        offset.dy,
        size.width,
        size.height,
      ),
      Radius.circular(borderRadius),
    );

    final path = Path()
      ..addRect(inflatedRect)
      ..addRRect(hole);
    path.fillType = PathFillType.evenOdd;

    canvas.drawPath(path, paint);
  }

  static double _convertRadiusToSigma(double radius) {
    return radius * 0.57735 + 0.5;
  }

  @override
  bool shouldRepaint(covariant _InnerShadowDecoration oldDelegate) {
    return oldDelegate.shadowDark != shadowDark ||
        oldDelegate.shadowLight != shadowLight ||
        oldDelegate.darkOffset != darkOffset ||
        oldDelegate.lightOffset != lightOffset ||
        oldDelegate.blurRadius != blurRadius ||
        oldDelegate.borderRadius != borderRadius;
  }
}
