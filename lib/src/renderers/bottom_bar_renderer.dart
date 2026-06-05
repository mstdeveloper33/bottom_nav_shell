import 'package:flutter/material.dart';

import '../appearance/bottom_bar_animation_style.dart';
import '../appearance/bottom_label_behavior.dart';
import '../branch/bottom_destination.dart';
import '../theme/bottom_shell_theme_data.dart';

/// Callback used by custom bars to select a destination.
typedef BottomBarSelectCallback = void Function(int index);

/// Builder used to provide a fully custom bottom bar.
typedef BottomBarBuilder =
    Widget Function(BuildContext context, BottomBarState state);

/// Immutable state passed to bottom bar renderers.
@immutable
class BottomBarState {
  /// Creates bottom bar renderer state.
  const BottomBarState({
    required this.destinations,
    required this.selectedIndex,
    required this.onSelect,
    required this.theme,
    required this.labelBehavior,
    required this.animationStyle,
    this.pendingIndex,
    this.disableDestinationsWhilePending = false,
  });

  /// Destinations to render.
  final List<BottomDestination> destinations;

  /// Current selected destination index.
  final int selectedIndex;

  /// Selects a destination.
  final BottomBarSelectCallback onSelect;

  /// Theme tokens for the renderer.
  final BottomShellThemeData theme;

  /// Label visibility behavior.
  final BottomLabelBehavior labelBehavior;

  /// Animation timing.
  final BottomBarAnimationStyle animationStyle;

  /// Destination index currently waiting for an asynchronous guard.
  final int? pendingIndex;

  /// Whether destination taps should be blocked while [pendingIndex] is set.
  final bool disableDestinationsWhilePending;

  /// Whether any destination guard is pending.
  bool get hasPendingSelection => pendingIndex != null;

  /// Whether [index] is waiting for an asynchronous guard.
  bool isPending(int index) => pendingIndex == index;

  /// Whether [index] can currently be selected by a renderer.
  bool canSelect(int index) {
    if (!destinations[index].enabled) {
      return false;
    }
    return !disableDestinationsWhilePending || pendingIndex == null;
  }
}

/// Draws a bottom navigation bar for [BottomShell].
abstract class BottomBarRenderer {
  /// Creates a renderer.
  const BottomBarRenderer();

  /// Builds the bottom bar.
  Widget build(BuildContext context, BottomBarState state);
}
