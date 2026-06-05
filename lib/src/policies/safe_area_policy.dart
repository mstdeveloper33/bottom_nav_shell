import 'package:flutter/foundation.dart';

/// SafeArea behavior for the rendered bottom bar.
@immutable
class SafeAreaPolicy {
  /// Creates a SafeArea policy.
  const SafeAreaPolicy({
    this.enabled = true,
    this.left = false,
    this.right = false,
    this.bottom = true,
    this.maintainBottomViewPadding = false,
  });

  /// Whether the bottom bar is wrapped in SafeArea.
  final bool enabled;

  /// Whether left safe area padding is applied.
  final bool left;

  /// Whether right safe area padding is applied.
  final bool right;

  /// Whether bottom safe area padding is applied.
  final bool bottom;

  /// Whether bottom view padding is kept when the keyboard is visible.
  final bool maintainBottomViewPadding;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is SafeAreaPolicy &&
            other.enabled == enabled &&
            other.left == left &&
            other.right == right &&
            other.bottom == bottom &&
            other.maintainBottomViewPadding == maintainBottomViewPadding;
  }

  @override
  int get hashCode {
    return Object.hash(enabled, left, right, bottom, maintainBottomViewPadding);
  }
}
