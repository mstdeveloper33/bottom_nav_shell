import 'package:flutter/material.dart';

import '../appearance/bottom_label_behavior.dart';
import '../branch/bottom_destination.dart';
import '../renderers/bottom_bar_renderer.dart';
import 'branch_badge_widget.dart';

/// Shared destination item used by built-in renderers.
class BottomBarItem extends StatelessWidget {
  /// Creates a bottom bar destination item.
  const BottomBarItem({
    required this.destination,
    required this.index,
    required this.state,
    this.showIndicator = false,
    this.expandedSelected = false,
    super.key,
  });

  /// Destination metadata.
  final BottomDestination destination;

  /// Item index.
  final int index;

  /// Renderer state.
  final BottomBarState state;

  /// Whether a selected underline indicator is shown.
  final bool showIndicator;

  /// Whether the selected state should use pill-like horizontal layout.
  final bool expandedSelected;

  bool get _isSelected => index == state.selectedIndex;

  bool get _showLabel {
    return switch (state.labelBehavior) {
      BottomLabelBehavior.alwaysShow => true,
      BottomLabelBehavior.onlySelected => _isSelected,
      BottomLabelBehavior.alwaysHide => false,
    };
  }

  @override
  Widget build(BuildContext context) {
    final isEnabled = state.canSelect(index);
    final isPending = state.isPending(index);
    final disableAnimations =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final duration = disableAnimations
        ? Duration.zero
        : state.animationStyle.duration;
    final colorScheme = Theme.of(context).colorScheme;
    final selectedColor =
        destination.selectedColor ??
        state.theme.selectedItemColor ??
        colorScheme.primary;
    final unselectedColor =
        state.theme.unselectedItemColor ?? colorScheme.onSurfaceVariant;
    final itemColor = _isSelected ? selectedColor : unselectedColor;
    final effectiveColor = isEnabled
        ? itemColor
        : unselectedColor.withValues(alpha: 0.38);
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
            _isSelected ? destination.effectiveSelectedIcon : destination.icon,
            size: state.theme.iconSize,
            color: effectiveColor,
          );
    final iconWithBadge = destination.badge == null
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
              color: effectiveColor,
              fontWeight: _isSelected ? FontWeight.w700 : FontWeight.w500,
            );

    final content = expandedSelected && _isSelected
        ? Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              iconWithBadge,
              if (_showLabel) ...[
                const SizedBox(width: 8),
                Flexible(
                  child: _Label(
                    text: destination.label,
                    style: labelStyle,
                    duration: duration,
                  ),
                ),
              ],
            ],
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              iconWithBadge,
              if (_showLabel) ...[
                const SizedBox(height: 3),
                _Label(
                  text: destination.label,
                  style: labelStyle,
                  duration: duration,
                ),
              ],
            ],
          );

    return Semantics(
      label: destination.effectiveTooltip,
      button: true,
      enabled: isEnabled,
      selected: _isSelected,
      hint: isPending
          ? 'Loading tab'
          : !isEnabled
          ? 'Disabled tab'
          : _isSelected
          ? 'Selected tab'
          : 'Go to ${destination.effectiveTooltip} tab',
      onTap: isEnabled ? () => state.onSelect(index) : null,
      child: Tooltip(
        message: destination.effectiveTooltip,
        child: InkResponse(
          onTap: isEnabled ? () => state.onSelect(index) : null,
          radius: 34,
          containedInkWell: false,
          child: AnimatedScale(
            scale: _isSelected ? 1.0 : 0.96,
            duration: duration,
            curve: state.animationStyle.curve,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(child: Center(child: content)),
                    if (showIndicator)
                      AnimatedContainer(
                        duration: duration,
                        curve: state.animationStyle.curve,
                        width: _isSelected ? 24 : 0,
                        height: 3,
                        decoration: BoxDecoration(
                          color: selectedColor,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label({
    required this.text,
    required this.style,
    required this.duration,
  });

  final String text;
  final TextStyle style;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return AnimatedDefaultTextStyle(
      duration: duration,
      style: style,
      child: Text(
        text,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        textAlign: TextAlign.center,
      ),
    );
  }
}
