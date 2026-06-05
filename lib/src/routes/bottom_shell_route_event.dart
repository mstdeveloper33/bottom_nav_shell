import 'package:flutter/widgets.dart';

/// Core branch navigator route event type.
enum BottomShellRouteEventType {
  /// A route was pushed.
  push,

  /// A route was popped.
  pop,

  /// A route was removed.
  remove,

  /// A route was replaced.
  replace,
}

/// Detailed route event emitted by a core branch navigator.
@immutable
class BottomShellRouteEvent {
  /// Creates a route event.
  const BottomShellRouteEvent({
    required this.branchIndex,
    required this.type,
    required this.route,
    this.previousRoute,
  });

  /// Branch index that emitted the event.
  final int branchIndex;

  /// Route event type.
  final BottomShellRouteEventType type;

  /// Current route for this event.
  final Route<dynamic>? route;

  /// Previous route when available.
  final Route<dynamic>? previousRoute;

  /// Current route name when available.
  String? get routeName => route?.settings.name;

  /// Previous route name when available.
  String? get previousRouteName => previousRoute?.settings.name;
}
