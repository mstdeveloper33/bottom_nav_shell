import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Result returned by a rich shell destination guard.
@immutable
class BottomShellGuardDecision {
  /// Allows the destination selection.
  const BottomShellGuardDecision.allow({this.metadata})
    : allowed = true,
      reason = null,
      onBlocked = null;

  /// Blocks the destination selection.
  const BottomShellGuardDecision.block({
    this.reason,
    this.metadata,
    this.onBlocked,
  }) : allowed = false;

  /// Blocks the selection and runs [redirect] after the guard resolves.
  const BottomShellGuardDecision.redirect({
    required VoidCallback redirect,
    this.reason,
    this.metadata,
  }) : allowed = false,
       onBlocked = redirect;

  /// Whether destination selection is allowed.
  final bool allowed;

  /// Optional machine-readable or user-facing block reason.
  final String? reason;

  /// Optional metadata for app-specific analytics or redirect handling.
  final Object? metadata;

  /// Optional callback invoked when the decision blocks selection.
  final VoidCallback? onBlocked;
}
