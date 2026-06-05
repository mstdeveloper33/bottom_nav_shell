import 'package:flutter/material.dart';

/// Theme tokens consumed by bottom shell renderers.
@immutable
class BottomShellThemeData {
  /// Creates bottom shell theme data.
  const BottomShellThemeData({
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.indicatorColor,
    this.badgeColor,
    this.borderColor,
    this.shadowColor,
    this.height = 64,
    this.iconSize = 24,
    this.borderRadius = 16,
    this.margin = EdgeInsets.zero,
    this.labelTextStyle,
  });

  /// Creates defaults from a Material color scheme.
  factory BottomShellThemeData.fromColorScheme(ColorScheme scheme) {
    return BottomShellThemeData(
      backgroundColor: scheme.surface,
      selectedItemColor: scheme.primary,
      unselectedItemColor: scheme.onSurfaceVariant,
      indicatorColor: scheme.primaryContainer,
      badgeColor: scheme.error,
      borderColor: scheme.outlineVariant,
      shadowColor: Colors.black.withValues(alpha: 0.14),
    );
  }

  /// Bottom bar background color.
  final Color? backgroundColor;

  /// Selected destination color.
  final Color? selectedItemColor;

  /// Unselected destination color.
  final Color? unselectedItemColor;

  /// Selected indicator color.
  final Color? indicatorColor;

  /// Default badge color.
  final Color? badgeColor;

  /// Border/divider color.
  final Color? borderColor;

  /// Shadow color.
  final Color? shadowColor;

  /// Renderer height.
  final double height;

  /// Icon size.
  final double iconSize;

  /// Default shape radius.
  final double borderRadius;

  /// Default renderer margin.
  final EdgeInsets margin;

  /// Label text style.
  final TextStyle? labelTextStyle;

  /// Returns a copy with updated fields.
  BottomShellThemeData copyWith({
    Color? backgroundColor,
    Color? selectedItemColor,
    Color? unselectedItemColor,
    Color? indicatorColor,
    Color? badgeColor,
    Color? borderColor,
    Color? shadowColor,
    double? height,
    double? iconSize,
    double? borderRadius,
    EdgeInsets? margin,
    TextStyle? labelTextStyle,
  }) {
    return BottomShellThemeData(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      selectedItemColor: selectedItemColor ?? this.selectedItemColor,
      unselectedItemColor: unselectedItemColor ?? this.unselectedItemColor,
      indicatorColor: indicatorColor ?? this.indicatorColor,
      badgeColor: badgeColor ?? this.badgeColor,
      borderColor: borderColor ?? this.borderColor,
      shadowColor: shadowColor ?? this.shadowColor,
      height: height ?? this.height,
      iconSize: iconSize ?? this.iconSize,
      borderRadius: borderRadius ?? this.borderRadius,
      margin: margin ?? this.margin,
      labelTextStyle: labelTextStyle ?? this.labelTextStyle,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is BottomShellThemeData &&
            other.backgroundColor == backgroundColor &&
            other.selectedItemColor == selectedItemColor &&
            other.unselectedItemColor == unselectedItemColor &&
            other.indicatorColor == indicatorColor &&
            other.badgeColor == badgeColor &&
            other.borderColor == borderColor &&
            other.shadowColor == shadowColor &&
            other.height == height &&
            other.iconSize == iconSize &&
            other.borderRadius == borderRadius &&
            other.margin == margin &&
            other.labelTextStyle == labelTextStyle;
  }

  @override
  int get hashCode {
    return Object.hash(
      backgroundColor,
      selectedItemColor,
      unselectedItemColor,
      indicatorColor,
      badgeColor,
      borderColor,
      shadowColor,
      height,
      iconSize,
      borderRadius,
      margin,
      labelTextStyle,
    );
  }
}
