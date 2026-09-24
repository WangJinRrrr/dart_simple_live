/// 低延迟模式需要写入 mpv 的属性。
///
/// 这个文件不依赖 Flutter，方便直接测试。
///
/// 为什么需要它：
/// media_kit 初始化时强制设置了 `cache=yes`、`demuxer-max-bytes=32MB`，
/// 而 mpv 的 `cache-secs` 默认是"尽可能大"（官方手册原文：默认值被设得很高，
/// 所以实际预读量受 demuxer-max-bytes 限制）。直播服务器周期性 burst 推流时，
/// 播放器会把收到的数据全堆在缓存里、且从不回追直播边缘，于是看得越久延迟越大。
///
/// - `cache=no`：关闭网络缓存
/// - `cache-pause=no`：缓存不足时直接继续播，不进入缓冲等待
/// - `demuxer-readahead-secs` / `demuxer-max-bytes`：把预读压到秒级
/// - HLS 房间额外把 ffmpeg hls demuxer 的 `live_start_index` 从默认 -3
///   （倒数第三个分片）改成 -1；注意这会覆盖 media_kit 默认的
///   `demuxer-lavf-o`，必须保留它原有的参数。
Map<String, String> lowLatencyProperties(String? mediaUrl) {
  var properties = <String, String>{
    'cache': 'no',
    'cache-pause': 'no',
    'demuxer-readahead-secs': '2',
    'demuxer-max-bytes': '${4 * 1024 * 1024}',
  };

  if (mediaUrl != null && mediaUrl.contains('.m3u8')) {
    properties['demuxer-lavf-o'] = [
      'live_start_index=-1',
      'seg_max_retry=5',
      'strict=experimental',
      'allowed_extensions=ALL',
      'protocol_whitelist=[udp,rtp,tcp,tls,data,file,http,https,crypto]',
    ].join(',');
  }

  return properties;
}
