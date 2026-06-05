import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../appearance/bottom_bar_animation_style.dart';
import '../appearance/bottom_shell_body_transition.dart';
import '../appearance/bottom_shell_appearance.dart';
import '../branch/bottom_branch.dart';
import '../branch/bottom_destination.dart';
import '../guards/bottom_shell_guard_decision.dart';
import '../policies/adaptive_navigation_policy.dart';
import '../policies/branch_persistence_policy.dart';
import '../policies/haptic_feedback_policy.dart';
import '../policies/keyboard_navigation_policy.dart';
import '../policies/keyboard_policy.dart';
import '../policies/re_tap_behavior.dart';
import '../policies/safe_area_policy.dart';
import '../policies/scroll_to_hide_policy.dart';
import '../policies/scroll_to_top_policy.dart';
import '../policies/selection_guard_policy.dart';
import '../widgets/branch_badge_widget.dart';
import '../renderers/bottom_bar_renderer.dart';
import '../routes/bottom_shell_route_event.dart';
import '../scroll/scroll_to_top_registry.dart';
import '../theme/bottom_shell_theme.dart';
import '../theme/bottom_shell_theme_data.dart';
import 'bottom_shell_visibility_controller.dart';

part 'bottom_shell_controller.dart';

/// Called before selecting a destination.
typedef BottomShellCanSelect =
    FutureOr<bool> Function(
      BuildContext context,
      int index,
      BottomDestination destination,
    );

/// Called before selecting a destination with a rich decision result.
typedef BottomShellSelectionGuard =
    FutureOr<BottomShellGuardDecision> Function(
      BuildContext context,
      int index,
      BottomDestination destination,
    );

/// Called when a destination lifecycle or analytics event occurs.
typedef BottomShellDestinationCallback =
    void Function(int index, BottomDestination destination);

/// Called when a branch navigator route changes in core mode.
typedef BottomShellRouteChangedCallback =
    void Function(int index, Route<dynamic>? route);

/// Called when a detailed core branch route event occurs.
typedef BottomShellRouteEventCallback =
    void Function(BottomShellRouteEvent event);

/// Builds a custom adaptive rail or drawer navigation surface.
typedef BottomAdaptiveNavigationBuilder =
    Widget Function(BuildContext context, BottomAdaptiveNavigationState state);

/// Adaptive navigation surface kind.
enum BottomAdaptiveNavigationType {
  /// NavigationRail layout.
  rail,

  /// Drawer-style side panel layout.
  drawer,
}

/// State passed to custom adaptive navigation builders.
@immutable
class BottomAdaptiveNavigationState {
  /// Creates adaptive navigation builder state.
  const BottomAdaptiveNavigationState({
    required this.type,
    required this.destinations,
    required this.selectedIndex,
    required this.onSelect,
    required this.theme,
    required this.extended,
    required this.width,
    this.pendingIndex,
    this.disableDestinationsWhilePending = false,
  });

  /// Navigation surface kind.
  final BottomAdaptiveNavigationType type;

  /// Destinations to render.
  final List<BottomDestination> destinations;

  /// Current selected destination index.
  final int selectedIndex;

  /// Selects a destination.
  final BottomBarSelectCallback onSelect;

  /// Theme tokens.
  final BottomShellThemeData theme;

  /// Whether the rail should render in extended mode.
  final bool extended;

  /// Suggested navigation surface width.
  final double width;

  /// Destination index currently waiting for an asynchronous guard.
  final int? pendingIndex;

  /// Whether destination taps should be blocked while [pendingIndex] is set.
  final bool disableDestinationsWhilePending;

  /// Whether [index] is waiting for an asynchronous guard.
  bool isPending(int index) => pendingIndex == index;

  /// Whether [index] can currently be selected by a renderer.
  bool canSelect(int index) {
    if (!destinations[index].enabled) {
      return false;
    }
    return !disableDestinationsWhilePending || pendingIndex == null;
  }
}

enum _BottomShellMode { core, router, autoRoute }

/// A persistent bottom navigation shell for real Flutter apps.
class BottomShell extends StatefulWidget {
  /// Creates a router-agnostic shell with one nested Navigator per branch.
  const BottomShell({
    required List<BottomBranch> branches,
    this.controller,
    this.initialIndex = 0,
    this.persistence = const BranchPersistencePolicy.indexedStack(),
    this.reTapBehavior = const ReTapBehavior.popToRoot(),
    this.safeAreaPolicy = const SafeAreaPolicy(),
    this.keyboardPolicy = const KeyboardPolicy.hideNavigationBar(),
    this.adaptivePolicy = const AdaptiveNavigationPolicy.disabled(),
    this.scrollToHidePolicy = const ScrollToHidePolicy.disabled(),
    this.scrollToTopPolicy = const ScrollToTopPolicy.enabled(),
    this.bodyTransition = const BottomShellBodyTransition.none(),
    this.keyboardNavigationPolicy = const KeyboardNavigationPolicy.enabled(),
    this.hapticFeedbackPolicy = const HapticFeedbackPolicy.disabled(),
    this.selectionGuardPolicy = const SelectionGuardPolicy.showPending(),
    this.scrollToTopRegistry,
    this.navigationVisibilityController,
    this.appearance = const BottomShellAppearance.material(),
    this.theme,
    this.barBuilder,
    this.railBuilder,
    this.drawerBuilder,
    this.restorationScopeId,
    this.onSelectionGuard,
    this.onBeforeSelect,
    this.onSelectionBlocked,
    this.onIndexChanged,
    this.onBranchLoaded,
    this.onBranchSelected,
    this.onBranchReselected,
    this.onBranchPoppedToRoot,
    this.onBranchEntered,
    this.onBranchExited,
    this.onBranchBecameActiveAgain,
    this.onBranchRouteChanged,
    this.onBranchRouteEvent,
    super.key,
  }) : assert(
         branches.length >= 2 && branches.length <= 5,
         'BottomShell requires between 2 and 5 branches.',
       ),
       assert(initialIndex >= 0, 'initialIndex must be non-negative.'),
       assert(
         initialIndex < branches.length,
         'initialIndex must be smaller than branches.length.',
       ),
       _mode = _BottomShellMode.core,
       _branches = branches,
       _navigationShell = null,
       _tabsRouter = null,
       _routerChild = null,
       _destinations = null;

  /// Creates a go_router-backed shell using StatefulNavigationShell.
  const BottomShell.router({
    required StatefulNavigationShell navigationShell,
    required List<BottomDestination> destinations,
    this.persistence = const BranchPersistencePolicy.indexedStack(),
    this.reTapBehavior = const ReTapBehavior.popToRoot(),
    this.safeAreaPolicy = const SafeAreaPolicy(),
    this.keyboardPolicy = const KeyboardPolicy.hideNavigationBar(),
    this.adaptivePolicy = const AdaptiveNavigationPolicy.disabled(),
    this.scrollToHidePolicy = const ScrollToHidePolicy.disabled(),
    this.scrollToTopPolicy = const ScrollToTopPolicy.enabled(),
    this.bodyTransition = const BottomShellBodyTransition.none(),
    this.keyboardNavigationPolicy = const KeyboardNavigationPolicy.enabled(),
    this.hapticFeedbackPolicy = const HapticFeedbackPolicy.disabled(),
    this.selectionGuardPolicy = const SelectionGuardPolicy.showPending(),
    this.scrollToTopRegistry,
    this.navigationVisibilityController,
    this.appearance = const BottomShellAppearance.material(),
    this.theme,
    this.barBuilder,
    this.railBuilder,
    this.drawerBuilder,
    this.restorationScopeId,
    this.onSelectionGuard,
    this.onBeforeSelect,
    this.onSelectionBlocked,
    this.onIndexChanged,
    this.onBranchLoaded,
    this.onBranchSelected,
    this.onBranchReselected,
    this.onBranchPoppedToRoot,
    this.onBranchEntered,
    this.onBranchExited,
    this.onBranchBecameActiveAgain,
    this.onBranchRouteChanged,
    this.onBranchRouteEvent,
    super.key,
  }) : assert(
         destinations.length >= 2 && destinations.length <= 5,
         'BottomShell.router requires between 2 and 5 destinations.',
       ),
       controller = null,
       initialIndex = 0,
       _mode = _BottomShellMode.router,
       _branches = null,
       _navigationShell = navigationShell,
       _tabsRouter = null,
       _routerChild = null,
       _destinations = destinations;

  /// Creates an auto_route-backed shell using TabsRouter.
  const BottomShell.autoRoute({
    required TabsRouter tabsRouter,
    required Widget child,
    required List<BottomDestination> destinations,
    this.persistence = const BranchPersistencePolicy.indexedStack(),
    this.reTapBehavior = const ReTapBehavior.popToRoot(),
    this.safeAreaPolicy = const SafeAreaPolicy(),
    this.keyboardPolicy = const KeyboardPolicy.hideNavigationBar(),
    this.adaptivePolicy = const AdaptiveNavigationPolicy.disabled(),
    this.scrollToHidePolicy = const ScrollToHidePolicy.disabled(),
    this.scrollToTopPolicy = const ScrollToTopPolicy.enabled(),
    this.bodyTransition = const BottomShellBodyTransition.none(),
    this.keyboardNavigationPolicy = const KeyboardNavigationPolicy.enabled(),
    this.hapticFeedbackPolicy = const HapticFeedbackPolicy.disabled(),
    this.selectionGuardPolicy = const SelectionGuardPolicy.showPending(),
    this.scrollToTopRegistry,
    this.navigationVisibilityController,
    this.appearance = const BottomShellAppearance.material(),
    this.theme,
    this.barBuilder,
    this.railBuilder,
    this.drawerBuilder,
    this.restorationScopeId,
    this.onSelectionGuard,
    this.onBeforeSelect,
    this.onSelectionBlocked,
    this.onIndexChanged,
    this.onBranchLoaded,
    this.onBranchSelected,
    this.onBranchReselected,
    this.onBranchPoppedToRoot,
    this.onBranchEntered,
    this.onBranchExited,
    this.onBranchBecameActiveAgain,
    this.onBranchRouteChanged,
    this.onBranchRouteEvent,
    super.key,
  }) : assert(
         destinations.length >= 2 && destinations.length <= 5,
         'BottomShell.autoRoute requires between 2 and 5 destinations.',
       ),
       controller = null,
       initialIndex = 0,
       _mode = _BottomShellMode.autoRoute,
       _branches = null,
       _navigationShell = null,
       _tabsRouter = tabsRouter,
       _routerChild = child,
       _destinations = destinations;

  /// Optional selected-index controller for core mode.
  final BottomShellController? controller;

  /// Initial selected branch index for uncontrolled core mode.
  final int initialIndex;

  /// Branch state persistence policy.
  final BranchPersistencePolicy persistence;

  /// Behavior used when tapping the active destination again.
  final ReTapBehavior reTapBehavior;

  /// SafeArea policy for the bottom bar.
  final SafeAreaPolicy safeAreaPolicy;

  /// Keyboard behavior policy.
  final KeyboardPolicy keyboardPolicy;

  /// Large-screen adaptive navigation policy.
  final AdaptiveNavigationPolicy adaptivePolicy;

  /// Scroll-to-hide policy for compact bottom bar mode.
  final ScrollToHidePolicy scrollToHidePolicy;

  /// Scroll-to-top policy used when re-tapping the active root branch.
  final ScrollToTopPolicy scrollToTopPolicy;

  /// Body transition used when the selected branch changes.
  final BottomShellBodyTransition bodyTransition;

  /// Keyboard shortcuts for destination navigation.
  final KeyboardNavigationPolicy keyboardNavigationPolicy;

  /// Haptic feedback behavior for successful destination selection.
  final HapticFeedbackPolicy hapticFeedbackPolicy;

  /// UX behavior while asynchronous guards are pending.
  final SelectionGuardPolicy selectionGuardPolicy;

  /// Optional branch-specific scroll-to-top registry.
  final ScrollToTopRegistry? scrollToTopRegistry;

  /// Optional controller for compact bottom navigation visibility.
  final BottomShellVisibilityController? navigationVisibilityController;

  /// Visual renderer appearance.
  final BottomShellAppearance appearance;

  /// Optional theme override.
  final BottomShellThemeData? theme;

  /// Optional custom bar builder.
  final BottomBarBuilder? barBuilder;

  /// Optional custom rail builder for adaptive layouts.
  final BottomAdaptiveNavigationBuilder? railBuilder;

  /// Optional custom drawer builder for adaptive layouts.
  final BottomAdaptiveNavigationBuilder? drawerBuilder;

  /// Restoration id used to preserve the selected branch.
  final String? restorationScopeId;

  /// Called before selecting a new destination with a rich decision result.
  ///
  /// When provided, this takes precedence over [onBeforeSelect].
  final BottomShellSelectionGuard? onSelectionGuard;

  /// Called before selecting a new destination. Return false to block.
  final BottomShellCanSelect? onBeforeSelect;

  /// Called when [onBeforeSelect] blocks a destination.
  final BottomShellDestinationCallback? onSelectionBlocked;

  /// Called when the selected index changes.
  final ValueChanged<int>? onIndexChanged;

  /// Called when a core branch is built for the first time.
  final BottomShellDestinationCallback? onBranchLoaded;

  /// Called when a destination is selected successfully.
  final BottomShellDestinationCallback? onBranchSelected;

  /// Called when the active destination is tapped again.
  final BottomShellDestinationCallback? onBranchReselected;

  /// Called when a re-tap pops a branch back to root.
  final BottomShellDestinationCallback? onBranchPoppedToRoot;

  /// Called when a branch becomes active.
  final BottomShellDestinationCallback? onBranchEntered;

  /// Called when a branch stops being active.
  final BottomShellDestinationCallback? onBranchExited;

  /// Called when a previously visited branch becomes active again.
  final BottomShellDestinationCallback? onBranchBecameActiveAgain;

  /// Called when a core branch navigator changes route.
  final BottomShellRouteChangedCallback? onBranchRouteChanged;

  /// Called when a detailed core branch navigator route event occurs.
  final BottomShellRouteEventCallback? onBranchRouteEvent;

  final _BottomShellMode _mode;
  final List<BottomBranch>? _branches;
  final StatefulNavigationShell? _navigationShell;
  final TabsRouter? _tabsRouter;
  final Widget? _routerChild;
  final List<BottomDestination>? _destinations;

  @override
  State<BottomShell> createState() => _BottomShellState();
}

class _BottomShellState extends State<BottomShell> with RestorationMixin {
  late BottomShellController _controller;
  late bool _ownsController;
  late _BottomShellControllerDelegate _controllerDelegate;
  late final RestorableInt _restoredIndex;
  var _navigatorKeys = <GlobalKey<NavigatorState>>[];
  var _navigatorObservers = <NavigatorObserver>[];
  var _scrollControllers = <ScrollController>[];
  final _loadedIndexes = <int>{};
  final _visitedIndexes = <int>{};
  late int _lastSelectedIndex;
  late int _previousTransitionIndex;
  var _transitionSerial = 0;
  var _isNavigationBarVisible = true;
  var _restorationRegistered = false;
  int? _pendingIndex;

  @override
  String? get restorationId => widget.restorationScopeId;

  bool get _isRouterMode => widget._mode == _BottomShellMode.router;

  bool get _isAutoRouteMode => widget._mode == _BottomShellMode.autoRoute;

  bool get _usesExternalRouter => _isRouterMode || _isAutoRouteMode;

  List<BottomBranch> get _branches => widget._branches ?? const [];

  StatefulNavigationShell get _navigationShell => widget._navigationShell!;

  TabsRouter get _tabsRouter => widget._tabsRouter!;

  List<BottomDestination> get _destinations {
    if (_usesExternalRouter) {
      return widget._destinations!;
    }
    return _branches.map((branch) => branch.destination).toList();
  }

  int get _currentIndex {
    if (_isRouterMode) {
      return _navigationShell.currentIndex;
    }
    if (_isAutoRouteMode) {
      return _tabsRouter.activeIndex;
    }
    return _controller.selectedIndex;
  }

  bool get _activeBranchCanPop {
    if (_usesExternalRouter || _navigatorKeys.isEmpty) {
      return false;
    }
    return _navigatorKeys[_currentIndex].currentState?.canPop() ?? false;
  }

  bool get _shouldHandleBack => _activeBranchCanPop || _currentIndex != 0;

  @override
  void initState() {
    super.initState();
    _restoredIndex = RestorableInt(widget.initialIndex);
    _ownsController = widget.controller == null;
    _controller =
        widget.controller ??
        BottomShellController(initialIndex: widget.initialIndex);
    _controllerDelegate = _BottomShellControllerDelegate(
      reselectCurrent: () => _selectIndex(_currentIndex),
      popToRoot: _popBranchToRoot,
      canPopBranch: _canPopBranch,
    );
    _lastSelectedIndex = _currentIndex;
    _previousTransitionIndex = _currentIndex;

    if (_isAutoRouteMode) {
      _tabsRouter.addListener(_handleTabsRouterChanged);
    }

    if (!_usesExternalRouter) {
      assert(
        _controller.selectedIndex < _branches.length,
        'controller.selectedIndex must be smaller than branches.length.',
      );
      _syncNavigatorKeys();
      _syncScrollControllers();
      _initializeLoadedBranches();
      _controller.addListener(_handleControllerChanged);
      _controller._bind(_controllerDelegate);
    }
    widget.navigationVisibilityController?.addListener(
      _handleVisibilityControllerChanged,
    );
    final visibilityController = widget.navigationVisibilityController;
    if (visibilityController != null) {
      _isNavigationBarVisible = visibilityController.isVisible;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _notifyInitialBranchEntered();
      }
    });
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_restoredIndex, 'selected_index');
    _restorationRegistered = true;
    if (_usesExternalRouter || !_ownsController) {
      return;
    }
    final restoredIndex = _restoredIndex.value;
    if (restoredIndex >= 0 && restoredIndex < _branches.length) {
      _controller.selectIndex(restoredIndex);
    }
  }

  @override
  void didUpdateWidget(BottomShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_isAutoRouteMode && oldWidget._tabsRouter != widget._tabsRouter) {
      oldWidget._tabsRouter?.removeListener(_handleTabsRouterChanged);
      _tabsRouter.addListener(_handleTabsRouterChanged);
      _lastSelectedIndex = _currentIndex;
    }

    if (oldWidget.navigationVisibilityController !=
        widget.navigationVisibilityController) {
      oldWidget.navigationVisibilityController?.removeListener(
        _handleVisibilityControllerChanged,
      );
      widget.navigationVisibilityController?.addListener(
        _handleVisibilityControllerChanged,
      );
      final visibilityController = widget.navigationVisibilityController;
      if (visibilityController != null) {
        _isNavigationBarVisible = visibilityController.isVisible;
      }
    }

    if (_isRouterMode && _currentIndex != _lastSelectedIndex) {
      _notifySelectedIndexChanged(_currentIndex);
    }

    if (_usesExternalRouter) {
      return;
    }

    if (oldWidget.controller != widget.controller) {
      if (!_ownsController) {
        oldWidget.controller?.removeListener(_handleControllerChanged);
        oldWidget.controller?._unbind(_controllerDelegate);
      }
      if (_ownsController) {
        _controller._unbind(_controllerDelegate);
        _controller.dispose();
      }
      _ownsController = widget.controller == null;
      _controller =
          widget.controller ??
          BottomShellController(initialIndex: widget.initialIndex);
      _controller.addListener(_handleControllerChanged);
      _controller._bind(_controllerDelegate);
    }

    if (oldWidget._branches != widget._branches) {
      _syncNavigatorKeys();
      _syncScrollControllers();
    }
    _initializeLoadedBranches();
  }

  @override
  void dispose() {
    if (_isAutoRouteMode) {
      _tabsRouter.removeListener(_handleTabsRouterChanged);
    }
    widget.navigationVisibilityController?.removeListener(
      _handleVisibilityControllerChanged,
    );
    if (!_usesExternalRouter) {
      _controller.removeListener(_handleControllerChanged);
      _controller._unbind(_controllerDelegate);
      if (_ownsController) {
        _controller.dispose();
      }
      for (final controller in _scrollControllers) {
        controller.dispose();
      }
    }
    _restoredIndex.dispose();
    super.dispose();
  }

  void _handleVisibilityControllerChanged() {
    final controller = widget.navigationVisibilityController;
    if (controller == null || _isNavigationBarVisible == controller.isVisible) {
      return;
    }
    setState(() => _isNavigationBarVisible = controller.isVisible);
  }

  void _syncNavigatorKeys() {
    final previous = _navigatorKeys;
    _navigatorKeys = List.generate(_branches.length, (index) {
      final provided = _branches[index].navigatorKey;
      if (provided != null) {
        return provided;
      }
      if (index < previous.length) {
        return previous[index];
      }
      return GlobalKey<NavigatorState>();
    });
    _navigatorObservers = List.generate(_branches.length, (index) {
      return _BranchNavigatorObserver(
        index: index,
        onChanged: _handleBranchNavigationChanged,
      );
    });
  }

  void _syncScrollControllers() {
    final previous = _scrollControllers;
    _scrollControllers = List.generate(_branches.length, (index) {
      if (index < previous.length) {
        return previous[index];
      }
      return ScrollController();
    });
    for (var index = _branches.length; index < previous.length; index++) {
      previous[index].dispose();
    }
  }

  void _initializeLoadedBranches() {
    if (!widget.persistence.lazyLoadBranches) {
      final indexes = List.generate(_branches.length, (index) => index);
      _loadedIndexes.clear();
      for (final index in indexes) {
        _markBranchLoaded(index);
      }
      return;
    }
    _markBranchLoaded(_currentIndex);
  }

  void _markBranchLoaded(int index) {
    if (_loadedIndexes.add(index)) {
      widget.onBranchLoaded?.call(index, _destinations[index]);
    }
  }

  void _notifyInitialBranchEntered() {
    if (_destinations.isEmpty || _currentIndex >= _destinations.length) {
      return;
    }
    _visitedIndexes.add(_currentIndex);
    widget.onBranchEntered?.call(_currentIndex, _destinations[_currentIndex]);
  }

  void _handleControllerChanged() {
    final index = _controller.selectedIndex;
    assert(
      index < _branches.length,
      'controller.selectedIndex must be smaller than branches.length.',
    );
    _markBranchLoaded(index);
    _notifySelectedIndexChanged(index);
    setState(() {});
  }

  void _handleTabsRouterChanged() {
    final index = _tabsRouter.activeIndex;
    _notifySelectedIndexChanged(index);
    setState(() {});
  }

  void _notifySelectedIndexChanged(int index) {
    if (index == _lastSelectedIndex || index >= _destinations.length) {
      return;
    }
    final previousIndex = _lastSelectedIndex;
    final previousDestination = previousIndex < _destinations.length
        ? _destinations[previousIndex]
        : null;
    final destination = _destinations[index];
    final wasVisited = _visitedIndexes.contains(index);

    _previousTransitionIndex = previousIndex;
    _transitionSerial++;
    _lastSelectedIndex = index;
    _visitedIndexes.add(index);
    if (!_usesExternalRouter && _restorationRegistered) {
      _restoredIndex.value = index;
    }

    if (previousDestination != null) {
      widget.onBranchExited?.call(previousIndex, previousDestination);
    }
    widget.onIndexChanged?.call(index);
    widget.onBranchSelected?.call(index, destination);
    widget.onBranchEntered?.call(index, destination);
    if (wasVisited) {
      widget.onBranchBecameActiveAgain?.call(index, destination);
    }
  }

  Future<void> _selectIndex(int index) async {
    assert(index >= 0 && index < _destinations.length);
    if (_pendingIndex != null &&
        widget.selectionGuardPolicy.disableDestinationsWhilePending) {
      return;
    }
    final destination = _destinations[index];
    if (!destination.enabled) {
      return;
    }
    final isReTap = index == _currentIndex;

    if (!isReTap) {
      final decision = await _resolveSelectionGuard(index, destination);
      if (!mounted) {
        return;
      }
      if (!decision.allowed) {
        widget.onSelectionBlocked?.call(index, destination);
        decision.onBlocked?.call();
        return;
      }
    }

    unawaited(widget.hapticFeedbackPolicy.perform());

    if (_isRouterMode) {
      if (isReTap) {
        widget.onBranchReselected?.call(index, destination);
      }
      _navigationShell.goBranch(
        index,
        initialLocation: isReTap && widget.reTapBehavior.popToRoot,
      );
      if (!isReTap) {
        _notifySelectedIndexChanged(index);
      } else if (widget.reTapBehavior.popToRoot) {
        widget.onBranchPoppedToRoot?.call(index, destination);
      }
      return;
    }

    if (_isAutoRouteMode) {
      if (isReTap) {
        widget.onBranchReselected?.call(index, destination);
        _handleAutoRouteReTap(index);
        return;
      }
      _tabsRouter.setActiveIndex(index);
      return;
    }

    if (isReTap) {
      widget.onBranchReselected?.call(index, destination);
      _handleReTap(index);
      return;
    }
    _markBranchLoaded(index);
    _controller.selectIndex(index);
  }

  Future<BottomShellGuardDecision> _resolveSelectionGuard(
    int index,
    BottomDestination destination,
  ) async {
    final richGuard = widget.onSelectionGuard;
    final boolGuard = widget.onBeforeSelect;
    if (richGuard == null && boolGuard == null) {
      return const BottomShellGuardDecision.allow();
    }

    _setPendingIndex(index);
    try {
      if (richGuard != null) {
        return await Future<BottomShellGuardDecision>.value(
          richGuard(context, index, destination),
        );
      }
      final canSelect = await Future<bool>.value(
        boolGuard!(context, index, destination),
      );
      return canSelect
          ? const BottomShellGuardDecision.allow()
          : const BottomShellGuardDecision.block();
    } finally {
      if (mounted) {
        _setPendingIndex(null);
      }
    }
  }

  void _setPendingIndex(int? index) {
    if (_pendingIndex == index) {
      return;
    }
    setState(() => _pendingIndex = index);
  }

  void _handleReTap(int index) {
    if (!widget.reTapBehavior.popToRoot) {
      return;
    }
    if (_popCoreBranchToRoot(index)) {
      return;
    }
    _scrollActiveBranchToTop(index);
  }

  void _handleAutoRouteReTap(int index) {
    if (!widget.reTapBehavior.popToRoot) {
      return;
    }
    _tabsRouter.stackRouterOfIndex(index)?.popUntilRoot();
    widget.onBranchPoppedToRoot?.call(index, _destinations[index]);
  }

  void _scrollActiveBranchToTop(int index) {
    if (!widget.scrollToTopPolicy.enabled) {
      return;
    }
    final controller =
        widget.scrollToTopRegistry?.controllerFor(index) ??
        (index < _scrollControllers.length ? _scrollControllers[index] : null);
    if (controller == null) {
      return;
    }
    if (!controller.hasClients) {
      return;
    }
    if (widget.scrollToTopPolicy.duration == Duration.zero) {
      controller.jumpTo(0);
      return;
    }
    controller.animateTo(
      0,
      duration: widget.scrollToTopPolicy.duration,
      curve: widget.scrollToTopPolicy.curve,
    );
  }

  Future<bool> _popBranchToRoot(int index) async {
    assert(index >= 0 && index < _destinations.length);
    if (_isAutoRouteMode) {
      final stack = _tabsRouter.stackRouterOfIndex(index);
      if (stack == null || !stack.canPop()) {
        return false;
      }
      stack.popUntilRoot();
      widget.onBranchPoppedToRoot?.call(index, _destinations[index]);
      return true;
    }
    if (_usesExternalRouter) {
      return false;
    }
    return _popCoreBranchToRoot(index);
  }

  bool _popCoreBranchToRoot(int index) {
    if (index >= _navigatorKeys.length) {
      return false;
    }
    final navigator = _navigatorKeys[index].currentState;
    if (!(navigator?.canPop() ?? false)) {
      return false;
    }
    navigator?.popUntil((route) => route.isFirst);
    widget.onBranchPoppedToRoot?.call(index, _destinations[index]);
    return true;
  }

  bool _canPopBranch(int index) {
    if (_isAutoRouteMode) {
      return _tabsRouter.stackRouterOfIndex(index)?.canPop() ?? false;
    }
    if (_usesExternalRouter || index >= _navigatorKeys.length) {
      return false;
    }
    return _navigatorKeys[index].currentState?.canPop() ?? false;
  }

  Future<bool> _handleBackButton() async {
    final navigator = _navigatorKeys[_currentIndex].currentState;
    if (navigator?.canPop() ?? false) {
      await navigator!.maybePop();
      return true;
    }
    if (_currentIndex != 0) {
      _controller.selectIndex(0);
      return true;
    }
    return false;
  }

  void _handleBranchNavigationChanged(BottomShellRouteEvent event) {
    widget.onBranchRouteChanged?.call(event.branchIndex, event.route);
    widget.onBranchRouteEvent?.call(event);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (!widget.scrollToHidePolicy.enabled ||
        notification.metrics.axis != Axis.vertical) {
      return false;
    }
    if (notification is ScrollUpdateNotification) {
      final delta = notification.scrollDelta ?? 0;
      if (delta > widget.scrollToHidePolicy.threshold) {
        _setNavigationBarVisible(false);
      } else if (delta < -widget.scrollToHidePolicy.threshold) {
        _setNavigationBarVisible(true);
      }
    } else if (notification is ScrollEndNotification &&
        notification.metrics.pixels <= notification.metrics.minScrollExtent) {
      _setNavigationBarVisible(true);
    }
    return false;
  }

  void _setNavigationBarVisible(bool visible) {
    if (_isNavigationBarVisible == visible) {
      return;
    }
    setState(() => _isNavigationBarVisible = visible);
    final controller = widget.navigationVisibilityController;
    if (controller == null || controller.isVisible == visible) {
      return;
    }
    if (visible) {
      controller.show();
    } else {
      controller.hide();
    }
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (!widget.keyboardNavigationPolicy.enabled || event is! KeyDownEvent) {
      return KeyEventResult.ignored;
    }
    final key = event.logicalKey;
    final direction = Directionality.maybeOf(context) ?? TextDirection.ltr;

    if (widget.keyboardNavigationPolicy.arrowKeys) {
      if (key == LogicalKeyboardKey.arrowDown) {
        return _selectKeyboardOffset(1);
      }
      if (key == LogicalKeyboardKey.arrowUp) {
        return _selectKeyboardOffset(-1);
      }
      if (key == LogicalKeyboardKey.arrowRight) {
        return _selectKeyboardOffset(direction == TextDirection.rtl ? -1 : 1);
      }
      if (key == LogicalKeyboardKey.arrowLeft) {
        return _selectKeyboardOffset(direction == TextDirection.rtl ? 1 : -1);
      }
    }

    if (widget.keyboardNavigationPolicy.homeEndKeys) {
      if (key == LogicalKeyboardKey.home) {
        return _selectKeyboardIndex(_firstEnabledIndex());
      }
      if (key == LogicalKeyboardKey.end) {
        return _selectKeyboardIndex(_lastEnabledIndex());
      }
    }

    return KeyEventResult.ignored;
  }

  KeyEventResult _selectKeyboardOffset(int offset) {
    return _selectKeyboardIndex(_enabledIndexByOffset(offset));
  }

  KeyEventResult _selectKeyboardIndex(int? index) {
    if (index == null || index == _currentIndex) {
      return KeyEventResult.ignored;
    }
    unawaited(_selectIndex(index));
    return KeyEventResult.handled;
  }

  int? _enabledIndexByOffset(int offset) {
    final count = _destinations.length;
    if (count == 0) {
      return null;
    }
    var index = _currentIndex;
    for (var step = 0; step < count; step++) {
      index += offset;
      if (widget.keyboardNavigationPolicy.wrap) {
        index = (index + count) % count;
      } else if (index < 0 || index >= count) {
        return null;
      }
      if (_destinations[index].enabled) {
        return index;
      }
    }
    return null;
  }

  int? _firstEnabledIndex() {
    for (var index = 0; index < _destinations.length; index++) {
      if (_destinations[index].enabled) {
        return index;
      }
    }
    return null;
  }

  int? _lastEnabledIndex() {
    for (var index = _destinations.length - 1; index >= 0; index--) {
      if (_destinations[index].enabled) {
        return index;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final rawBody = _isRouterMode
        ? _navigationShell
        : _isAutoRouteMode
        ? widget._routerChild!
        : PopScope<Object?>(
            canPop: !_shouldHandleBack,
            onPopInvokedWithResult: (didPop, result) {
              if (didPop) {
                return;
              }
              _handleBackButton();
            },
            child: _buildCoreBody(),
          );
    final transitionedBody = _buildBodyTransition(context, rawBody);
    final body = widget.scrollToHidePolicy.enabled
        ? NotificationListener<ScrollNotification>(
            onNotification: _handleScrollNotification,
            child: transitionedBody,
          )
        : transitionedBody;

    final shell = LayoutBuilder(
      builder: (context, constraints) {
        final layout = widget.adaptivePolicy.layoutForWidth(
          constraints.maxWidth,
        );
        if (layout == BottomAdaptiveLayout.drawer) {
          return _buildDrawerLayout(context, body);
        }
        if (layout == BottomAdaptiveLayout.rail ||
            layout == BottomAdaptiveLayout.extendedRail) {
          return _buildRailLayout(
            context,
            body,
            extended: layout == BottomAdaptiveLayout.extendedRail,
          );
        }
        return Scaffold(
          body: body,
          bottomNavigationBar: _buildBottomBar(context),
        );
      },
    );

    if (!widget.keyboardNavigationPolicy.enabled) {
      return shell;
    }
    return Focus(autofocus: true, onKeyEvent: _handleKeyEvent, child: shell);
  }

  Widget _buildCoreBody() {
    return IndexedStack(
      index: _currentIndex,
      children: [
        for (var index = 0; index < _branches.length; index++)
          _loadedIndexes.contains(index)
              ? _BranchNavigator(
                  key: ValueKey(_branches[index].id),
                  navigatorKey: _navigatorKeys[index],
                  observer: _navigatorObservers[index],
                  scrollController: _scrollControllers[index],
                  branch: _branches[index],
                  restorationScopeId:
                      _branches[index].restorationScopeId ??
                      '${widget.restorationScopeId ?? 'bottom_shell'}_${_branches[index].id}_branch',
                )
              : const SizedBox.shrink(),
      ],
    );
  }

  Widget _buildBodyTransition(BuildContext context, Widget child) {
    final transition = widget.bodyTransition;
    final disableAnimations =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (!transition.enabled ||
        transition.duration == Duration.zero ||
        disableAnimations) {
      return child;
    }

    return _BodyTransition(
      transition: transition,
      trigger: _transitionSerial,
      previousIndex: _previousTransitionIndex,
      currentIndex: _currentIndex,
      child: child,
    );
  }

  Widget? _buildBottomBar(BuildContext context) {
    final mediaQuery = MediaQuery.maybeOf(context);
    final keyboardVisible = (mediaQuery?.viewInsets.bottom ?? 0) > 0;
    if (keyboardVisible && widget.keyboardPolicy.hideNavigationBar) {
      return null;
    }

    final theme = widget.theme ?? BottomShellTheme.of(context);
    final disableAnimations = mediaQuery?.disableAnimations ?? false;
    final state = BottomBarState(
      destinations: _destinations,
      selectedIndex: _currentIndex,
      onSelect: _selectIndex,
      theme: theme,
      labelBehavior: widget.appearance.labelBehavior,
      animationStyle: disableAnimations
          ? const BottomBarAnimationStyle.none()
          : widget.appearance.animationStyle,
      pendingIndex: widget.selectionGuardPolicy.showPendingIndicator
          ? _pendingIndex
          : null,
      disableDestinationsWhilePending:
          widget.selectionGuardPolicy.disableDestinationsWhilePending,
    );
    final bar =
        widget.barBuilder?.call(context, state) ??
        widget.appearance.renderer.build(context, state);

    final safeBar = widget.safeAreaPolicy.enabled
        ? SafeArea(
            left: widget.safeAreaPolicy.left,
            right: widget.safeAreaPolicy.right,
            bottom: widget.safeAreaPolicy.bottom,
            maintainBottomViewPadding:
                widget.safeAreaPolicy.maintainBottomViewPadding,
            child: bar,
          )
        : bar;

    if (!widget.scrollToHidePolicy.enabled) {
      return safeBar;
    }

    if (disableAnimations ||
        widget.scrollToHidePolicy.duration == Duration.zero) {
      return _isNavigationBarVisible ? safeBar : const SizedBox.shrink();
    }

    return ClipRect(
      child: AnimatedSize(
        duration: widget.scrollToHidePolicy.duration,
        curve: widget.scrollToHidePolicy.curve,
        child: _isNavigationBarVisible ? safeBar : const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildRailLayout(
    BuildContext context,
    Widget body, {
    required bool extended,
  }) {
    final theme = widget.theme ?? BottomShellTheme.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final state = BottomAdaptiveNavigationState(
      type: BottomAdaptiveNavigationType.rail,
      destinations: _destinations,
      selectedIndex: _currentIndex,
      onSelect: _selectIndex,
      theme: theme,
      extended: extended,
      width: extended
          ? widget.adaptivePolicy.railMinExtendedWidth
          : widget.adaptivePolicy.railMinWidth,
      pendingIndex: widget.selectionGuardPolicy.showPendingIndicator
          ? _pendingIndex
          : null,
      disableDestinationsWhilePending:
          widget.selectionGuardPolicy.disableDestinationsWhilePending,
    );
    final rail =
        widget.railBuilder?.call(context, state) ??
        NavigationRail(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) {
            if (state.canSelect(index)) {
              _selectIndex(index);
            }
          },
          extended: extended,
          minWidth: widget.adaptivePolicy.railMinWidth,
          minExtendedWidth: widget.adaptivePolicy.railMinExtendedWidth,
          labelType: extended
              ? NavigationRailLabelType.none
              : NavigationRailLabelType.all,
          backgroundColor: theme.backgroundColor ?? colorScheme.surface,
          destinations: [
            for (var index = 0; index < _destinations.length; index++)
              NavigationRailDestination(
                icon: _RailIcon(
                  destination: _destinations[index],
                  selected: false,
                  pending: state.isPending(index),
                  theme: theme,
                ),
                selectedIcon: _RailIcon(
                  destination: _destinations[index],
                  selected: true,
                  pending: state.isPending(index),
                  theme: theme,
                ),
                label: Text(_destinations[index].label),
                disabled: !state.canSelect(index),
              ),
          ],
        );

    return Scaffold(
      body: Row(
        children: [
          SafeArea(right: false, child: rail),
          VerticalDivider(
            width: 1,
            thickness: 1,
            color: theme.borderColor ?? colorScheme.outlineVariant,
          ),
          Expanded(child: body),
        ],
      ),
    );
  }

  Widget _buildDrawerLayout(BuildContext context, Widget body) {
    final theme = widget.theme ?? BottomShellTheme.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final background = theme.backgroundColor ?? colorScheme.surface;
    final state = BottomAdaptiveNavigationState(
      type: BottomAdaptiveNavigationType.drawer,
      destinations: _destinations,
      selectedIndex: _currentIndex,
      onSelect: _selectIndex,
      theme: theme,
      extended: true,
      width: widget.adaptivePolicy.drawerWidth,
      pendingIndex: widget.selectionGuardPolicy.showPendingIndicator
          ? _pendingIndex
          : null,
      disableDestinationsWhilePending:
          widget.selectionGuardPolicy.disableDestinationsWhilePending,
    );
    final drawer =
        widget.drawerBuilder?.call(context, state) ??
        SizedBox(
          width: widget.adaptivePolicy.drawerWidth,
          child: Material(
            color: background,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(12, 16, 12, 16),
              children: [
                for (var index = 0; index < _destinations.length; index++)
                  _DrawerDestinationTile(
                    destination: _destinations[index],
                    selected: index == _currentIndex,
                    pending: state.isPending(index),
                    theme: theme,
                    onTap: state.canSelect(index)
                        ? () => _selectIndex(index)
                        : null,
                  ),
              ],
            ),
          ),
        );

    return Scaffold(
      body: Row(
        children: [
          SafeArea(right: false, child: drawer),
          VerticalDivider(
            width: 1,
            thickness: 1,
            color: theme.borderColor ?? colorScheme.outlineVariant,
          ),
          Expanded(child: body),
        ],
      ),
    );
  }
}

class _BodyTransition extends StatefulWidget {
  const _BodyTransition({
    required this.transition,
    required this.trigger,
    required this.previousIndex,
    required this.currentIndex,
    required this.child,
  });

  final BottomShellBodyTransition transition;
  final int trigger;
  final int previousIndex;
  final int currentIndex;
  final Widget child;

  @override
  State<_BodyTransition> createState() => _BodyTransitionState();
}

class _BodyTransitionState extends State<_BodyTransition>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.transition.duration,
    );
    _syncAnimation();
    _controller.value = 1;
  }

  @override
  void didUpdateWidget(_BodyTransition oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.transition != widget.transition) {
      _controller.duration = widget.transition.duration;
      _syncAnimation();
    }
    if (oldWidget.trigger != widget.trigger) {
      _controller
        ..value = 0
        ..forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _syncAnimation() {
    _animation = _controller.drive(CurveTween(curve: widget.transition.curve));
  }

  @override
  Widget build(BuildContext context) {
    final customBuilder = widget.transition.builder;
    if (customBuilder != null) {
      return customBuilder(
        context,
        _animation,
        widget.previousIndex,
        widget.currentIndex,
        widget.child,
      );
    }

    return switch (widget.transition.type) {
      BottomShellBodyTransitionType.fade => FadeTransition(
        opacity: _animation,
        child: widget.child,
      ),
      BottomShellBodyTransitionType.slide => FadeTransition(
        opacity: _animation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: widget.currentIndex >= widget.previousIndex
                ? widget.transition.slideOffset
                : Offset(
                    -widget.transition.slideOffset.dx,
                    -widget.transition.slideOffset.dy,
                  ),
            end: Offset.zero,
          ).animate(_animation),
          child: widget.child,
        ),
      ),
      BottomShellBodyTransitionType.scale => FadeTransition(
        opacity: _animation,
        child: ScaleTransition(
          scale: Tween<double>(
            begin: widget.transition.scaleFrom,
            end: 1,
          ).animate(_animation),
          child: widget.child,
        ),
      ),
      BottomShellBodyTransitionType.custom ||
      BottomShellBodyTransitionType.none => widget.child,
    };
  }
}

class _BranchNavigator extends StatelessWidget {
  const _BranchNavigator({
    required this.navigatorKey,
    required this.observer,
    required this.scrollController,
    required this.branch,
    required this.restorationScopeId,
    super.key,
  });

  final GlobalKey<NavigatorState> navigatorKey;
  final NavigatorObserver observer;
  final ScrollController scrollController;
  final BottomBranch branch;
  final String restorationScopeId;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      restorationScopeId: restorationScopeId,
      observers: [observer],
      onGenerateRoute: (settings) {
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (context) {
            return PrimaryScrollController(
              controller: scrollController,
              child: branch.builder(context),
            );
          },
        );
      },
    );
  }
}

class _RailIcon extends StatelessWidget {
  const _RailIcon({
    required this.destination,
    required this.selected,
    required this.pending,
    required this.theme,
  });

  final BottomDestination destination;
  final bool selected;
  final bool pending;
  final BottomShellThemeData theme;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final selectedColor =
        destination.selectedColor ??
        theme.selectedItemColor ??
        colorScheme.primary;
    final unselectedColor =
        theme.unselectedItemColor ?? colorScheme.onSurfaceVariant;
    final color = selected ? selectedColor : unselectedColor;
    final effectiveColor = destination.enabled
        ? color
        : unselectedColor.withValues(alpha: 0.38);
    final icon = pending
        ? SizedBox(
            width: theme.iconSize,
            height: theme.iconSize,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: effectiveColor,
            ),
          )
        : Icon(
            selected ? destination.effectiveSelectedIcon : destination.icon,
            color: effectiveColor,
            size: theme.iconSize,
          );

    if (destination.badge == null) {
      return icon;
    }
    return BranchBadgeWidget(
      badge: destination.badge!,
      theme: theme,
      child: icon,
    );
  }
}

class _DrawerDestinationTile extends StatelessWidget {
  const _DrawerDestinationTile({
    required this.destination,
    required this.selected,
    required this.pending,
    required this.theme,
    required this.onTap,
  });

  final BottomDestination destination;
  final bool selected;
  final bool pending;
  final BottomShellThemeData theme;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final selectedColor =
        destination.selectedColor ??
        theme.selectedItemColor ??
        colorScheme.primary;
    final unselectedColor =
        theme.unselectedItemColor ?? colorScheme.onSurfaceVariant;
    final effectiveColor = destination.enabled
        ? selected
              ? selectedColor
              : unselectedColor
        : unselectedColor.withValues(alpha: 0.38);
    final indicatorColor = theme.indicatorColor ?? colorScheme.primaryContainer;
    final icon = _RailIcon(
      destination: destination,
      selected: selected,
      pending: pending,
      theme: theme,
    );

    return Semantics(
      button: true,
      selected: selected,
      enabled: destination.enabled,
      label: destination.effectiveTooltip,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: ListTile(
          enabled: destination.enabled,
          selected: selected,
          onTap: onTap,
          minLeadingWidth: 24,
          leading: icon,
          trailing: pending
              ? SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: effectiveColor,
                  ),
                )
              : null,
          title: Text(
            destination.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: effectiveColor,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          selectedTileColor: indicatorColor,
        ),
      ),
    );
  }
}

class _BranchNavigatorObserver extends NavigatorObserver {
  _BranchNavigatorObserver({required this.index, required this.onChanged});

  final int index;
  final void Function(BottomShellRouteEvent event) onChanged;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    onChanged(
      BottomShellRouteEvent(
        branchIndex: index,
        type: BottomShellRouteEventType.push,
        route: route,
        previousRoute: previousRoute,
      ),
    );
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    onChanged(
      BottomShellRouteEvent(
        branchIndex: index,
        type: BottomShellRouteEventType.pop,
        route: previousRoute,
        previousRoute: route,
      ),
    );
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    onChanged(
      BottomShellRouteEvent(
        branchIndex: index,
        type: BottomShellRouteEventType.remove,
        route: previousRoute,
        previousRoute: route,
      ),
    );
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    onChanged(
      BottomShellRouteEvent(
        branchIndex: index,
        type: BottomShellRouteEventType.replace,
        route: newRoute,
        previousRoute: oldRoute,
      ),
    );
  }
}
