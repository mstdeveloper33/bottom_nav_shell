import 'package:flutter/foundation.dart';

/// Behavior used when the currently selected destination is tapped again.
@immutable
class ReTapBehavior {
  /// Performs no special action on re-tap.
  const ReTapBehavior.none() : popToRoot = false;

  /// Pops the current branch back to its root route on re-tap.
  const ReTapBehavior.popToRoot() : popToRoot = true;

  /// Whether re-tap should pop the active branch to root.
  final bool popToRoot;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ReTapBehavior && other.popToRoot == popToRoot;
  }

  @override
  int get hashCode => popToRoot.hashCode;
}
