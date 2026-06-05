import 'package:flutter/material.dart';

import 'branch_badge.dart';

/// Visual and accessibility metadata for a shell destination.
@immutable
class BottomDestination {
  /// Creates a destination for one bottom shell branch.
  const BottomDestination({
    required this.icon,
    required this.label,
    this.selectedIcon,
    this.tooltip,
    this.badge,
    this.selectedColor,
    this.unselectedColor,
    this.enabled = true,
  });

  /// Icon shown when the destination is not selected.
  final IconData icon;

  /// Icon shown when the destination is selected.
  final IconData? selectedIcon;

  /// Human readable destination label.
  final String label;

  /// Tooltip and semantics label. Defaults to [label].
  final String? tooltip;

  /// Optional badge displayed over the icon.
  final BranchBadge? badge;

  /// Optional selected color override for this destination.
  final Color? selectedColor;

  /// Optional unselected color override for this destination.
  /// When null, the global theme unselected color is used.
  final Color? unselectedColor;

  /// Whether this destination can be selected.
  final bool enabled;

  /// Effective selected icon.
  IconData get effectiveSelectedIcon => selectedIcon ?? icon;

  /// Effective tooltip.
  String get effectiveTooltip => tooltip ?? label;

  /// Returns a copy with updated fields.
  BottomDestination copyWith({
    IconData? icon,
    IconData? selectedIcon,
    String? label,
    String? tooltip,
    BranchBadge? badge,
    Color? selectedColor,
    Color? unselectedColor,
    bool? enabled,
  }) {
    return BottomDestination(
      icon: icon ?? this.icon,
      selectedIcon: selectedIcon ?? this.selectedIcon,
      label: label ?? this.label,
      tooltip: tooltip ?? this.tooltip,
      badge: badge ?? this.badge,
      selectedColor: selectedColor ?? this.selectedColor,
      unselectedColor: unselectedColor ?? this.unselectedColor,
      enabled: enabled ?? this.enabled,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is BottomDestination &&
            other.icon == icon &&
            other.selectedIcon == selectedIcon &&
            other.label == label &&
            other.tooltip == tooltip &&
            other.badge == badge &&
            other.selectedColor == selectedColor &&
            other.unselectedColor == unselectedColor &&
            other.enabled == enabled;
  }

  @override
  int get hashCode {
    return Object.hash(
      icon,
      selectedIcon,
      label,
      tooltip,
      badge,
      selectedColor,
      unselectedColor,
      enabled,
    );
  }
}
