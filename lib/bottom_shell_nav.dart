/// A route-aware, persistent and adaptive bottom navigation shell for Flutter.
///
/// Provides persistent tab state, nested navigation, multiple router modes
/// (core Navigator, go_router, auto_route) and 12+ built-in bottom bar
/// renderer presets.
library;

export 'src/appearance/bottom_bar_animation_style.dart';
export 'src/appearance/bottom_label_behavior.dart';
export 'src/appearance/bottom_shell_body_transition.dart';
export 'src/appearance/bottom_shell_appearance.dart';
export 'src/branch/bottom_branch.dart';
export 'src/branch/bottom_destination.dart';
export 'src/branch/branch_badge.dart';
export 'src/guards/bottom_shell_guard_decision.dart';
export 'src/policies/branch_persistence_policy.dart';
export 'src/policies/adaptive_navigation_policy.dart';
export 'src/policies/haptic_feedback_policy.dart';
export 'src/policies/keyboard_navigation_policy.dart';
export 'src/policies/keyboard_policy.dart';
export 'src/policies/re_tap_behavior.dart';
export 'src/policies/safe_area_policy.dart';
export 'src/policies/scroll_to_hide_policy.dart';
export 'src/policies/scroll_to_top_policy.dart';
export 'src/policies/selection_guard_policy.dart';
export 'src/renderers/bottom_bar_renderer.dart';
export 'src/renderers/bubble_bottom_bar_renderer.dart';
export 'src/renderers/convex_bottom_bar_renderer.dart';
export 'src/renderers/curved_bottom_bar_renderer.dart';
export 'src/renderers/cupertino_bottom_bar_renderer.dart';
export 'src/renderers/dot_indicator_bottom_bar_renderer.dart';
export 'src/renderers/flashy_bottom_bar_renderer.dart';
export 'src/renderers/floating_pill_bottom_bar_renderer.dart';
export 'src/renderers/glow_bottom_bar_renderer.dart';
export 'src/renderers/gnav_bottom_bar_renderer.dart';
export 'src/renderers/material_bottom_bar_renderer.dart';
export 'src/renderers/sliding_bottom_bar_renderer.dart';
export 'src/renderers/water_drop_bottom_bar_renderer.dart';
export 'src/routes/bottom_shell_route_event.dart';
export 'src/scroll/scroll_to_top_registry.dart';
export 'src/shell/bottom_shell.dart';
export 'src/shell/bottom_shell_visibility_controller.dart';
export 'src/theme/bottom_shell_theme.dart';
export 'src/theme/bottom_shell_theme_data.dart';
