import 'package:flutter/foundation.dart';

/// UX behavior while an asynchronous destination guard is running.
@immutable
class SelectionGuardPolicy {
  /// Keeps the shell interactive without rendering a pending state.
  const SelectionGuardPolicy.passive()
    : showPendingIndicator = false,
      disableDestinationsWhilePending = false;

  /// Shows a pending state and blocks additional destination changes.
  const SelectionGuardPolicy.showPending({
    this.disableDestinationsWhilePending = true,
  }) : showPendingIndicator = true;

  /// Whether built-in renderers should show a pending indicator.
  final bool showPendingIndicator;

  /// Whether destinations should ignore taps while a guard is pending.
  final bool disableDestinationsWhilePending;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is SelectionGuardPolicy &&
            other.showPendingIndicator == showPendingIndicator &&
            other.disableDestinationsWhilePending ==
                disableDestinationsWhilePending;
  }

  @override
  int get hashCode =>
      Object.hash(showPendingIndicator, disableDestinationsWhilePending);
}
