import 'package:bottom_shell_nav/bottom_shell_nav.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BottomShellController', () {
    test('uses the initial index', () {
      final controller = BottomShellController(initialIndex: 2);

      expect(controller.selectedIndex, 2);
    });

    test('notifies listeners when index changes', () {
      final controller = BottomShellController();
      var calls = 0;
      controller.addListener(() => calls++);

      controller.selectIndex(1);
      controller.selectIndex(1);
      controller.selectIndex(2);

      expect(controller.selectedIndex, 2);
      expect(calls, 2);
    });

    test('branch actions are safe before a shell is attached', () async {
      final controller = BottomShellController();

      controller.select(1);

      expect(controller.selectedIndex, 1);
      expect(controller.canPopBranch(0), isFalse);
      expect(await controller.popToRoot(0), isFalse);
      await controller.reselectCurrent();
    });
  });
}
