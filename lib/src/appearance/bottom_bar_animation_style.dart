import 'package:flutter/material.dart';

/// Animation timing used by bottom bar renderers.
@immutable
class BottomBarAnimationStyle {
  /// Creates an animation style.
  const BottomBarAnimationStyle({
    this.duration = const Duration(milliseconds: 220),
    this.curve = Curves.easeOutCubic,
  });

  /// A smooth default animation style.
  const BottomBarAnimationStyle.smooth()
    : duration = const Duration(milliseconds: 220),
      curve = Curves.easeOutCubic;

  /// A disabled animation style.
  const BottomBarAnimationStyle.none()
    : duration = Duration.zero,
      curve = Curves.linear;

  /// Animation duration.
  final Duration duration;

  /// Animation curve.
  final Curve curve;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is BottomBarAnimationStyle &&
            other.duration == duration &&
            other.curve == curve;
  }

  @override
  int get hashCode => Object.hash(duration, curve);
}
