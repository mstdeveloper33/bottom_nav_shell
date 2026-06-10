## 0.4.3

### Fixed

- Screenshots are now correctly included in the pub archive (removed `screenshots/` from `.pubignore`).

## 0.4.2

### Docs

- Added neumorphic bottom bar renderer.
- Added screenshots gallery to README and pubspec.yaml for pub.dev.

## 0.4.1

### Fixed

- `onLongPress` now works in all 13 built-in renderers (was previously only
  active in Material and FloatingPill).
- `destination.unselectedColor` is now respected by all renderers.
- Glow renderer no longer ignores `theme.unselectedItemColor` (was hardcoded
  to `Colors.white60`).
- Curved and Sliding renderers are now RTL-safe (previously used hardcoded
  left positioning).
- CupertinoBottomBarRenderer supports long-press via a wrapping
  GestureDetector.
- Added library-level documentation comment to the barrel export for better
  pub.dev scoring.
- Expanded test coverage for `onLongPress`, `unselectedColor`, badge animated
  flag and `BottomBarState` constructor.

## 0.4.0

### Added

- Animated badge transitions — badge bounces when count or dot state changes.
- Per-destination `unselectedColor` — each tab can carry its own inactive
  color override (optional, falls back to theme when null).
- `onDestinationLongPress` callback on `BottomShell` and `onLongPress` in
  `BottomBarState` — long-press a destination to trigger custom actions
  (e.g. show a bottom sheet or tooltip).
- RTL-safe badge positioning via `PositionedDirectional`.

## 0.3.1

### Improved

- Expanded README with per-renderer parameter documentation and quick-start
  example.
- Added rich `example/example.md` for the pub.dev Example tab covering
  presets, go_router, auto_route, badges, guards, theming, controller,
  adaptive navigation and custom renderer usage.

## 0.3.0

### Added

- New built-in bottom bar renderer presets: `curved`, `gNav`,
  `dotIndicator`, `waterDrop`, `flashy`, `bubble`, `convex`, `sliding`
  and `glow`.
- Public renderer classes for all new presets, available from the package
  barrel export.
- Glow renderer surface customization through `backgroundColor`,
  `surfaceColor` and `surfacePadding`.
- Example app style switcher to preview all built-in bottom bar presets in a
  single demo app.

### Changed

- Curved renderer visuals were refined with smoother notch motion and a more
  configurable selected action button.
- Convex renderer visuals were simplified to a cleaner FAB-centered layout.

## 0.2.0

### Added

- `BottomShellGuardDecision` and `onSelectionGuard` for rich guard decisions,
  block reasons, metadata and redirect callbacks.
- `BottomShellVisibilityController` for programmatic compact bottom bar
  visibility control.
- `AdaptiveNavigationPolicy.layoutForWidth` and `BottomAdaptiveLayout` for
  explicit adaptive layout resolution.
- `BottomShellRouteEvent` and `onBranchRouteEvent` for detailed core branch
  navigator events.
- `BottomShellBodyTransition` for branch body fade, slide, scale and custom
  transition builders.
- `selectedFlex` and `unselectedFlex` options to
  `BottomShellAppearance.floatingPill` and `FloatingPillBottomBarRenderer`.

### Changed

- Floating Pill renderer now gives the selected destination more horizontal
  space by default, reducing label truncation on compact mobile widths.

## 0.1.0

### Added

- Initial `bottom_shell_nav` package identity.
- Persistent `BottomShell` core mode with branch navigators.
- Same-package `go_router` mode through `BottomShell.router`.
- Material and Floating Pill renderers.
- Badge, policy, appearance, theme and controller APIs.
- Core and `go_router` example apps.
- Pub.dev-ready README with core, router, badge, policy and custom bar usage.
- Adaptive NavigationRail policy.
- Scroll-to-hide and scroll-to-top policies.
- Disabled destinations and async tab guard support.
- Cupertino renderer.
- Same-package `auto_route` mode through `BottomShell.autoRoute`.
- Selected tab state restoration and branch navigator restoration ids.
- Public controller actions: `select`, `reselectCurrent`, `popToRoot` and
  `canPopBranch`.
- Custom adaptive `railBuilder` and `drawerBuilder`.
- Keyboard destination shortcuts.
- Optional haptic feedback policy.
- Async guard pending-state policy and blocked-selection callback.
- Branch entered/exited/reactivated lifecycle callbacks.
- Core branch route-change callback.
- `ScrollToTopRegistry` for branch-specific scroll controllers.
- Extended NavigationRail breakpoint support.
