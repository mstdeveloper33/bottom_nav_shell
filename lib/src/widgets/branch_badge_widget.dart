import 'package:flutter/material.dart';

import '../branch/branch_badge.dart';
import '../theme/bottom_shell_theme_data.dart';

/// Renders a badge over a destination icon.
class BranchBadgeWidget extends StatelessWidget {
  /// Creates a badge widget.
  const BranchBadgeWidget({
    required this.badge,
    required this.child,
    required this.theme,
    super.key,
  });

  /// Badge metadata.
  final BranchBadge badge;

  /// Child displayed below the badge.
  final Widget child;

  /// Theme tokens.
  final BottomShellThemeData theme;

  @override
  Widget build(BuildContext context) {
    final color = badge.color ?? theme.badgeColor ?? Colors.red;
    final semanticsLabel = badge.isDot
        ? 'New notification'
        : '${badge.displayText} notifications';

    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        PositionedDirectional(
          top: -6,
          end: -10,
          child: Semantics(
            label: semanticsLabel,
            child: badge.isDot
                ? _DotBadge(color: color)
                : _CountBadge(color: color, text: badge.displayText),
          ),
        ),
      ],
    );
  }
}

class _DotBadge extends StatelessWidget {
  const _DotBadge({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: const SizedBox(width: 8, height: 8),
    );
  }
}

class _CountBadge extends StatelessWidget {
  const _CountBadge({required this.color, required this.text});

  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    final isShort = text.length == 1;
    return Container(
      constraints: BoxConstraints(minWidth: isShort ? 20 : 24, minHeight: 18),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        maxLines: 1,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          height: 1.45,
        ),
      ),
    );
  }
}
