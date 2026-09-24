import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_live_app/app/app_style.dart';

import 'indexed_controller.dart';

class IndexedPage extends GetView<IndexedController> {
  const IndexedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid || Platform.isIOS) {
      return buildMobileUI(context);
    }
    return buildDesktopUI(context);
  }

  /// 移动端：横屏用侧边栏，竖屏用底部导航
  Widget buildMobileUI(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return Scaffold(
          body: Row(
            children: [
              Visibility(
                visible: orientation == Orientation.landscape,
                child: Obx(
                  () => NavigationRail(
                    selectedIndex: controller.index.value,
                    onDestinationSelected: controller.setIndex,
                    labelType: NavigationRailLabelType.none,
                    destinations: buildDestinations(),
                  ),
                ),
              ),
              Expanded(
                child: buildContent(),
              ),
            ],
          ),
          bottomNavigationBar: Visibility(
            visible: orientation == Orientation.portrait,
            child: Obx(
              () => NavigationBar(
                selectedIndex: controller.index.value,
                onDestinationSelected: controller.setIndex,
                height: 56,
                labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
                destinations: controller.items
                    .map(
                      (item) => NavigationDestination(
                        icon: Icon(item.iconData),
                        label: item.title,
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        );
      },
    );
  }

  /// 桌面端：内容占满窗口，导航栏收进左侧唤出的悬浮面板，避免遮挡
  Widget buildDesktopUI(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: buildContent()),
          // 左侧唤出热区
          Align(
            alignment: Alignment.centerLeft,
            child: MouseRegion(
              onEnter: (_) => controller.showRail(),
              child: const SizedBox(
                width: 8,
                height: double.infinity,
              ),
            ),
          ),
          Obx(
            () => AnimatedPositioned(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
              top: 8,
              bottom: 8,
              width: 56,
              left: controller.railVisible.value ? 8 : -72,
              child: MouseRegion(
                onEnter: (_) => controller.showRail(),
                onExit: (_) => controller.hideRailSoon(),
                child: buildFloatingRail(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFloatingRail(BuildContext context) {
    return ClipRRect(
      borderRadius: AppStyle.radius12,
      child: Container(
        decoration: BoxDecoration(
          color: AppStyle.glassColor(context, alpha: 0.82),
          borderRadius: AppStyle.radius12,
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
        child: Obx(
          () => NavigationRail(
            selectedIndex: controller.index.value,
            onDestinationSelected: controller.setIndex,
            labelType: NavigationRailLabelType.none,
            destinations: buildDestinations(),
          ),
        ),
      ),
    );
  }

  List<NavigationRailDestination> buildDestinations() {
    return controller.items
        .map(
          (item) => NavigationRailDestination(
            icon: Icon(item.iconData),
            label: Text(item.title),
            padding: AppStyle.edgeInsetsV8,
          ),
        )
        .toList();
  }

  Widget buildContent() {
    return Obx(
      () => IndexedStack(
        index: controller.index.value,
        children: controller.pages,
      ),
    );
  }
}
