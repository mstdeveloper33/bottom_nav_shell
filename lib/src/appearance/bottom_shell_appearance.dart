import 'package:flutter/material.dart';

import '../renderers/bottom_bar_renderer.dart';
import '../renderers/bubble_bottom_bar_renderer.dart';
import '../renderers/convex_bottom_bar_renderer.dart';
import '../renderers/curved_bottom_bar_renderer.dart';
import '../renderers/cupertino_bottom_bar_renderer.dart';
import '../renderers/dot_indicator_bottom_bar_renderer.dart';
import '../renderers/flashy_bottom_bar_renderer.dart';
import '../renderers/floating_pill_bottom_bar_renderer.dart';
import '../renderers/glow_bottom_bar_renderer.dart';
import '../renderers/gnav_bottom_bar_renderer.dart';
import '../renderers/material_bottom_bar_renderer.dart';
import '../renderers/neumorphic_bottom_bar_renderer.dart';
import '../renderers/sliding_bottom_bar_renderer.dart';
import '../renderers/water_drop_bottom_bar_renderer.dart';
import 'bottom_bar_animation_style.dart';
import 'bottom_label_behavior.dart';

/// Combines renderer and display defaults for a bottom shell.
@immutable
class BottomShellAppearance {
  /// Creates an appearance with a custom renderer.
  const BottomShellAppearance({
    required this.renderer,
    this.labelBehavior = BottomLabelBehavior.alwaysShow,
    this.animationStyle = const BottomBarAnimationStyle.smooth(),
  });

  /// Material-style appearance.
  const BottomShellAppearance.material({
    this.labelBehavior = BottomLabelBehavior.alwaysShow,
    this.animationStyle = const BottomBarAnimationStyle.smooth(),
  }) : renderer = const MaterialBottomBarRenderer();

  /// Floating pill appearance.
  factory BottomShellAppearance.floatingPill({
    BottomLabelBehavior labelBehavior = BottomLabelBehavior.onlySelected,
    BottomBarAnimationStyle animationStyle =
        const BottomBarAnimationStyle.smooth(),
    double height = 72,
    double borderRadius = 32,
    EdgeInsets margin = const EdgeInsets.fromLTRB(20, 0, 20, 12),
    int selectedFlex = 2,
    int unselectedFlex = 1,
  }) {
    return BottomShellAppearance(
      renderer: FloatingPillBottomBarRenderer(
        height: height,
        borderRadius: borderRadius,
        margin: margin,
        selectedFlex: selectedFlex,
        unselectedFlex: unselectedFlex,
      ),
      labelBehavior: labelBehavior,
      animationStyle: animationStyle,
    );
  }

  /// Cupertino-style appearance.
  const BottomShellAppearance.cupertino({
    this.labelBehavior = BottomLabelBehavior.alwaysShow,
    this.animationStyle = const BottomBarAnimationStyle.smooth(),
  }) : renderer = const CupertinoBottomBarRenderer();

  /// Curved/Notched appearance with a raised selected icon.
  factory BottomShellAppearance.curved({
    BottomLabelBehavior labelBehavior = BottomLabelBehavior.alwaysHide,
    BottomBarAnimationStyle animationStyle =
        const BottomBarAnimationStyle.smooth(),
    double height = 62,
    double curveDepth = 30,
    double curveWidth = 75,
    double elevation = 6,
    double fabSize = 56,
    double fabOffset = -18,
  }) {
    return BottomShellAppearance(
      renderer: CurvedBottomBarRenderer(
        height: height,
        curveDepth: curveDepth,
        curveWidth: curveWidth,
        elevation: elevation,
        fabSize: fabSize,
        fabOffset: fabOffset,
      ),
      labelBehavior: labelBehavior,
      animationStyle: animationStyle,
    );
  }

  /// Google-style pill tab bar appearance.
  factory BottomShellAppearance.gNav({
    BottomLabelBehavior labelBehavior = BottomLabelBehavior.onlySelected,
    BottomBarAnimationStyle animationStyle =
        const BottomBarAnimationStyle.smooth(),
    double height = 64,
    double gap = 8,
    double tabBorderRadius = 100,
    EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    EdgeInsets tabMargin = const EdgeInsets.symmetric(horizontal: 4),
    EdgeInsets tabPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
  }) {
    return BottomShellAppearance(
      renderer: GNavBottomBarRenderer(
        height: height,
        gap: gap,
        tabBorderRadius: tabBorderRadius,
        padding: padding,
        tabMargin: tabMargin,
        tabPadding: tabPadding,
      ),
      labelBehavior: labelBehavior,
      animationStyle: animationStyle,
    );
  }

  /// Dot indicator appearance — a small dot under the selected icon.
  factory BottomShellAppearance.dotIndicator({
    BottomLabelBehavior labelBehavior = BottomLabelBehavior.alwaysHide,
    BottomBarAnimationStyle animationStyle =
        const BottomBarAnimationStyle.smooth(),
    double height = 64,
    double dotSize = 5,
    double dotSpacing = 4,
  }) {
    return BottomShellAppearance(
      renderer: DotIndicatorBottomBarRenderer(
        height: height,
        dotSize: dotSize,
        dotSpacing: dotSpacing,
      ),
      labelBehavior: labelBehavior,
      animationStyle: animationStyle,
    );
  }

  /// Water drop appearance with drop animation.
  factory BottomShellAppearance.waterDrop({
    BottomLabelBehavior labelBehavior = BottomLabelBehavior.alwaysHide,
    BottomBarAnimationStyle animationStyle =
        const BottomBarAnimationStyle.smooth(),
    double height = 68,
    double dropHeight = 22,
    double dropRadius = 20,
  }) {
    return BottomShellAppearance(
      renderer: WaterDropBottomBarRenderer(
        height: height,
        dropHeight: dropHeight,
        dropRadius: dropRadius,
      ),
      labelBehavior: labelBehavior,
      animationStyle: animationStyle,
    );
  }

  /// Flashy appearance — icon slides up, label fades in below.
  factory BottomShellAppearance.flashy({
    BottomLabelBehavior labelBehavior = BottomLabelBehavior.onlySelected,
    BottomBarAnimationStyle animationStyle =
        const BottomBarAnimationStyle.smooth(),
    double height = 60,
    double iconShift = -6,
  }) {
    return BottomShellAppearance(
      renderer: FlashyBottomBarRenderer(
        height: height,
        iconShift: iconShift,
      ),
      labelBehavior: labelBehavior,
      animationStyle: animationStyle,
    );
  }

  /// Bubble/Expanding appearance — selected item expands into a pill.
  factory BottomShellAppearance.bubble({
    BottomLabelBehavior labelBehavior = BottomLabelBehavior.onlySelected,
    BottomBarAnimationStyle animationStyle =
        const BottomBarAnimationStyle.smooth(),
    double height = 64,
    double bubbleBorderRadius = 20,
    EdgeInsets bubblePadding =
        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
  }) {
    return BottomShellAppearance(
      renderer: BubbleBottomBarRenderer(
        height: height,
        bubbleBorderRadius: bubbleBorderRadius,
        bubblePadding: bubblePadding,
      ),
      labelBehavior: labelBehavior,
      animationStyle: animationStyle,
    );
  }

  /// Convex/FAB center appearance — a raised center button.
  factory BottomShellAppearance.convex({
    BottomLabelBehavior labelBehavior = BottomLabelBehavior.alwaysShow,
    BottomBarAnimationStyle animationStyle =
        const BottomBarAnimationStyle.smooth(),
    double height = 60,
    int centerIndex = -1,
    double convexSize = 56,
    double convexElevation = 20,
    double convexBorderRadius = 28,
  }) {
    return BottomShellAppearance(
      renderer: ConvexBottomBarRenderer(
        height: height,
        centerIndex: centerIndex,
        convexSize: convexSize,
        convexElevation: convexElevation,
        convexBorderRadius: convexBorderRadius,
      ),
      labelBehavior: labelBehavior,
      animationStyle: animationStyle,
    );
  }

  /// Sliding indicator appearance — a highlight slides between items.
  factory BottomShellAppearance.sliding({
    BottomLabelBehavior labelBehavior = BottomLabelBehavior.onlySelected,
    BottomBarAnimationStyle animationStyle =
        const BottomBarAnimationStyle.smooth(),
    double height = 64,
    double indicatorHeight = 44,
    double indicatorBorderRadius = 14,
    EdgeInsets indicatorMargin = const EdgeInsets.symmetric(horizontal: 6),
  }) {
    return BottomShellAppearance(
      renderer: SlidingBottomBarRenderer(
        height: height,
        indicatorHeight: indicatorHeight,
        indicatorBorderRadius: indicatorBorderRadius,
        indicatorMargin: indicatorMargin,
      ),
      labelBehavior: labelBehavior,
      animationStyle: animationStyle,
    );
  }

  /// Neumorphic (Soft UI) appearance — detached leading/trailing items with
  /// a grouped center container, concave/convex shadows and press effect.
  factory BottomShellAppearance.neumorphic({
    BottomLabelBehavior labelBehavior = BottomLabelBehavior.alwaysHide,
    BottomBarAnimationStyle animationStyle =
        const BottomBarAnimationStyle.smooth(),
    double height = 80,
    int detachedLeading = 1,
    int detachedTrailing = 1,
    double itemDiameter = 56,
    double groupBorderRadius = 36,
    double gap = 12,
    double shadowIntensity = 0.25,
    double depth = 6,
    double pressScale = 0.92,
    bool animateSelection = true,
    NeumorphicLightSource lightSource = NeumorphicLightSource.topLeft,
    EdgeInsets margin = const EdgeInsets.fromLTRB(16, 0, 16, 12),
    EdgeInsets groupPadding = const EdgeInsets.symmetric(horizontal: 8),
  }) {
    return BottomShellAppearance(
      renderer: NeumorphicBottomBarRenderer(
        height: height,
        detachedLeading: detachedLeading,
        detachedTrailing: detachedTrailing,
        itemDiameter: itemDiameter,
        groupBorderRadius: groupBorderRadius,
        gap: gap,
        shadowIntensity: shadowIntensity,
        depth: depth,
        pressScale: pressScale,
        animateSelection: animateSelection,
        lightSource: lightSource,
        margin: margin,
        groupPadding: groupPadding,
      ),
      labelBehavior: labelBehavior,
      animationStyle: animationStyle,
    );
  }

  /// Glow/Neon appearance — dark pill bar with colored glow on selected icon.
  factory BottomShellAppearance.glow({
    BottomLabelBehavior labelBehavior = BottomLabelBehavior.alwaysHide,
    BottomBarAnimationStyle animationStyle =
        const BottomBarAnimationStyle.smooth(),
    double height = 64,
    double borderRadius = 40,
    EdgeInsets margin = const EdgeInsets.fromLTRB(24, 0, 24, 16),
    Color backgroundColor = const Color(0xFF1E1E2C),
    Color surfaceColor = Colors.transparent,
    EdgeInsets surfacePadding = const EdgeInsets.all(0),
    double glowRadius = 24,
    double glowSpread = 8,
    double glowOpacity = 0.55,
  }) {
    return BottomShellAppearance(
      renderer: GlowBottomBarRenderer(
        height: height,
        borderRadius: borderRadius,
        margin: margin,
        backgroundColor: backgroundColor,
        surfaceColor: surfaceColor,
        surfacePadding: surfacePadding,
        glowRadius: glowRadius,
        glowSpread: glowSpread,
        glowOpacity: glowOpacity,
      ),
      labelBehavior: labelBehavior,
      animationStyle: animationStyle,
    );
  }

  /// Renderer used to draw the bottom bar.
  final BottomBarRenderer renderer;

  /// Label visibility behavior.
  final BottomLabelBehavior labelBehavior;

  /// Animation timing used by the renderer.
  final BottomBarAnimationStyle animationStyle;
}
