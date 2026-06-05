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
