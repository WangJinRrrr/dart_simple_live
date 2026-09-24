import 'package:flutter/widgets.dart';

import 'dart:async';
import 'package:get/get.dart';
import 'package:simple_live_app/app/constant.dart';
import 'package:simple_live_app/app/controller/app_settings_controller.dart';
import 'package:simple_live_app/app/event_bus.dart';
import 'package:simple_live_app/app/utils.dart';
import 'package:simple_live_app/modules/category/category_controller.dart';
import 'package:simple_live_app/modules/category/category_page.dart';
import 'package:simple_live_app/modules/home/home_controller.dart';
import 'package:simple_live_app/modules/home/home_page.dart';
import 'package:simple_live_app/modules/follow_user/follow_user_controller.dart';
import 'package:simple_live_app/modules/follow_user/follow_user_page.dart';
import 'package:simple_live_app/modules/mine/mine_page.dart';

class IndexedController extends GetxController {
  RxList<HomePageItem> items = RxList<HomePageItem>([]);

  var index = 0.obs;

  /// 桌面端悬浮导航栏是否显示
  var railVisible = false.obs;

  Timer? _railTimer;

  /// 唤出悬浮导航栏
  void showRail() {
    _railTimer?.cancel();
    railVisible.value = true;
  }

  /// 鼠标离开后自动收起
  void hideRailSoon() {
    _railTimer?.cancel();
    _railTimer = Timer(
      const Duration(milliseconds: 900),
      () => railVisible.value = false,
    );
  }
  RxList<Widget> pages = RxList<Widget>([
    const SizedBox(),
    const SizedBox(),
    const SizedBox(),
    const SizedBox(),
  ]);

  void setIndex(int i) {
    if (pages[i] is SizedBox) {
      switch (items[i].index) {
        case 0:
          Get.put(HomeController());
          pages[i] = const HomePage();
          break;
        case 1:
          Get.put(FollowUserController());
          pages[i] = const FollowUserPage();
          break;
        case 2:
          Get.put(CategoryController());
          pages[i] = const CategoryPage();
          break;
        case 3:
          pages[i] = const MinePage();
          break;
        default:
      }
    } else {
      if (index.value == i) {
        EventBus.instance
            .emit<int>(EventBus.kBottomNavigationBarClicked, items[i].index);
      }
    }

    index.value = i;
  }

  @override
  void onInit() {
    Future.delayed(Duration.zero, showFirstRun);
    items.value = AppSettingsController.instance.homeSort
        .map((key) => Constant.allHomePages[key]!)
        .toList();
    setIndex(0);
    // 启动时先露出导航栏，让用户知道它在哪里，之后自动收起
    railVisible.value = true;
    _railTimer = Timer(
      const Duration(seconds: 2),
      () => railVisible.value = false,
    );
    super.onInit();
  }

  void showFirstRun() async {
    var settingsController = Get.find<AppSettingsController>();
    if (settingsController.firstRun) {
      settingsController.setNoFirstRun();
      await Utils.showStatement();
    }
  }

  @override
  void onClose() {
    _railTimer?.cancel();
    super.onClose();
  }
}
