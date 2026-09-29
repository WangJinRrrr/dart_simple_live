import 'package:flutter_test/flutter_test.dart';
import 'package:simple_live_app/app/utils.dart';
import 'package:simple_live_app/modules/live_room/player/player_controls.dart';
import 'package:simple_live_core/simple_live_core.dart';

LiveSuperChatMessage sc(String user, String text, {int second = 0}) {
  return LiveSuperChatMessage(
    userName: user,
    face: 'face',
    message: text,
    price: 30,
    startTime: DateTime(2026, 1, 1, 12, 0, second),
    endTime: DateTime(2026, 1, 1, 12, 5, second),
    backgroundColor: '#000000',
    backgroundBottomColor: '#111111',
  );
}

void main() {
  test('进房补拉的历史 SC 不弹，只弹之后新到的', () {
    var history = [sc('甲', '历史1'), sc('乙', '历史2')];
    var backfill = {for (var e in history) superChatKey(e)};
    var handled = <String>{};

    // 进房：接口补拉的这批只进 SC 面板，不该弹出来
    expect(
      takePopupSuperChats(
        list: history,
        handledKeys: handled,
        backfillKeys: backfill,
      ),
      isEmpty,
    );

    // 之后弹幕推送来一条新的
    var fresh = sc('丙', '新SC', second: 30);
    var popped = takePopupSuperChats(
      list: [...history, fresh],
      handledKeys: handled,
      backfillKeys: backfill,
    );
    expect(popped.map((e) => e.message), ['新SC']);
  });

  test('同一条 SC 不会弹第二次（刷新房间会重新拉成新对象）', () {
    var handled = <String>{};
    var backfill = <String>{};

    var live = sc('丙', '新SC');
    expect(
      takePopupSuperChats(
        list: [live],
        handledKeys: handled,
        backfillKeys: backfill,
      ),
      hasLength(1),
    );

    // 刷新房间后同一内容的 SC 是新对象（模型没有 ==，比较的是引用）
    var refetched = sc('丙', '新SC');
    expect(refetched == live, isFalse);
    expect(
      takePopupSuperChats(
        list: [refetched],
        handledKeys: handled,
        backfillKeys: backfill,
      ),
      isEmpty,
    );
  });

  test('同一条历史 SC 第二次补拉也不会弹（按内容判重，不依赖对象引用）', () {
    var handled = <String>{};
    var backfill = <String>{};

    var history = sc('甲', '历史');
    backfill.add(superChatKey(history));
    expect(
      takePopupSuperChats(
        list: [history],
        handledKeys: handled,
        backfillKeys: backfill,
      ),
      isEmpty,
    );

    // 重新拉一遍，内容相同但是新对象
    var again = sc('甲', '历史');
    expect(
      takePopupSuperChats(
        list: [again],
        handledKeys: handled,
        backfillKeys: backfill,
      ),
      isEmpty,
    );
  });
}
