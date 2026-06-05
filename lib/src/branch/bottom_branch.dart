import 'package:flutter/material.dart';

import 'bottom_destination.dart';

/// Describes one persistent navigation branch in [BottomShell].
@immutable
class BottomBranch {
  /// Creates a shell branch.
  const BottomBranch({
    required this.id,
    required this.destination,
    required this.builder,
    this.navigatorKey,
    this.restorationScopeId,
  });

  /// Stable branch identifier.
  final String id;

  /// Destination metadata rendered in the bottom bar.
  final BottomDestination destination;

  /// Builds the root page for this branch navigator.
  final WidgetBuilder builder;

  /// Optional key for the branch navigator.
  final GlobalKey<NavigatorState>? navigatorKey;

  /// Optional restoration scope id for this branch navigator.
  final String? restorationScopeId;

  /// Returns a copy with updated fields.
  BottomBranch copyWith({
    String? id,
    BottomDestination? destination,
    WidgetBuilder? builder,
    GlobalKey<NavigatorState>? navigatorKey,
    String? restorationScopeId,
  }) {
    return BottomBranch(
      id: id ?? this.id,
      destination: destination ?? this.destination,
      builder: builder ?? this.builder,
      navigatorKey: navigatorKey ?? this.navigatorKey,
      restorationScopeId: restorationScopeId ?? this.restorationScopeId,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is BottomBranch &&
            other.id == id &&
            other.destination == destination &&
            other.builder == builder &&
            other.navigatorKey == navigatorKey &&
            other.restorationScopeId == restorationScopeId;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      destination,
      builder,
      navigatorKey,
      restorationScopeId,
    );
  }
}
