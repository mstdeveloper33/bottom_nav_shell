import 'package:flutter/material.dart';

import '../branch/branch_badge.dart';
import '../theme/bottom_shell_theme_data.dart';

/// Renders a badge over a destination icon with animated transitions.
class BranchBadgeWidget extends StatefulWidget {
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
  State<BranchBadgeWidget> createState() => _BranchBadgeWidgetState();
}

class _BranchBadgeWidgetState extends State<BranchBadgeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.4), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.4, end: 0.9), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 0.9, end: 1.0), weight: 30),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void didUpdateWidget(BranchBadgeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.badge != widget.badge && widget.badge.animated) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color =
        widget.badge.color ?? widget.theme.badgeColor ?? Colors.red;
    final semanticsLabel = widget.badge.isDot
        ? 'New notification'
        : '${widget.badge.displayText} notifications';

    return Stack(
      clipBehavior: Clip.none,
      children: [
        widget.child,
        PositionedDirectional(
          top: -6,
          end: -10,
          child: Semantics(
            label: semanticsLabel,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: widget.badge.isDot
                  ? _DotBadge(color: color)
                  : _CountBadge(color: color, text: widget.badge.displayText),
            ),
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
