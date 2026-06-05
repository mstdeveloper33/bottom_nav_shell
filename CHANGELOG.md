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
