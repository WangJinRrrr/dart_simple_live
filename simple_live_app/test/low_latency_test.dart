import 'package:flutter_test/flutter_test.dart';
import 'package:simple_live_app/modules/live_room/player/low_latency.dart';

void main() {
  test('低延迟模式关闭播放器缓存', () {
    var props = lowLatencyProperties('http://cdn.example.com/live/room.flv');
    expect(props['cache'], 'no');
    expect(props['cache-pause'], 'no');
    expect(int.parse(props['demuxer-readahead-secs']!), lessThanOrEqualTo(3));
    expect(int.parse(props['demuxer-max-bytes']!), lessThan(32 * 1024 * 1024));
    // FLV 不需要动 hls 的参数
    expect(props.containsKey('demuxer-lavf-o'), isFalse);
  });

  test('HLS 房间把 live_start_index 贴到直播边缘并保留 media_kit 参数', () {
    var props = lowLatencyProperties('http://cdn.example.com/live/room.m3u8?x=1');
    var lavf = props['demuxer-lavf-o']!;
    expect(lavf, contains('live_start_index=-1'));
    expect(lavf, isNot(contains('live_start_index=-3')));
    // media_kit 默认值不能被覆盖丢掉，否则部分流会打不开
    expect(lavf, contains('protocol_whitelist='));
    expect(lavf, contains('allowed_extensions=ALL'));
  });
}
