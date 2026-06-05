import 'package:flutter/material.dart';

import '../widgets/branch_badge_widget.dart';
import 'bottom_bar_renderer.dart';

/// Flashy bottom bar renderer.
///
/// The selected icon slides up and the label fades in from below.
/// Unselected icons remain centered with no label.
class FlashyBottomBarRenderer extends BottomBarRenderer {
  /// Creates a flashy renderer.
  const FlashyBottomBarRenderer({
    this.height = 60,
    this.iconShift = -6,
  });

  /// Bar height.
  final double height;

  /// How far the selected icon shifts up.
  final double iconShift;

  @override
  Widget build(BuildContext context, BottomBarState state) {
    final colorScheme = Theme.of(context).colorScheme;
    final background = state.theme.backgroundColor ?? colorScheme.surface;
    final borderColor = state.theme.borderColor ?? colorScheme.outlineVariant;
    final highContrast = MediaQuery.maybeOf(context)?.highContrast ?? false;

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: background,
        border: Border(
          top: BorderSide(
            color: highContrast
                ? colorScheme.onSurface
                : borderColor.withValues(alpha: 0.5),
            width: highContrast ? 1 : 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          for (var i = 0; i < state.destinations.length; i++)
            Expanded(
              child: _FlashyItem(
                index: i,
                state: state,
                iconShift: iconShift,
              ),
            ),
        ],
      ),
    );
  }
}

class _FlashyItem extends StatelessWidget {
  const _FlashyItem({
    required this.index,
    required this.state,
    required this.iconShift,
  });

  final int index;
  final BottomBarState state;
  final double iconShift;

  bool get _isSelected => index == state.selectedIndex;

  @override
  Widget build(BuildContext context) {
    final disableAnimations =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final duration =
        disableAnimations ? Duration.zero : state.animationStyle.duration;
    final colorScheme = Theme.of(context).colorScheme;
    final destination = state.destinations[index];
    final selectedColor = destination.selectedColor ??
        state.theme.selectedItemColor ??
        colorScheme.primary;
    final unselectedColor =
        state.theme.unselectedItemColor ?? colorScheme.onSurfaceVariant;
    final isEnabled = state.canSelect(index);
    final isPending = state.isPending(index);

    final effectiveColor = !isEnabled
        ? unselectedColor.withValues(alpha: 0.38)
        : _isSelected
            ? selectedColor
            : unselectedColor;

    final icon = isPending
        ? SizedBox(
            width: state.theme.iconSize,
            height: state.theme.iconSize,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: effectiveColor,
            ),
          )
        : Icon(
            _isSelected
                ? destination.effectiveSelectedIcon
                : destination.icon,
            size: state.theme.iconSize,
            color: effectiveColor,
          );

    final iconWidget = destination.badge == null
        ? icon
        : BranchBadgeWidget(
            badge: destination.badge!,
            theme: state.theme,
            child: icon,
          );

    final labelStyle =
        (state.theme.labelTextStyle ??
                Theme.of(context).textTheme.labelSmall ??
                const TextStyle())
            .copyWith(
              color: selectedColor,
              fontWeight: FontWeight.w700,
              fontSize: 11,
            );

    return Semantics(
      label: destination.effectiveTooltip,
      button: true,
      enabled: isEnabled,
      selected: _isSelected,
      child: GestureDetector(
        onTap: isEnabled ? () => state.onSelect(index) : null,
        behavior: HitTestBehavior.opaque,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: duration,
                curve: state.animationStyle.curve,
                transform: Matrix4.translationValues(
                  0,
                  _isSelected ? iconShift : 0,
                  0,
                ),
                child: iconWidget,
              ),
              AnimatedOpacity(
                duration: duration,
                curve: state.animationStyle.curve,
                opacity: _isSelected ? 1.0 : 0.0,
                child: AnimatedSlide(
                  duration: duration,
                  curve: state.animationStyle.curve,
                  offset: _isSelected ? Offset.zero : const Offset(0, 0.5),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      destination.label,
                      style: labelStyle,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
