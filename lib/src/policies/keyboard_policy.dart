import 'package:flutter/foundation.dart';

/// Controls bottom bar behavior while the software keyboard is visible.
@immutable
class KeyboardPolicy {
  /// Keeps the bottom bar visible when the keyboard opens.
  const KeyboardPolicy.keepVisible() : hideNavigationBar = false;

  /// Hides the bottom bar when the keyboard opens.
  const KeyboardPolicy.hideNavigationBar() : hideNavigationBar = true;

  /// Whether the navigation bar should be hidden while keyboard is visible.
  final bool hideNavigationBar;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is KeyboardPolicy && other.hideNavigationBar == hideNavigationBar;
  }

  @override
  int get hashCode => hideNavigationBar.hashCode;
}
