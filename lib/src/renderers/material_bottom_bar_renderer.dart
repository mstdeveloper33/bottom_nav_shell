import 'package:flutter/material.dart';

import '../widgets/bottom_bar_item.dart';
import 'bottom_bar_renderer.dart';

/// Material 3 inspired custom bottom bar renderer.
class MaterialBottomBarRenderer extends BottomBarRenderer {
  /// Creates a Material bottom bar renderer.
  const MaterialBottomBarRenderer({this.showSelectedIndicator = true});

  /// Whether to show the selected underline indicator.
  final bool showSelectedIndicator;

  @override
  Widget build(BuildContext context, BottomBarState state) {
    final colorScheme = Theme.of(context).colorScheme;
    final highContrast = MediaQuery.maybeOf(context)?.highContrast ?? false;
    final background = state.theme.backgroundColor ?? colorScheme.surface;
    final borderColor = state.theme.borderColor ?? colorScheme.outlineVariant;

    return Material(
      color: background,
      child: Container(
        height: state.theme.height,
        decoration: BoxDecoration(
          color: background,
          border: Border(
            top: BorderSide(
              color: highContrast
                  ? colorScheme.onSurface
                  : borderColor.withValues(alpha: 0.75),
              width: highContrast ? 1 : 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            for (var index = 0; index < state.destinations.length; index++)
              Expanded(
                child: BottomBarItem(
                  destination: state.destinations[index],
                  index: index,
                  state: state,
                  showIndicator: showSelectedIndicator,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
