import 'package:flutter/material.dart';

/// Badge metadata displayed on a bottom shell destination.
@immutable
class BranchBadge {
  /// Creates a badge. Prefer [BranchBadge.dot] or [BranchBadge.count].
  const BranchBadge({this.count, this.color, this.animated = true})
    : assert(count == null || count > 0, 'Badge count must be greater than 0.');

  /// Creates a dot badge for unread/new content.
  const BranchBadge.dot({Color? color, bool animated = true})
    : this(color: color, animated: animated);

  /// Creates a numeric badge.
  const BranchBadge.count(int count, {Color? color, bool animated = true})
    : this(count: count, color: color, animated: animated);

  /// Numeric count. When null, the badge is rendered as a dot.
  final int? count;

  /// Badge color. Defaults to the package badge color when null.
  final Color? color;

  /// Whether renderers may animate this badge.
  final bool animated;

  /// Whether this badge should render as a dot.
  bool get isDot => count == null;

  /// Text shown for count badges, capped at `99+`.
  String get displayText {
    final value = count;
    if (value == null) {
      return '';
    }
    return value > 99 ? '99+' : value.toString();
  }

  /// Returns a copy with updated fields.
  BranchBadge copyWith({int? count, Color? color, bool? animated}) {
    return BranchBadge(
      count: count ?? this.count,
      color: color ?? this.color,
      animated: animated ?? this.animated,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is BranchBadge &&
            other.count == count &&
            other.color == color &&
            other.animated == animated;
  }

  @override
  int get hashCode => Object.hash(count, color, animated);
}
