import 'package:bottom_shell_nav/bottom_shell_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BranchBadge', () {
    test('renders dot and count badge metadata', () {
      const dot = BranchBadge.dot();
      const count = BranchBadge.count(120);

      expect(dot.isDot, isTrue);
      expect(dot.count, isNull);
      expect(count.isDot, isFalse);
      expect(count.displayText, '99+');
    });

    test('supports copyWith and equality', () {
      const badge = BranchBadge.count(4, color: Colors.red);
      final copy = badge.copyWith(count: 8);

      expect(copy.displayText, '8');
      expect(copy.color, Colors.red);
      expect(badge, const BranchBadge.count(4, color: Colors.red));
    });
  });

  group('BottomDestination', () {
    test('uses label and icon fallbacks', () {
      const destination = BottomDestination(
        icon: Icons.home_outlined,
        label: 'Home',
      );

      expect(destination.effectiveTooltip, 'Home');
      expect(destination.effectiveSelectedIcon, Icons.home_outlined);
    });

    test('supports copyWith and equality', () {
      const destination = BottomDestination(
        icon: Icons.home_outlined,
        selectedIcon: Icons.home,
        label: 'Home',
      );
      final copy = destination.copyWith(label: 'Start');

      expect(copy.label, 'Start');
      expect(copy.selectedIcon, Icons.home);
      expect(
        destination,
        const BottomDestination(
          icon: Icons.home_outlined,
          selectedIcon: Icons.home,
          label: 'Home',
        ),
      );
    });
  });

  group('BottomBranch', () {
    test('stores branch metadata', () {
      final branch = BottomBranch(
        id: 'home',
        destination: const BottomDestination(
          icon: Icons.home_outlined,
          label: 'Home',
        ),
        builder: (_) => const Text('Home'),
        restorationScopeId: 'home_scope',
      );

      expect(branch.id, 'home');
      expect(branch.destination.label, 'Home');
      expect(branch.restorationScopeId, 'home_scope');
    });
  });

  group('Policies', () {
    test('stores keyboard, haptic, guard and adaptive options', () {
      const keyboard = KeyboardNavigationPolicy.enabled(wrap: false);
      const haptic = HapticFeedbackPolicy.selectionClick();
      const guard = SelectionGuardPolicy.showPending();
      const adaptive = AdaptiveNavigationPolicy.automatic(
        extendedRailBreakpoint: 900,
      );

      expect(keyboard.enabled, isTrue);
      expect(keyboard.wrap, isFalse);
      expect(haptic.enabled, isTrue);
      expect(guard.showPendingIndicator, isTrue);
      expect(guard.disableDestinationsWhilePending, isTrue);
      expect(adaptive.extendedRailBreakpoint, 900);
      expect(adaptive.layoutForWidth(500), BottomAdaptiveLayout.bottomBar);
      expect(adaptive.layoutForWidth(700), BottomAdaptiveLayout.rail);
      expect(adaptive.layoutForWidth(950), BottomAdaptiveLayout.extendedRail);
      expect(adaptive.layoutForWidth(1300), BottomAdaptiveLayout.drawer);
    });
  });

  group('BottomShellGuardDecision', () {
    test('stores allow, block and redirect decisions', () {
      var redirected = false;
      const allow = BottomShellGuardDecision.allow(metadata: 'ok');
      const block = BottomShellGuardDecision.block(reason: 'auth');
      final redirect = BottomShellGuardDecision.redirect(
        redirect: () => redirected = true,
        reason: 'login',
      );

      expect(allow.allowed, isTrue);
      expect(allow.metadata, 'ok');
      expect(block.allowed, isFalse);
      expect(block.reason, 'auth');

      redirect.onBlocked?.call();
      expect(redirect.allowed, isFalse);
      expect(redirected, isTrue);
    });
  });
}
