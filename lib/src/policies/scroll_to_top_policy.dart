import 'package:flutter/material.dart';

/// Controls scrolling the active branch root to top on re-tap.
@immutable
class ScrollToTopPolicy {
  /// Disables scroll-to-top behavior.
  const ScrollToTopPolicy.disabled()
    : enabled = false,
      duration = const Duration(milliseconds: 280),
      curve = Curves.easeOutCubic;

  /// Enables scroll-to-top behavior.
  const ScrollToTopPolicy.enabled({
    this.duration = const Duration(milliseconds: 280),
    this.curve = Curves.easeOutCubic,
  }) : enabled = true;

  /// Whether the behavior is enabled.
  final bool enabled;

  /// Scroll animation duration.
  final Duration duration;

  /// Scroll animation curve.
  final Curve curve;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ScrollToTopPolicy &&
            other.enabled == enabled &&
            other.duration == duration &&
            other.curve == curve;
  }

  @override
  int get hashCode => Object.hash(enabled, duration, curve);
}
