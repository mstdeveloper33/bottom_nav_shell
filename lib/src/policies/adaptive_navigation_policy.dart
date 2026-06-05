import 'package:flutter/foundation.dart';

/// Resolved adaptive navigation layout.
enum BottomAdaptiveLayout {
  /// Compact bottom bar layout.
  bottomBar,

  /// Collapsed NavigationRail layout.
  rail,

  /// Extended NavigationRail layout.
  extendedRail,

  /// Drawer-style side panel layout.
  drawer,
}

/// Large-screen navigation behavior for [BottomShell].
@immutable
class AdaptiveNavigationPolicy {
  /// Disables adaptive navigation and always uses the bottom bar.
  const AdaptiveNavigationPolicy.disabled()
    : enabled = false,
      railBreakpoint = 600,
      extendedRailBreakpoint = 840,
      railMinWidth = 72,
      railMinExtendedWidth = 256,
      drawerBreakpoint = 1200,
      drawerWidth = 280;

  /// Uses a bottom bar below [railBreakpoint], rail above it and drawer on wide screens.
  const AdaptiveNavigationPolicy.automatic({
    this.railBreakpoint = 600,
    this.extendedRailBreakpoint = 840,
    this.railMinWidth = 72,
    this.railMinExtendedWidth = 256,
    this.drawerBreakpoint = 1200,
    this.drawerWidth = 280,
  }) : enabled = true;

  /// Whether adaptive layout is enabled.
  final bool enabled;

  /// Minimum width for switching to NavigationRail.
  final double railBreakpoint;

  /// Minimum width for using an extended NavigationRail.
  final double extendedRailBreakpoint;

  /// Collapsed rail minimum width.
  final double railMinWidth;

  /// Extended rail minimum width.
  final double railMinExtendedWidth;

  /// Minimum width for switching to a drawer-style side panel.
  final double drawerBreakpoint;

  /// Drawer-style panel width.
  final double drawerWidth;

  /// Resolves the adaptive layout for [width].
  BottomAdaptiveLayout layoutForWidth(double width) {
    if (!enabled || width < railBreakpoint) {
      return BottomAdaptiveLayout.bottomBar;
    }
    if (width >= drawerBreakpoint) {
      return BottomAdaptiveLayout.drawer;
    }
    if (width >= extendedRailBreakpoint) {
      return BottomAdaptiveLayout.extendedRail;
    }
    return BottomAdaptiveLayout.rail;
  }

  /// Whether [width] resolves to a rail layout.
  bool usesRail(double width) {
    final layout = layoutForWidth(width);
    return layout == BottomAdaptiveLayout.rail ||
        layout == BottomAdaptiveLayout.extendedRail;
  }

  /// Whether [width] resolves to an extended rail layout.
  bool usesExtendedRail(double width) {
    return layoutForWidth(width) == BottomAdaptiveLayout.extendedRail;
  }

  /// Whether [width] resolves to a drawer layout.
  bool usesDrawer(double width) {
    return layoutForWidth(width) == BottomAdaptiveLayout.drawer;
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AdaptiveNavigationPolicy &&
            other.enabled == enabled &&
            other.railBreakpoint == railBreakpoint &&
            other.extendedRailBreakpoint == extendedRailBreakpoint &&
            other.railMinWidth == railMinWidth &&
            other.railMinExtendedWidth == railMinExtendedWidth &&
            other.drawerBreakpoint == drawerBreakpoint &&
            other.drawerWidth == drawerWidth;
  }

  @override
  int get hashCode => Object.hash(
    enabled,
    railBreakpoint,
    extendedRailBreakpoint,
    railMinWidth,
    railMinExtendedWidth,
    drawerBreakpoint,
    drawerWidth,
  );
}
