import 'package:flutter/material.dart';

/// Controls hiding the bottom bar in response to vertical scroll.
@immutable
class ScrollToHidePolicy {
  /// Disables scroll-to-hide behavior.
  const ScrollToHidePolicy.disabled()
    : enabled = false,
      threshold = 6,
      duration = const Duration(milliseconds: 220),
      curve = Curves.easeOutCubic;

  /// Enables scroll-to-hide behavior.
  const ScrollToHidePolicy.enabled({
    this.threshold = 6,
    this.duration = const Duration(milliseconds: 220),
    this.curve = Curves.easeOutCubic,
  }) : enabled = true;

  /// Whether the behavior is enabled.
  final bool enabled;

  /// Minimum scroll delta before the bar changes visibility.
  final double threshold;

  /// Hide/show animation duration.
  final Duration duration;

  /// Hide/show animation curve.
  final Curve curve;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ScrollToHidePolicy &&
            other.enabled == enabled &&
            other.threshold == threshold &&
            other.duration == duration &&
            other.curve == curve;
  }

  @override
  int get hashCode => Object.hash(enabled, threshold, duration, curve);
}
