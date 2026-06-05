import 'package:flutter/material.dart';

/// Builds the body transition for branch changes.
typedef BottomShellBodyTransitionBuilder =
    Widget Function(
      BuildContext context,
      Animation<double> animation,
      int previousIndex,
      int currentIndex,
      Widget child,
    );

/// Body transition used when the selected branch changes.
@immutable
class BottomShellBodyTransition {
  /// Creates a custom body transition.
  const BottomShellBodyTransition({
    required this.type,
    this.duration = const Duration(milliseconds: 180),
    this.curve = Curves.easeOutCubic,
    this.slideOffset = const Offset(0.04, 0),
    this.scaleFrom = 0.98,
    this.builder,
  });

  /// Disables body transition animations.
  const BottomShellBodyTransition.none()
    : type = BottomShellBodyTransitionType.none,
      duration = Duration.zero,
      curve = Curves.linear,
      slideOffset = Offset.zero,
      scaleFrom = 1,
      builder = null;

  /// Fades the active body in.
  const BottomShellBodyTransition.fade({
    this.duration = const Duration(milliseconds: 180),
    this.curve = Curves.easeOutCubic,
  }) : type = BottomShellBodyTransitionType.fade,
       slideOffset = Offset.zero,
       scaleFrom = 1,
       builder = null;

  /// Slides and fades the active body in.
  const BottomShellBodyTransition.slide({
    this.duration = const Duration(milliseconds: 220),
    this.curve = Curves.easeOutCubic,
    this.slideOffset = const Offset(0.04, 0),
  }) : type = BottomShellBodyTransitionType.slide,
       scaleFrom = 1,
       builder = null;

  /// Scales and fades the active body in.
  const BottomShellBodyTransition.scale({
    this.duration = const Duration(milliseconds: 180),
    this.curve = Curves.easeOutCubic,
    this.scaleFrom = 0.98,
  }) : type = BottomShellBodyTransitionType.scale,
       slideOffset = Offset.zero,
       builder = null;

  /// Uses [builder] for full transition control.
  const BottomShellBodyTransition.custom({
    required BottomShellBodyTransitionBuilder this.builder,
    this.duration = const Duration(milliseconds: 180),
    this.curve = Curves.easeOutCubic,
  }) : type = BottomShellBodyTransitionType.custom,
       slideOffset = Offset.zero,
       scaleFrom = 1;

  /// Transition type.
  final BottomShellBodyTransitionType type;

  /// Transition duration.
  final Duration duration;

  /// Transition curve.
  final Curve curve;

  /// Initial slide offset for slide transitions.
  final Offset slideOffset;

  /// Initial scale for scale transitions.
  final double scaleFrom;

  /// Optional custom transition builder.
  final BottomShellBodyTransitionBuilder? builder;

  /// Whether this transition should animate.
  bool get enabled => type != BottomShellBodyTransitionType.none;

  /// Creates a copy with selected fields replaced.
  BottomShellBodyTransition copyWith({
    BottomShellBodyTransitionType? type,
    Duration? duration,
    Curve? curve,
    Offset? slideOffset,
    double? scaleFrom,
    BottomShellBodyTransitionBuilder? builder,
  }) {
    return BottomShellBodyTransition(
      type: type ?? this.type,
      duration: duration ?? this.duration,
      curve: curve ?? this.curve,
      slideOffset: slideOffset ?? this.slideOffset,
      scaleFrom: scaleFrom ?? this.scaleFrom,
      builder: builder ?? this.builder,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is BottomShellBodyTransition &&
            other.type == type &&
            other.duration == duration &&
            other.curve == curve &&
            other.slideOffset == slideOffset &&
            other.scaleFrom == scaleFrom &&
            other.builder == builder;
  }

  @override
  int get hashCode {
    return Object.hash(type, duration, curve, slideOffset, scaleFrom, builder);
  }
}

/// Built-in body transition types.
enum BottomShellBodyTransitionType {
  /// No body transition.
  none,

  /// Fade transition.
  fade,

  /// Slide and fade transition.
  slide,

  /// Scale and fade transition.
  scale,

  /// Custom transition builder.
  custom,
}
