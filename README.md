> ### ⚙ 本仓库是 [xiaoyaocz/dart_simple_live](https://github.com/xiaoyaocz/dart_simple_live) 的 **Windows 专用分支**
>
> 只保留 Windows 桌面端（`simple_live_app/windows`）及其依赖，已完成以下改动：
>
> - 移除 Android / iOS / MacOS / Linux / Android TV 平台目录
> - 参考 Win11 原生窗口风格重做 UI（分层配色、圆角、无涟漪），侧边栏改为可唤出的悬浮面板
> - 直播间画面铺满窗口，聊天/资料收进可手动开合的悬浮面板；画中画（小窗）模式下聊天与画面并排
> - 新增低延迟模式（默认开启）：关闭播放器网络缓存，HLS 房间贴到直播边缘
>
> Windows 便携版（ZIP，解压即用）见 [Releases](https://github.com/WangJinRrrr/dart_simple_live/releases)。其他平台请使用原项目。


<p align="center">
    <img width="128" src="/assets/logo.png" alt="Simple Live logo">
</p>
<h2 align="center">Simple Live</h2>

<p align="center">
简简单单的看直播
</p>

![浅色模式](/assets/screenshot_light.jpg)

![深色模式](/assets/screenshot_dark.jpg)

## 支持直播平台：

- 虎牙直播

- 斗鱼直播

- 哔哩哔哩直播

- 抖音直播

## APP支持平台

- [x] Windows

## 项目结构

- `simple_live_core` 项目核心库，实现获取各个网站的信息及弹幕。
- `simple_live_console` 基于simple_live_core的控制台程序。
- `simple_live_app` 基于核心库实现的Flutter Windows客户端。

## 环境

Flutter : `3.47`

## 参考及引用

[AllLive](https://github.com/xiaoyaocz/AllLive) `本项目的C#版，有兴趣可以看看`

[dart_tars_protocol](https://github.com/xiaoyaocz/dart_tars_protocol.git)

[wbt5/real-url](https://github.com/wbt5/real-url)

[lovelyyoshino/Bilibili-Live-API](https://github.com/lovelyyoshino/Bilibili-Live-API/blob/master/API.WebSocket.md)

[IsoaSFlus/danmaku](https://github.com/IsoaSFlus/danmaku)

[BacooTang/huya-danmu](https://github.com/BacooTang/huya-danmu)

[TarsCloud/Tars](https://github.com/TarsCloud/Tars)

[YunzhiYike/douyin-live](https://github.com/YunzhiYike/douyin-live)

[5ime/Tiktok_Signature](https://github.com/5ime/Tiktok_Signature)

## 声明

本项目的所有功能都是基于互联网上公开的资料开发，无任何破解、逆向工程等行为。

本项目仅用于学习交流编程技术，严禁将本项目用于商业目的。如有任何商业行为，均与本项目无关。

如果本项目存在侵犯您的合法权益的情况，请及时与开发者联系，开发者将会及时删除有关内容。

## Star History

<a href="https://www.star-history.com/#WangJinRrrr/dart_simple_live&Date">
 <picture>
   <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=WangJinRrrr/dart_simple_live&type=Date&theme=dark" />
   <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/svg?repos=WangJinRrrr/dart_simple_live&type=Date" />
   <img alt="Star History Chart" src="https://api.star-history.com/svg?repos=WangJinRrrr/dart_simple_live&type=Date" />
 </picture>
</a>
