import 'package:flutter/widgets.dart';

/// Registry for branch-specific scroll controllers used by scroll-to-top.
class ScrollToTopRegistry {
  final _controllers = <int, ScrollController>{};

  /// Registers [controller] as the scroll-to-top target for [branchIndex].
  void register(int branchIndex, ScrollController controller) {
    assert(branchIndex >= 0, 'branchIndex must be non-negative.');
    _controllers[branchIndex] = controller;
  }

  /// Removes [controller] when it is still registered for [branchIndex].
  void unregister(int branchIndex, ScrollController controller) {
    if (_controllers[branchIndex] == controller) {
      _controllers.remove(branchIndex);
    }
  }

  /// Returns the registered controller for [branchIndex], if any.
  ScrollController? controllerFor(int branchIndex) {
    return _controllers[branchIndex];
  }

  /// Removes all registered controllers.
  void clear() {
    _controllers.clear();
  }
}
