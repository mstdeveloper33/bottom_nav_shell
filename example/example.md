# Examples

## Quick Start — Minimal Setup

```dart
import 'package:bottom_shell_nav/bottom_shell_nav.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BottomShell(
        appearance: BottomShellAppearance.floatingPill(),
        branches: [
          BottomBranch(
            id: 'home',
            destination: const BottomDestination(
              icon: Icons.home_outlined,
              selectedIcon: Icons.home,
              label: 'Home',
            ),
            builder: (_) => const Center(child: Text('Home')),
          ),
          BottomBranch(
            id: 'search',
            destination: const BottomDestination(
              icon: Icons.search,
              label: 'Search',
            ),
            builder: (_) => const Center(child: Text('Search')),
          ),
          BottomBranch(
            id: 'profile',
            destination: const BottomDestination(
              icon: Icons.person_outline,
              selectedIcon: Icons.person,
              label: 'Profile',
            ),
            builder: (_) => const Center(child: Text('Profile')),
          ),
        ],
      ),
    );
  }
}
```

## Appearance Presets

Choose from 12 built-in bar styles. Each is fully customizable:

```dart
// Dark floating bar with neon glow on the selected icon
BottomShellAppearance.glow(
  backgroundColor: const Color(0xFF1A1B26),
  glowRadius: 28,
  glowOpacity: 0.6,
)

// Curved notch with a floating FAB-like selected icon
BottomShellAppearance.curved(
  fabSize: 56,
  fabOffset: -18,
  curveDepth: 30,
)

// Google-style pill tabs
BottomShellAppearance.gNav(
  gap: 10,
  tabBorderRadius: 100,
)

// Minimal dot below the selected icon
BottomShellAppearance.dotIndicator(dotSize: 6)

// Icon slides up, label fades in
BottomShellAppearance.flashy(iconShift: -8)

// Selected item expands into a bubble
BottomShellAppearance.bubble(bubbleBorderRadius: 24)

// Raised center FAB button
BottomShellAppearance.convex(centerIndex: 2, convexSize: 58)

// Background highlight slides between items
BottomShellAppearance.sliding(indicatorBorderRadius: 16)

// Water drop animation on selection
BottomShellAppearance.waterDrop(dropRadius: 22)
```

## go_router Integration

```dart
import 'package:bottom_shell_nav/bottom_shell_nav.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: '/home',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return BottomShell.router(
          navigationShell: navigationShell,
          appearance: BottomShellAppearance.sliding(),
          bodyTransition: const BottomShellBodyTransition.fade(),
          destinations: const [
            BottomDestination(
              icon: Icons.home_outlined,
              selectedIcon: Icons.home,
              label: 'Home',
            ),
            BottomDestination(
              icon: Icons.explore_outlined,
              selectedIcon: Icons.explore,
              label: 'Explore',
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
          GoRoute(
            path: '/home',
            builder: (_, __) => const HomePage(),
            routes: [
              GoRoute(
                path: 'detail/:id',
                builder: (_, state) => DetailPage(id: state.pathParameters['id']!),
              ),
            ],
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/explore', builder: (_, __) => const ExplorePage()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/profile', builder: (_, __) => const ProfilePage()),
        ]),
      ],
    ),
  ],
);
```

## auto_route Integration

```dart
import 'package:auto_route/auto_route.dart';
import 'package:bottom_shell_nav/bottom_shell_nav.dart';

@RoutePage()
class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      routes: const [HomeRoute(), SearchRoute(), ProfileRoute()],
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);

        return BottomShell.autoRoute(
          tabsRouter: tabsRouter,
          child: child,
          appearance: BottomShellAppearance.bubble(),
          bodyTransition: const BottomShellBodyTransition.slide(),
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
            BottomDestination(
              icon: Icons.person_outline,
              selectedIcon: Icons.person,
              label: 'Profile',
            ),
          ],
        );
      },
    );
  }
}
```

## Badges

```dart
BottomBranch(
  id: 'notifications',
  destination: const BottomDestination(
    icon: Icons.notifications_outlined,
    selectedIcon: Icons.notifications,
    label: 'Alerts',
    badge: BranchBadge.count(5),   // Shows "5"
    // badge: BranchBadge.dot(),   // Shows a dot
    // badge: BranchBadge.count(120), // Shows "99+"
  ),
  builder: (_) => const AlertsPage(),
)
```

## Tab Guards (Authentication)

```dart
BottomShell(
  branches: branches,
  selectionGuardPolicy: const SelectionGuardPolicy.showPending(),
  onSelectionGuard: (context, index, destination) async {
    // Block "Profile" tab if not signed in
    if (index == 2 && !AuthService.isSignedIn) {
      return BottomShellGuardDecision.redirect(
        reason: 'login-required',
        metadata: {'target': destination.label},
        redirect: () => showLoginBottomSheet(context),
      );
    }
    return const BottomShellGuardDecision.allow();
  },
)
```

## Theming

Override colors globally via `BottomShellThemeData`:

```dart
BottomShell(
  branches: branches,
  appearance: BottomShellAppearance.flashy(),
  theme: const BottomShellThemeData(
    backgroundColor: Color(0xFF101218),
    selectedItemColor: Colors.amber,
    unselectedItemColor: Colors.white54,
    iconSize: 26,
  ),
)
```

Or wrap with `BottomShellTheme` for inherited theming:

```dart
BottomShellTheme(
  data: const BottomShellThemeData(
    backgroundColor: Colors.black,
    selectedItemColor: Colors.cyanAccent,
  ),
  child: BottomShell(
    branches: branches,
    appearance: BottomShellAppearance.glow(),
  ),
)
```

## Controller Actions

```dart
final controller = BottomShellController();

BottomShell(
  controller: controller,
  branches: branches,
)

// Programmatic navigation
controller.select(2);              // Jump to third tab
await controller.popToRoot(0);     // Pop all routes in first tab
final canPop = controller.canPopBranch(1); // Check if second tab can pop
await controller.reselectCurrent(); // Trigger re-tap behavior
```

## Adaptive Navigation

Automatically switch from bottom bar → NavigationRail → extended rail → drawer
based on screen width:

```dart
BottomShell(
  branches: branches,
  adaptivePolicy: const AdaptiveNavigationPolicy.automatic(
    railBreakpoint: 600,
    extendedRailBreakpoint: 900,
    drawerBreakpoint: 1200,
  ),
  // Optional: custom rail/drawer builders
  railBuilder: (context, state) => MyNavigationRail(state: state),
  drawerBuilder: (context, state) => MyDrawer(state: state),
)
```

## Custom Renderer

Implement `BottomBarRenderer` for full visual control:

```dart
class NeonBarRenderer extends BottomBarRenderer {
  const NeonBarRenderer();

  @override
  Widget build(BuildContext context, BottomBarState state) {
    return Container(
      height: 60,
      color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          for (var i = 0; i < state.destinations.length; i++)
            GestureDetector(
              onTap: () => state.onSelect(i),
              child: Icon(
                i == state.selectedIndex
                    ? state.destinations[i].effectiveSelectedIcon
                    : state.destinations[i].icon,
                color: i == state.selectedIndex
                    ? Colors.cyanAccent
                    : Colors.white38,
              ),
            ),
        ],
      ),
    );
  }
}

// Usage
BottomShell(
  branches: branches,
  appearance: const BottomShellAppearance(
    renderer: NeonBarRenderer(),
  ),
)
```
