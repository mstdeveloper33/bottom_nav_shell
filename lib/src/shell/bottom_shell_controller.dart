part of 'bottom_shell.dart';

/// Controls the selected branch of a [BottomShell].
class BottomShellController extends ChangeNotifier {
  /// Creates a controller with an initial selected index.
  BottomShellController({int initialIndex = 0})
    : assert(initialIndex >= 0, 'initialIndex must be non-negative.'),
      _selectedIndex = initialIndex;

  int _selectedIndex;

  /// Currently selected branch index.
  int get selectedIndex => _selectedIndex;

  _BottomShellControllerDelegate? _delegate;

  /// Selects a branch and notifies listeners when it changes.
  void selectIndex(int index) {
    assert(index >= 0, 'index must be non-negative.');
    if (index == _selectedIndex) {
      return;
    }
    _selectedIndex = index;
    notifyListeners();
  }

  /// Selects a branch.
  void select(int index) {
    selectIndex(index);
  }

  /// Re-applies the active branch re-tap behavior.
  Future<void> reselectCurrent() {
    return _delegate?.reselectCurrent() ?? Future<void>.value();
  }

  /// Pops the branch at [index] back to its root route.
  Future<bool> popToRoot(int index) {
    assert(index >= 0, 'index must be non-negative.');
    return _delegate?.popToRoot(index) ?? Future<bool>.value(false);
  }

  /// Whether the branch at [index] can pop its nested navigator.
  bool canPopBranch(int index) {
    assert(index >= 0, 'index must be non-negative.');
    return _delegate?.canPopBranch(index) ?? false;
  }

  /// Binds this controller to an active shell.
  void _bind(_BottomShellControllerDelegate delegate) {
    _delegate = delegate;
  }

  /// Removes the active shell binding.
  void _unbind(_BottomShellControllerDelegate delegate) {
    if (_delegate == delegate) {
      _delegate = null;
    }
  }
}

/// Internal action bridge used by [BottomShellController].
class _BottomShellControllerDelegate {
  /// Creates a controller delegate.
  const _BottomShellControllerDelegate({
    required this.reselectCurrent,
    required this.popToRoot,
    required this.canPopBranch,
  });

  /// Re-applies active branch re-tap behavior.
  final Future<void> Function() reselectCurrent;

  /// Pops a branch to root.
  final Future<bool> Function(int index) popToRoot;

  /// Returns whether a branch can pop.
  final bool Function(int index) canPopBranch;
}
