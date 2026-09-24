import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_live_app/app/app_style.dart';
import 'package:simple_live_app/widgets/settings/settings_card.dart';
import 'package:simple_live_app/widgets/shadow_card.dart';

/// 主题和共用组件的构建检查：Win11 主题配置一旦不合法（比如圆角/配色/组件主题写错），
/// 这些组件在 pump 时就会抛异常。
void main() {
  Widget wrap(ThemeData theme) {
    return MaterialApp(
      theme: theme,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('标题'),
            actions: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
            ],
          ),
          body: Row(
            children: [
              NavigationRail(
                selectedIndex: 0,
                destinations: const [
                  NavigationRailDestination(
                    icon: Icon(Icons.home),
                    label: Text('首页'),
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SettingsCard(child: ListTile(title: Text('设置项'))),
                      ShadowCard(onTap: () {}, child: const SizedBox(height: 40)),
                      const Switch(value: true, onChanged: null),
                      const Slider(value: 0.5, onChanged: null),
                      const Divider(),
                      TextButton(onPressed: () {}, child: const Text('按钮')),
                      const TabBar(tabs: [Tab(text: '聊天'), Tab(text: '设置')]),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  testWidgets('浅色主题可以正常构建', (tester) async {
    await tester.pumpWidget(
      wrap(
        AppStyle.themeFor(
          ColorScheme.fromSeed(seedColor: const Color(0xff0067c0)),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('深色主题可以正常构建', (tester) async {
    await tester.pumpWidget(
      wrap(
        AppStyle.themeFor(
          ColorScheme.fromSeed(
            seedColor: const Color(0xff0067c0),
            brightness: Brightness.dark,
          ),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
  });

  test('Win11 分层配色：窗口底色 / 卡片层 / 描边', () {
    final light = AppStyle.themeFor(
      ColorScheme.fromSeed(seedColor: const Color(0xff0067c0)),
    );
    final dark = AppStyle.themeFor(
      ColorScheme.fromSeed(
        seedColor: const Color(0xff0067c0),
        brightness: Brightness.dark,
      ),
    );

    // 窗口底色用 Win11 的 Mica 底色，卡片用更亮/更暗的一层
    expect(light.scaffoldBackgroundColor, AppColors.winLightSurface);
    expect(light.cardColor, AppColors.winLightCard);
    expect(dark.scaffoldBackgroundColor, AppColors.winDarkSurface);
    expect(dark.cardColor, AppColors.winDarkCard);
    // 描边必须是半透明的（不是纯黑/纯白），否则 Win11 的层次感就没了
    expect(light.colorScheme.outlineVariant.a, lessThan(0.2));
    expect(dark.colorScheme.outlineVariant.a, lessThan(0.2));
    // 暗色下强调色上要用黑字（Win11 的做法）
    expect(dark.colorScheme.onPrimary, const Color(0xFF000000));
  });
}
