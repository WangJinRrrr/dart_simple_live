import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_live_app/app/sites.dart';
import 'package:simple_live_app/app/utils.dart';
import 'package:simple_live_app/modules/live_room/live_room_controller.dart';
import 'package:simple_live_app/modules/live_room/player/player_controls.dart';
import 'package:simple_live_core/simple_live_core.dart';

LiveSuperChatMessage sc(String user, String text, {int second = 0}) {
  return LiveSuperChatMessage(
    userName: user,
    face: 'https://example.com/face.jpg',
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

  test('屏蔽SC：总开关 / 关键词命中文案或用户名', () {
    bool blocked(LiveSuperChatMessage m,
            {bool all = false, List<String> words = const []}) =>
        isSuperChatBlocked(m, blockAll: all, keywords: words);

    var m = sc('甲', '来抽奖了');
    expect(blocked(m), isFalse);
    expect(blocked(m, all: true), isTrue);
    expect(blocked(m, words: ['抽奖']), isTrue);
    expect(blocked(m, words: ['乙']), isFalse);
    expect(blocked(m, words: [r'/\d+/']), isFalse);

    // 用户名也能当屏蔽词用
    expect(blocked(sc('张三', '好活'), words: ['张三']), isTrue);
  });

  test('屏蔽词匹配：正则与普通词', () {
    expect(matchShieldKeyword('来抽奖了', ['抽奖']), '抽奖');
    expect(matchShieldKeyword('来抽奖了', ['666']), isNull);
    expect(matchShieldKeyword('abc123', [r'/\d+/']), r'/\d+/');
    expect(matchShieldKeyword('abc', [r'/\d+/']), isNull);
    // 写错的正则不该把整条弹幕误伤，也不该抛异常
    expect(matchShieldKeyword('abc', ['/[a-']), isNull);
  });

  testWidgets('浮层被重建后，之前已经收到的 SC 不会再一起弹出来', (tester) async {
    final controller = LiveRoomController(
      pSite: Sites.allSites['bilibili']!,
      pRoomId: '1',
    );
    // 房间里已经有两条（进房补拉的 / 早就收到过的）
    controller.superChats.add(sc('甲', '之前的SC'));

    Future<void> showOverlay() => tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PlayerSuperChatOverlay(controller: controller),
            ),
          ),
        );

    await showOverlay();
    await tester.pump();
    // 已有的一条不该弹
    expect(find.text('之前的SC'), findsNothing);

    controller.superChats.add(sc('乙', '新SC', second: 30));
    await tester.pump();
    expect(find.text('新SC'), findsOneWidget);
    expect(find.text('之前的SC'), findsNothing);

    // 模拟「播放器中显示SC」开关、全屏/画中画切换导致的浮层重建
    await tester.pumpWidget(const SizedBox());
    await showOverlay();
    controller.superChats.add(sc('丙', '再来一条', second: 60));
    await tester.pump();

    // 重建后只弹新到的那条，之前的不会跟着一起冒出来
    expect(find.text('再来一条'), findsOneWidget);
    expect(find.text('新SC'), findsNothing);
    expect(find.text('之前的SC'), findsNothing);

    // 卸载浮层，取消它内部的定时器
    await tester.pumpWidget(const SizedBox());
  });
}
