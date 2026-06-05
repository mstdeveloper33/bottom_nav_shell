# bottom_shell_nav

Not another animated bottom bar. A modern navigation shell for real Flutter apps.

`bottom_shell_nav` gives Flutter apps a persistent bottom navigation shell:
tab state is preserved, each branch can own its own navigation stack, detail
routes keep the bottom bar visible, and the same renderer API works in core
Navigator mode, `go_router` mode or `auto_route` mode.

## Why this package?

Most bottom bar packages only draw the bar. Real apps also need tab state,
nested navigation, pop-to-root behavior, SafeArea handling, badges and a clean
way to work with routers.

`bottom_shell_nav` focuses on that complete shell:

- One persistent `Navigator` per branch in core mode.
- Same-package `go_router` support through `BottomShell.router`.
- Same-package `auto_route` support through `BottomShell.autoRoute`.
- Lazy branch loading with `IndexedStack` persistence.
- Re-tap behavior for pop-to-root.
- Selected-tab restoration and branch navigator restoration scopes.
- Public controller actions for select, reselect, can-pop and pop-to-root.
- Adaptive NavigationRail, extended rail and desktop drawer layouts.
- Material, Floating Pill and Cupertino renderers.
- Scroll-to-hide, root scroll-to-top and custom scroll registry behavior.
- Programmatic bottom bar visibility control.
- Disabled destinations, async tab guards and pending guard UX.
- Rich tab guard decisions with redirect callbacks and metadata.
- Keyboard destination shortcuts and optional haptic feedback.
- Branch lifecycle and detailed route-event callbacks for analytics.
- Badges, tooltips, semantics and 48x48 touch targets.
- Custom bottom bar, rail and drawer builders for full control.

## Installation

```yaml
dependencies:
  bottom_shell_nav: ^0.2.0
```

## Core Usage

Use `BottomShell` when you want the package to create and preserve one nested
`Navigator` per tab.

```dart
import 'package:bottom_shell_nav/bottom_shell_nav.dart';
import 'package:flutter/material.dart';

BottomShell(
  appearance: BottomShellAppearance.floatingPill(),
  adaptivePolicy: const AdaptiveNavigationPolicy.automatic(),
  branches: [
    BottomBranch(
      id: 'home',
      destination: const BottomDestination(
        icon: Icons.home_outlined,
        selectedIcon: Icons.home,
        label: 'Home',
      ),
      builder: (_) => const HomePage(),
    ),
    BottomBranch(
      id: 'search',
      destination: const BottomDestination(
        icon: Icons.search_outlined,
        selectedIcon: Icons.search,
        label: 'Search',
      ),
      builder: (_) => const SearchPage(),
    ),
  ],
)
```

Inside a branch page, push normally:

```dart
Navigator.of(context).push(
  MaterialPageRoute<void>(
    builder: (_) => const DetailPage(),
  ),
);
```

The route is pushed inside the active branch navigator, so the bottom bar stays
visible and tab state is preserved.

## GoRouter Usage

Use `BottomShell.router` inside `StatefulShellRoute.indexedStack` when
`go_router` owns your branch stacks.

```dart
StatefulShellRoute.indexedStack(
  builder: (context, state, navigationShell) {
    return BottomShell.router(
      navigationShell: navigationShell,
      appearance: BottomShellAppearance.floatingPill(),
      destinations: const [
        BottomDestination(
          icon: Icons.home_outlined,
          selectedIcon: Icons.home,
          label: 'Home',
        ),
        BottomDestination(
          icon: Icons.person_outline,
          selectedIcon: Icons.person,
          label: 'Profile',
        ),
      ],
    );
  },
  branches: [
    StatefulShellBranch(routes: [
      GoRoute(path: '/home', builder: (_, _) => const HomePage()),
    ]),
    StatefulShellBranch(routes: [
      GoRoute(path: '/profile', builder: (_, _) => const ProfilePage()),
    ]),
  ],
)
```

## AutoRoute Usage

Use `BottomShell.autoRoute` inside an `AutoTabsRouter` builder.

```dart
AutoTabsRouter(
  routes: const [
    HomeRoute(),
    SearchRoute(),
  ],
  builder: (context, child) {
    final tabsRouter = AutoTabsRouter.of(context);

    return BottomShell.autoRoute(
      tabsRouter: tabsRouter,
      child: child,
      appearance: BottomShellAppearance.floatingPill(),
      destinations: const [
        BottomDestination(
          icon: Icons.home_outlined,
          selectedIcon: Icons.home,
          label: 'Home',
        ),
        BottomDestination(
          icon: Icons.search_outlined,
          selectedIcon: Icons.search,
          label: 'Search',
        ),
      ],
    );
  },
)
```

## Appearance

Material style is the default:

```dart
BottomShell(
  branches: branches,
  appearance: const BottomShellAppearance.material(),
)
```

Floating Pill is the modern preset:

```dart
BottomShell(
  branches: branches,
  appearance: BottomShellAppearance.floatingPill(
    height: 76,
    borderRadius: 34,
    margin: const EdgeInsets.fromLTRB(20, 0, 20, 14),
    selectedFlex: 2,
    unselectedFlex: 1,
  ),
)
```

Cupertino is available for iOS-style apps:

```dart
BottomShell(
  branches: branches,
  appearance: const BottomShellAppearance.cupertino(),
)
```

Labels can be controlled with `BottomLabelBehavior`:

```dart
const BottomShellAppearance(
  renderer: MaterialBottomBarRenderer(),
  labelBehavior: BottomLabelBehavior.onlySelected,
)
```

## Badges

```dart
const BottomDestination(
  icon: Icons.notifications_outlined,
  selectedIcon: Icons.notifications,
  label: 'Alerts',
  badge: BranchBadge.count(12),
)
```

Use `BranchBadge.dot()` for a dot badge. Counts above 99 render as `99+`.

## Adaptive Navigation

Switch from bottom bar to `NavigationRail`, extended rail and drawer-style
desktop navigation on larger screens:

```dart
BottomShell(
  branches: branches,
  adaptivePolicy: const AdaptiveNavigationPolicy.automatic(
    railBreakpoint: 600,
    extendedRailBreakpoint: 840,
    drawerBreakpoint: 1200,
  ),
)
```

Customize adaptive surfaces without replacing the shell:

```dart
BottomShell(
  branches: branches,
  railBuilder: (context, state) => MyRail(state: state),
  drawerBuilder: (context, state) => MyDrawer(state: state),
)
```

Resolve adaptive layouts yourself when coordinating desktop UI:

```dart
final layout = AdaptiveNavigationPolicy.automatic().layoutForWidth(width);
```

## Scroll Behavior

Hide the bottom bar while scrolling down and show it again when scrolling up:

```dart
BottomShell(
  branches: branches,
  scrollToHidePolicy: const ScrollToHidePolicy.enabled(),
)
```

Re-tapping the active root branch scrolls its primary scrollable back to top:

```dart
BottomShell(
  branches: branches,
  scrollToTopPolicy: const ScrollToTopPolicy.enabled(),
)
```

For complex pages, register a branch-specific scroll controller:

```dart
final scrollRegistry = ScrollToTopRegistry();

BottomShell(
  branches: branches,
  scrollToTopRegistry: scrollRegistry,
);

scrollRegistry.register(0, homeScrollController);
```

Control compact bottom bar visibility from nested scroll coordinators or
external UI:

```dart
final visibilityController = BottomShellVisibilityController();

BottomShell(
  branches: branches,
  navigationVisibilityController: visibilityController,
);

visibilityController.hide();
visibilityController.show();
```

## Guards and Disabled Tabs

Disable a destination:

```dart
const BottomDestination(
  icon: Icons.lock_outline,
  label: 'Locked',
  enabled: false,
)
```

Block tab selection asynchronously:

```dart
BottomShell(
  branches: branches,
  selectionGuardPolicy: const SelectionGuardPolicy.showPending(),
  onBeforeSelect: (context, index, destination) async {
    if (destination.label == 'Profile' && !isSignedIn) {
      showLoginSheet(context);
      return false;
    }
    return true;
  },
)
```

Use rich guard decisions when you need redirect handling or analytics metadata:

```dart
BottomShell(
  branches: branches,
  onSelectionGuard: (context, index, destination) async {
    if (destination.label == 'Profile' && !isSignedIn) {
      return BottomShellGuardDecision.redirect(
        reason: 'login-required',
        metadata: {'target': destination.label},
        redirect: () => showLoginSheet(context),
      );
    }
    return const BottomShellGuardDecision.allow();
  },
)
```

## Controller Actions

Use a controller when another widget needs to drive the shell:

```dart
final controller = BottomShellController();

BottomShell(
  controller: controller,
  branches: branches,
)

controller.select(1);
await controller.popToRoot(0);
final canPopHome = controller.canPopBranch(0);
await controller.reselectCurrent();
```

## State Restoration

Restore the selected tab and branch navigators:

```dart
MaterialApp(
  restorationScopeId: 'app',
  home: BottomShell(
    restorationScopeId: 'main_shell',
    branches: [
      BottomBranch(
        id: 'home',
        restorationScopeId: 'home_branch',
        destination: homeDestination,
        builder: (_) => const HomePage(),
      ),
      BottomBranch(
        id: 'search',
        restorationScopeId: 'search_branch',
        destination: searchDestination,
        builder: (_) => const SearchPage(),
      ),
    ],
  ),
)
```

## Keyboard and Haptics

Keyboard shortcuts are enabled by default for destination changes. Haptics are
opt-in:

```dart
BottomShell(
  branches: branches,
  keyboardNavigationPolicy: const KeyboardNavigationPolicy.enabled(),
  hapticFeedbackPolicy: const HapticFeedbackPolicy.selectionClick(),
)
```

## Lifecycle and Routes

Observe branch lifecycle and core-mode route changes:

```dart
BottomShell(
  branches: branches,
  onBranchEntered: (index, destination) => logTabView(destination.label),
  onBranchExited: (index, destination) => logTabExit(destination.label),
  onBranchBecameActiveAgain: (index, destination) => refreshIfNeeded(index),
  onBranchRouteChanged: (index, route) => logRoute(route?.settings.name),
  onBranchRouteEvent: (event) => logRouteEvent(event.type, event.routeName),
)
```

## Custom Bar

`barBuilder` receives the selected index, pending guard state, destinations and
selection callback.

```dart
BottomShell(
  branches: branches,
  barBuilder: (context, state) {
    return MyBottomBar(
      selectedIndex: state.selectedIndex,
      destinations: state.destinations,
      onSelect: state.onSelect,
    );
  },
)
```

## Policies

The defaults are tuned for app navigation:

```dart
BottomShell(
  branches: branches,
  persistence: const BranchPersistencePolicy.indexedStack(
    lazyLoadBranches: true,
  ),
  reTapBehavior: const ReTapBehavior.popToRoot(),
  safeAreaPolicy: const SafeAreaPolicy(),
  keyboardPolicy: const KeyboardPolicy.hideNavigationBar(),
  adaptivePolicy: const AdaptiveNavigationPolicy.automatic(),
  keyboardNavigationPolicy: const KeyboardNavigationPolicy.enabled(),
  hapticFeedbackPolicy: const HapticFeedbackPolicy.disabled(),
  selectionGuardPolicy: const SelectionGuardPolicy.showPending(),
)
```

## Example

Run the core Navigator demo:

```sh
cd example
flutter run -t lib/main.dart
```

Run the `go_router` demo:

```sh
cd example
flutter run -t lib/go_router_example.dart
```

Run the `auto_route` demo:

```sh
cd example
flutter run -t lib/auto_route_example.dart
```

## Roadmap

- Glass renderer only after performance and platform testing.
- Adaptive navigation rail/drawer refinements.
- Cupertino route-aware renderer improvements.

## License

MIT
