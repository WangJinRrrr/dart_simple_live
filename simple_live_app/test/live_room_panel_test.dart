import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:simple_live_app/modules/live_room/live_room_controller.dart';

/// 画中画（小窗）模式下，聊天面板是并排显示的，所以窗口宽度要跟着面板显示/隐藏增减。
/// 这里的符号和钳位最容易写错，单独测一下。
void main() {
  test('显示聊天时窗口加宽，收起时收回原尺寸', () {
    const videoOnly = Size(498, 280);

    final withChat =
        LiveRoomController.smallWindowSizeAfterPanelToggle(videoOnly, true);
    expect(withChat.width,
        videoOnly.width + LiveRoomController.smallWindowChatWidth);
    expect(withChat.height, videoOnly.height);

    // 来回切一次不能漂移
    final back =
        LiveRoomController.smallWindowSizeAfterPanelToggle(withChat, false);
    expect(back.width, videoOnly.width);
    expect(back.height, videoOnly.height);
  });

  test('窗口很小时也不会被收成 0 或负宽度', () {
    final tiny = LiveRoomController.smallWindowSizeAfterPanelToggle(
      const Size(200, 150),
      false,
    );
    expect(tiny.width, greaterThanOrEqualTo(160));
    expect(tiny.height, 150);
  });
}
