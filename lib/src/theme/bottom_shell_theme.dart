import 'package:flutter/material.dart';

import 'bottom_shell_theme_data.dart';

/// Provides bottom shell theme data to descendants.
class BottomShellTheme extends InheritedWidget {
  /// Creates a bottom shell theme.
  const BottomShellTheme({required this.data, required super.child, super.key});

  /// Theme data consumed by renderers.
  final BottomShellThemeData data;

  /// Returns the nearest theme or Material-derived defaults.
  static BottomShellThemeData of(BuildContext context) {
    final theme = context
        .dependOnInheritedWidgetOfExactType<BottomShellTheme>();
    return theme?.data ??
        BottomShellThemeData.fromColorScheme(Theme.of(context).colorScheme);
  }

  @override
  bool updateShouldNotify(BottomShellTheme oldWidget) {
    return oldWidget.data != data;
  }
}
