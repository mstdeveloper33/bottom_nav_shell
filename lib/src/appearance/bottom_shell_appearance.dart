import 'package:flutter/material.dart';

import '../renderers/bottom_bar_renderer.dart';
import '../renderers/cupertino_bottom_bar_renderer.dart';
import '../renderers/floating_pill_bottom_bar_renderer.dart';
import '../renderers/material_bottom_bar_renderer.dart';
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
  }) {
    return BottomShellAppearance(
      renderer: FloatingPillBottomBarRenderer(
        height: height,
        borderRadius: borderRadius,
        margin: margin,
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

  /// Renderer used to draw the bottom bar.
  final BottomBarRenderer renderer;

  /// Label visibility behavior.
  final BottomLabelBehavior labelBehavior;

  /// Animation timing used by the renderer.
  final BottomBarAnimationStyle animationStyle;
}
