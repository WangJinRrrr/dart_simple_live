import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:media_kit/media_kit.dart';
import 'package:simple_live_app/app/sites.dart';
import 'package:simple_live_app/modules/live_room/live_room_controller.dart';
import 'package:simple_live_core/simple_live_core.dart';

/// 延迟可控的假直播源
class _FakeLiveSite extends LiveSite {
  _FakeLiveSite({
    required this.id,
    required this.url,
    this.delay = Duration.zero,
  });

  @override
  final String id;
  final String url;
  final Duration delay;

  @override
  Future<List<LivePlayQuality>> getPlayQualites({
    required LiveRoomDetail detail,
  }) async {
    await Future.delayed(delay);
    return [LivePlayQuality(quality: '原画', data: 0)];
  }

  @override
  Future<LivePlayUrl> getPlayUrls({
    required LiveRoomDetail detail,
    required LivePlayQuality quality,
  }) async {
    await Future.delayed(delay);
    return LivePlayUrl(urls: [url]);
  }
}

/// 把真实播放器换掉，只记录被 open 的地址
class _TestRoomController extends LiveRoomController {
  _TestRoomController({required super.pSite, required super.pRoomId});

  final List<String> opened = [];

  @override
  bool get forceHttps => false;

  /// 测试里不走设置项/网络状态，固定选中间清晰度
  @override
  Future<int> getQualityLevel() async => 1;

  @override
  Future<void> initializePlayer({String? mediaUrl}) async {}

  @override
  Future<void> openPlaylist(List<Media> mediaList) async {
    opened.add(mediaList.first.uri);
  }
}

LiveRoomDetail _detail(String roomId) {
  return LiveRoomDetail(
    roomId: roomId,
    title: '房间$roomId',
    cover: '',
    userName: '主播$roomId',
    userAvatar: '',
    online: 1,
    status: true,
    url: 'https://example.com/$roomId',
  );
}

void main() {
  test('快速切换直播源：旧会话晚到的播放地址不会顶掉新的', () async {
    // A 站慢（模拟上一个还没加载完）
    final siteA = Site(
      id: 'a',
      name: 'A',
      logo: '',
      liveSite: _FakeLiveSite(
        id: 'a',
        url: 'http://a/live.flv',
        delay: const Duration(milliseconds: 100),
      ),
    );
    final siteB = Site(
      id: 'b',
      name: 'B',
      logo: '',
      liveSite: _FakeLiveSite(id: 'b', url: 'http://b/live.flv'),
    );

    final controller = _TestRoomController(pSite: siteA, pRoomId: '1');
    controller.detail.value = _detail('1');

    // 会话 1：A 站的加载链路，卡在取清晰度那一步
    final sessionA = controller.newLoadSession();
    final loadingA = controller.getPlayQualites(session: sessionA);

    // 用户还没等 A 加载完就切到 B 站（等价于 resetRoom 的关键动作：
    // 换源 + 换房间 + 作废旧会话）
    controller.rxSite.value = siteB;
    controller.rxRoomId.value = '2';
    controller.detail.value = _detail('2');
    final sessionB = controller.newLoadSession();
    final loadingB = controller.getPlayQualites(session: sessionB);

    await Future.wait([loadingA, loadingB]);
    // getPlayQualites 里是 fire-and-forget 调 getPlayUrl，再等一会儿让整条链路跑完
    // （也顺便让 A 站那个 100ms 的假延迟到期）
    await Future.delayed(const Duration(milliseconds: 300));

    // 只有 B 的地址进了播放器，A 的晚到结果被丢弃
    expect(controller.opened, ['http://b/live.flv']);
    expect(controller.playUrls.toList(), ['http://b/live.flv']);
    expect(controller.isLoadSessionCurrent(sessionA), isFalse);
    expect(controller.isLoadSessionCurrent(sessionB), isTrue);
  });

  test('会话号语义：开新会话即作废旧会话', () {
    final controller = _TestRoomController(
      pSite: Site(
        id: 'a',
        name: 'A',
        logo: '',
        liveSite: _FakeLiveSite(id: 'a', url: 'http://a/live.flv'),
      ),
      pRoomId: '1',
    );

    final first = controller.newLoadSession();
    expect(controller.isLoadSessionCurrent(first), isTrue);

    final second = controller.newLoadSession();
    expect(controller.isLoadSessionCurrent(first), isFalse);
    expect(controller.isLoadSessionCurrent(second), isTrue);
  });
}
