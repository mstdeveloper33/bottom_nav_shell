# bottom_shell_nav — Example App

Interactive demo for all `bottom_shell_nav` features.

## Running

```sh
# Core Navigator mode (default)
flutter run -t lib/main.dart

# go_router mode
flutter run -t lib/go_router_example.dart

# auto_route mode
flutter run -t lib/auto_route_example.dart
```

## Features demonstrated

- **Live style switcher** — change bottom bar appearance at runtime using the
  "Bar Style" dropdown at the top of every page.
- **12 built-in bar presets** — Material, Floating Pill, Cupertino, Curved,
  GNav, Dot Indicator, Water Drop, Flashy, Bubble, Convex, Sliding, Glow.
- **Persistent branch state** — counter stays alive across tab switches.
- **Nested navigation** — tap any list item to push a detail page inside the
  branch navigator; the bottom bar remains visible.
- **Pop-to-root** — re-tap the active tab to pop all nested routes.
- **Badges** — "Alerts" tab displays a count badge.
- **Scroll-to-hide** — scroll a list down and the bar hides; scroll up to
  reveal it again.
- **Body transitions** — a fade transition animates between tab bodies.
- **Adaptive layout** — rotate a tablet or resize the window to see the
  NavigationRail and extended rail layouts.
- **Keyboard shortcuts** — use keyboard to navigate destinations.
- **Haptic feedback** — selection click on destination tap.

## Structure

| File | Mode |
|------|------|
| `lib/main.dart` | Core Navigator with persistent branch navigators |
| `lib/go_router_example.dart` | `go_router` `StatefulShellRoute` integration |
| `lib/auto_route_example.dart` | `auto_route` `AutoTabsRouter` integration |
