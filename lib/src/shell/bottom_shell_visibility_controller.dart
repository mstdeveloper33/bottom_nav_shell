import 'package:flutter/foundation.dart';

/// Controls compact bottom navigation visibility programmatically.
class BottomShellVisibilityController extends ChangeNotifier {
  /// Creates a visibility controller.
  BottomShellVisibilityController({bool initiallyVisible = true})
    : _isVisible = initiallyVisible;

  bool _isVisible;

  /// Whether the compact bottom navigation bar is visible.
  bool get isVisible => _isVisible;

  /// Shows the compact bottom navigation bar.
  void show() {
    _setVisible(true);
  }

  /// Hides the compact bottom navigation bar.
  void hide() {
    _setVisible(false);
  }

  /// Toggles compact bottom navigation visibility.
  void toggle() {
    _setVisible(!_isVisible);
  }

  void _setVisible(bool visible) {
    if (_isVisible == visible) {
      return;
    }
    _isVisible = visible;
    notifyListeners();
  }
}
