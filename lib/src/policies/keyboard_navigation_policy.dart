import 'package:flutter/foundation.dart';

/// Keyboard shortcuts for changing shell destinations on desktop and web.
@immutable
class KeyboardNavigationPolicy {
  /// Disables keyboard destination shortcuts.
  const KeyboardNavigationPolicy.disabled()
    : enabled = false,
      wrap = true,
      arrowKeys = true,
      homeEndKeys = true;

  /// Enables keyboard destination shortcuts.
  const KeyboardNavigationPolicy.enabled({
    this.wrap = true,
    this.arrowKeys = true,
    this.homeEndKeys = true,
  }) : enabled = true;

  /// Whether keyboard navigation is enabled.
  final bool enabled;

  /// Whether next/previous shortcuts wrap at the first and last destination.
  final bool wrap;

  /// Whether arrow keys change destinations.
  final bool arrowKeys;

  /// Whether Home and End jump to the first and last destination.
  final bool homeEndKeys;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is KeyboardNavigationPolicy &&
            other.enabled == enabled &&
            other.wrap == wrap &&
            other.arrowKeys == arrowKeys &&
            other.homeEndKeys == homeEndKeys;
  }

  @override
  int get hashCode => Object.hash(enabled, wrap, arrowKeys, homeEndKeys);
}
