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

  group('BottomShellBodyTransition', () {
    test('stores built-in transition presets', () {
      const none = BottomShellBodyTransition.none();
      const fade = BottomShellBodyTransition.fade();
      const slide = BottomShellBodyTransition.slide(
        slideOffset: Offset(0.1, 0),
      );
      const scale = BottomShellBodyTransition.scale(scaleFrom: 0.95);

      expect(none.enabled, isFalse);
      expect(fade.type, BottomShellBodyTransitionType.fade);
      expect(slide.slideOffset, const Offset(0.1, 0));
      expect(scale.scaleFrom, 0.95);
    });

    test('supports copyWith and equality', () {
      const transition = BottomShellBodyTransition.slide(
        duration: Duration(milliseconds: 240),
      );
      final copy = transition.copyWith(
        type: BottomShellBodyTransitionType.scale,
        scaleFrom: 0.94,
      );

      expect(copy.type, BottomShellBodyTransitionType.scale);
      expect(copy.duration, const Duration(milliseconds: 240));
      expect(copy.scaleFrom, 0.94);
      expect(
        transition,
        const BottomShellBodyTransition.slide(
          duration: Duration(milliseconds: 240),
        ),
      );
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

  group('BottomDestination per-destination colors', () {
    test('unselectedColor is stored and propagated via copyWith', () {
      const dest = BottomDestination(
        icon: Icons.home,
        label: 'Home',
        selectedColor: Colors.blue,
        unselectedColor: Colors.grey,
      );

      expect(dest.selectedColor, Colors.blue);
      expect(dest.unselectedColor, Colors.grey);

      final copy = dest.copyWith(unselectedColor: Colors.red);
      expect(copy.unselectedColor, Colors.red);
      expect(copy.selectedColor, Colors.blue);
    });

    test('unselectedColor defaults to null', () {
      const dest = BottomDestination(icon: Icons.home, label: 'Home');
      expect(dest.unselectedColor, isNull);
    });
  });

  group('BranchBadge animated flag', () {
    test('animated defaults to true', () {
      const badge = BranchBadge.count(5);
      expect(badge.animated, isTrue);
    });

    test('can disable animation', () {
      const badge = BranchBadge.count(3, animated: false);
      expect(badge.animated, isFalse);
    });
  });

  group('BottomBarState onLongPress', () {
    test('onLongPress is optional and nullable', () {
      final state = BottomBarState(
        destinations: const [
          BottomDestination(icon: Icons.home, label: 'Home'),
          BottomDestination(icon: Icons.search, label: 'Search'),
        ],
        selectedIndex: 0,
        onSelect: (_) {},
        theme: const BottomShellThemeData(),
        labelBehavior: BottomLabelBehavior.alwaysShow,
        animationStyle: const BottomBarAnimationStyle.smooth(),
      );

      expect(state.onLongPress, isNull);
    });

    test('onLongPress callback is invoked with correct index', () {
      int? pressedIndex;
      final state = BottomBarState(
        destinations: const [
          BottomDestination(icon: Icons.home, label: 'Home'),
          BottomDestination(icon: Icons.search, label: 'Search'),
        ],
        selectedIndex: 0,
        onSelect: (_) {},
        onLongPress: (index) => pressedIndex = index,
        theme: const BottomShellThemeData(),
        labelBehavior: BottomLabelBehavior.alwaysShow,
        animationStyle: const BottomBarAnimationStyle.smooth(),
      );

      state.onLongPress!(1);
      expect(pressedIndex, 1);
    });
  });
}
