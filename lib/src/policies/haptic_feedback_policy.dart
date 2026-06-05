import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Haptic feedback behavior for destination selections.
@immutable
class HapticFeedbackPolicy {
  /// Disables haptic feedback.
  const HapticFeedbackPolicy.disabled() : type = HapticFeedbackType.none;

  /// Uses the platform selection-click haptic.
  const HapticFeedbackPolicy.selectionClick()
    : type = HapticFeedbackType.selectionClick;

  /// Uses the platform light-impact haptic.
  const HapticFeedbackPolicy.lightImpact()
    : type = HapticFeedbackType.lightImpact;

  /// Haptic feedback type.
  final HapticFeedbackType type;

  /// Whether feedback is enabled.
  bool get enabled => type != HapticFeedbackType.none;

  /// Triggers the configured haptic feedback.
  Future<void> perform() {
    return switch (type) {
      HapticFeedbackType.none => Future<void>.value(),
      HapticFeedbackType.selectionClick => HapticFeedback.selectionClick(),
      HapticFeedbackType.lightImpact => HapticFeedback.lightImpact(),
    };
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is HapticFeedbackPolicy && other.type == type;
  }

  @override
  int get hashCode => type.hashCode;
}

/// Supported haptic feedback types.
enum HapticFeedbackType {
  /// No haptic feedback.
  none,

  /// Selection-click haptic feedback.
  selectionClick,

  /// Light-impact haptic feedback.
  lightImpact,
}
