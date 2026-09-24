import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

/// Win11(WinUI3) 设计令牌
///
/// 参考 Windows 11 主题资源：
/// - 窗口底色 SolidBackgroundFillColorBase
/// - 卡片/浮层底色 白色/灰阶分层
/// - 文本 89% / 60% / 44% 三级
/// - 描边 6%~8% 黑白混合
class AppColors {
  static ColorScheme lightColorScheme = ColorScheme.fromSeed(
    seedColor: const Color(0xff0067c0),
    brightness: Brightness.light,
  );
  static ColorScheme darkColorScheme = ColorScheme.fromSeed(
    seedColor: const Color(0xff0067c0),
    brightness: Brightness.dark,
  );

  static const Color black333 = Color(0xFF333333);

  // 亮色
  static const Color winLightSurface = Color(0xFFF3F3F3);
  static const Color winLightLayer = Color(0xFFEEEEEE);
  static const Color winLightCard = Color(0xFFFFFFFF);
  static const Color winLightTextSecondary = Color(0xFF5D5D5D);
  static const Color winLightTextTertiary = Color(0xFF8A8A8A);
  static const Color winLightStroke = Color(0x0F000000);
  static const Color winLightDivider = Color(0x14000000);
  static const Color winLightControlFill = Color(0xFFFFFFFF);

  // 暗色
  static const Color winDarkSurface = Color(0xFF202020);
  static const Color winDarkLayer = Color(0xFF272727);
  static const Color winDarkCard = Color(0xFF2B2B2B);
  static const Color winDarkTextSecondary = Color(0xFFC8C8C8);
  static const Color winDarkTextTertiary = Color(0xFF8B8B8B);
  static const Color winDarkStroke = Color(0x12FFFFFF);
  static const Color winDarkDivider = Color(0x15FFFFFF);
  static const Color winDarkControlFill = Color(0xFF2D2D2D);
}

class AppStyle {
  static const String _fontFamily = "Microsoft YaHei UI";
  static const List<String> _fontFamilyFallback = [
    "Segoe UI Variable Text",
    "Segoe UI",
    "Microsoft YaHei",
    "PingFang SC",
  ];

  /// Win11 圆角：控件 4，卡片/浮层 8
  static const double controlRadius = 4;
  static const double overlayRadius = 8;

  /// 把主题色（用户自定义强调色）映射到 Win11 的分层配色
  static ColorScheme winScheme(ColorScheme base) {
    final isDark = base.brightness == Brightness.dark;
    final accent = base.primary;
    return base.copyWith(
      brightness: base.brightness,
      primary: accent,
      // Win11 暗色强调色配黑色文字
      onPrimary: isDark ? const Color(0xFF000000) : const Color(0xFFFFFFFF),
      primaryContainer: accent.withValues(alpha: isDark ? 0.18 : 0.12),
      onPrimaryContainer: isDark ? Colors.white : const Color(0xFF1A1A1A),
      secondary: accent,
      onSecondary: isDark ? const Color(0xFF000000) : const Color(0xFFFFFFFF),
      secondaryContainer: accent.withValues(alpha: isDark ? 0.18 : 0.12),
      onSecondaryContainer: isDark ? Colors.white : const Color(0xFF1A1A1A),
      surface: isDark ? AppColors.winDarkSurface : AppColors.winLightSurface,
      onSurface: isDark ? Colors.white : const Color(0xFF1A1A1A),
      surfaceContainerLowest:
          isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF9F9F9),
      surfaceContainerLow:
          isDark ? AppColors.winDarkSurface : AppColors.winLightSurface,
      surfaceContainer:
          isDark ? AppColors.winDarkLayer : AppColors.winLightLayer,
      surfaceContainerHigh:
          isDark ? AppColors.winDarkCard : AppColors.winLightCard,
      surfaceContainerHighest: isDark
          ? const Color(0xFF323232)
          : const Color(0xFFE7E7E7),
      onSurfaceVariant: isDark
          ? AppColors.winDarkTextSecondary
          : AppColors.winLightTextSecondary,
      outline:
          isDark ? AppColors.winDarkStroke : AppColors.winLightStroke,
      outlineVariant:
          isDark ? AppColors.winDarkDivider : AppColors.winLightDivider,
      surfaceTint: Colors.transparent,
      inverseSurface:
          isDark ? const Color(0xFFF3F3F3) : const Color(0xFF2B2B2B),
      onInverseSurface:
          isDark ? const Color(0xFF1A1A1A) : const Color(0xFFFFFFFF),
      error: isDark ? const Color(0xFFFF99A4) : const Color(0xFFC42B1C),
    );
  }

  static TextTheme _winTextTheme(TextTheme base) {
    return base.copyWith(
      displaySmall: base.displaySmall?.copyWith(fontSize: 28, fontWeight: FontWeight.w600),
      headlineSmall: base.headlineSmall?.copyWith(fontSize: 22, fontWeight: FontWeight.w600),
      titleLarge: base.titleLarge?.copyWith(fontSize: 20, fontWeight: FontWeight.w600),
      titleMedium: base.titleMedium?.copyWith(fontSize: 14, fontWeight: FontWeight.w600),
      titleSmall: base.titleSmall?.copyWith(fontSize: 12, fontWeight: FontWeight.w600),
      bodyLarge: base.bodyLarge?.copyWith(fontSize: 14),
      bodyMedium: base.bodyMedium?.copyWith(fontSize: 14),
      bodySmall: base.bodySmall?.copyWith(fontSize: 12),
      labelLarge: base.labelLarge?.copyWith(fontSize: 14, fontWeight: FontWeight.w400),
      labelMedium: base.labelMedium?.copyWith(fontSize: 12),
      labelSmall: base.labelSmall?.copyWith(fontSize: 11),
    );
  }

  /// 由强调色色板构建 Win11 风格主题
  static ThemeData themeFor(ColorScheme scheme) {
    final cs = winScheme(scheme);
    final isDark = cs.brightness == Brightness.dark;
    final textTheme = _winTextTheme(
      (isDark ? Typography.material2021().white : Typography.material2021().black)
          .apply(
        fontFamily: Platform.isWindows ? _fontFamily : null,
        fontFamilyFallback: _fontFamilyFallback,
      ),
    );

    final controlShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(controlRadius),
    );
    final hover = cs.onSurface.withValues(alpha: isDark ? 0.06 : 0.05);

    return ThemeData(
      useMaterial3: true,
      brightness: cs.brightness,
      colorScheme: cs,
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      cardColor: cs.surfaceContainerHigh,
      fontFamily: Platform.isWindows ? _fontFamily : null,
      fontFamilyFallback: _fontFamilyFallback,
      scaffoldBackgroundColor: cs.surface,
      canvasColor: cs.surface,
      // Win11 没有 Material 的水波纹
      splashFactory: NoSplash.splashFactory,
      dividerColor: cs.outlineVariant,
      dividerTheme: DividerThemeData(
        color: cs.outlineVariant,
        thickness: 1,
        space: 1,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: cs.surface,
        surfaceTintColor: Colors.transparent,
        foregroundColor: cs.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        toolbarHeight: 48,
        titleSpacing: 12,
        titleTextStyle: textTheme.titleMedium?.copyWith(color: cs.onSurface),
        iconTheme: IconThemeData(size: 20, color: cs.onSurface),
        actionsIconTheme: IconThemeData(size: 20, color: cs.onSurface),
        systemOverlayStyle: isDark
            ? SystemUiOverlayStyle.light.copyWith(
                systemNavigationBarColor: Colors.transparent,
              )
            : SystemUiOverlayStyle.dark.copyWith(
                systemNavigationBarColor: Colors.transparent,
              ),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
        minWidth: 52,
        labelType: NavigationRailLabelType.none,
        useIndicator: true,
        indicatorColor: cs.primary.withValues(alpha: isDark ? 0.16 : 0.12),
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(controlRadius),
        ),
        selectedIconTheme: IconThemeData(size: 20, color: cs.primary),
        unselectedIconTheme: IconThemeData(size: 20, color: cs.onSurfaceVariant),
        selectedLabelTextStyle: textTheme.labelMedium?.copyWith(color: cs.primary),
        unselectedLabelTextStyle:
            textTheme.labelMedium?.copyWith(color: cs.onSurfaceVariant),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: cs.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        height: 56,
        indicatorColor: cs.primary.withValues(alpha: isDark ? 0.16 : 0.12),
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(controlRadius),
        ),
        labelTextStyle: WidgetStatePropertyAll(textTheme.labelSmall),
      ),
      cardTheme: CardThemeData(
        color: cs.surfaceContainerHigh,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black.withValues(alpha: 0.14),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(overlayRadius),
          side: BorderSide(color: cs.outlineVariant),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: cs.surfaceContainerHigh,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(overlayRadius),
          side: BorderSide(color: cs.outlineVariant),
        ),
        titleTextStyle: textTheme.titleLarge?.copyWith(color: cs.onSurface),
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: cs.onSurface),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: cs.surfaceContainerHigh,
        modalBackgroundColor: cs.surfaceContainerHigh,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        showDragHandle: true,
        dragHandleColor: cs.onSurfaceVariant.withValues(alpha: 0.4),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(overlayRadius)),
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: cs.surfaceContainerHigh,
        surfaceTintColor: Colors.transparent,
        elevation: 8,
        shadowColor: Colors.black.withValues(alpha: 0.2),
        textStyle: textTheme.bodyMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(overlayRadius),
          side: BorderSide(color: cs.outlineVariant),
        ),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: cs.onSurfaceVariant,
        textColor: cs.onSurface,
        titleTextStyle: textTheme.bodyLarge,
        subtitleTextStyle: textTheme.bodySmall?.copyWith(
          color: isDark
              ? AppColors.winDarkTextTertiary
              : AppColors.winLightTextTertiary,
        ),
        shape: controlShape,
        selectedColor: cs.primary,
        selectedTileColor:
            cs.primary.withValues(alpha: isDark ? 0.14 : 0.1),
        minVerticalPadding: 8,
        horizontalTitleGap: 12,
        minLeadingWidth: 16,
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(Size(0, 32)),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 12),
          ),
          shape: WidgetStatePropertyAll(controlShape),
          foregroundColor: WidgetStatePropertyAll(cs.primary),
          overlayColor: WidgetStatePropertyAll(hover),
          elevation: const WidgetStatePropertyAll(0),
          textStyle: WidgetStatePropertyAll(
            textTheme.labelLarge?.copyWith(fontSize: 14),
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(Size(0, 32)),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 16),
          ),
          shape: WidgetStatePropertyAll(controlShape),
          backgroundColor: WidgetStatePropertyAll(cs.primary),
          foregroundColor: WidgetStatePropertyAll(cs.onPrimary),
          overlayColor: WidgetStatePropertyAll(
            cs.onPrimary.withValues(alpha: 0.1),
          ),
          elevation: const WidgetStatePropertyAll(0),
          textStyle: WidgetStatePropertyAll(
            textTheme.labelLarge?.copyWith(fontSize: 14),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(Size(0, 32)),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 16),
          ),
          shape: WidgetStatePropertyAll(controlShape),
          side: WidgetStatePropertyAll(BorderSide(color: cs.outline)),
          backgroundColor: WidgetStatePropertyAll(
            isDark ? AppColors.winDarkControlFill : AppColors.winLightControlFill,
          ),
          foregroundColor: WidgetStatePropertyAll(cs.onSurface),
          overlayColor: WidgetStatePropertyAll(hover),
          elevation: const WidgetStatePropertyAll(0),
          textStyle: WidgetStatePropertyAll(
            textTheme.labelLarge?.copyWith(fontSize: 14),
          ),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(Size(32, 32)),
          padding: const WidgetStatePropertyAll(EdgeInsets.all(6)),
          shape: WidgetStatePropertyAll(controlShape),
          foregroundColor: WidgetStatePropertyAll(cs.onSurface),
          overlayColor: WidgetStatePropertyAll(hover),
          elevation: const WidgetStatePropertyAll(0),
        ),
      ),
      switchTheme: SwitchThemeData(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return cs.onSurfaceVariant.withValues(alpha: 0.5);
          }
          if (states.contains(WidgetState.selected)) return cs.onPrimary;
          return isDark
              ? AppColors.winDarkTextSecondary
              : AppColors.winLightTextSecondary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return cs.onSurface.withValues(alpha: 0.04);
          }
          if (states.contains(WidgetState.selected)) return cs.primary;
          return Colors.transparent;
        }),
        trackOutlineColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return Colors.transparent;
          return cs.onSurfaceVariant;
        }),
      ),
      radioTheme: RadioThemeData(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return cs.onSurfaceVariant.withValues(alpha: 0.5);
          }
          return states.contains(WidgetState.selected)
              ? cs.primary
              : cs.onSurfaceVariant;
        }),
      ),
      checkboxTheme: CheckboxThemeData(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(controlRadius),
        ),
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return cs.onSurfaceVariant.withValues(alpha: 0.5);
          }
          return states.contains(WidgetState.selected)
              ? cs.primary
              : Colors.transparent;
        }),
        side: BorderSide(color: cs.onSurfaceVariant),
      ),
      sliderTheme: SliderThemeData(
        trackHeight: 4,
        activeTrackColor: cs.primary,
        inactiveTrackColor: isDark
            ? Colors.white.withValues(alpha: 0.2)
            : Colors.black.withValues(alpha: 0.15),
        thumbColor: isDark ? const Color(0xFFF3F3F3) : const Color(0xFF1A1A1A),
        // Win11 滑块没有 Material 的圆形光晕
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 0),
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
        showValueIndicator: ShowValueIndicator.never,
        padding: const EdgeInsets.symmetric(horizontal: 8),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: cs.onSurface,
        unselectedLabelColor: cs.onSurfaceVariant,
        labelStyle: textTheme.titleMedium,
        unselectedLabelStyle: textTheme.titleMedium,
        indicatorColor: cs.primary,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: cs.outlineVariant,
        overlayColor: WidgetStatePropertyAll(hover),
        splashFactory: NoSplash.splashFactory,
      ),
      inputDecorationTheme: InputDecorationThemeData(
        filled: true,
        fillColor: isDark
            ? AppColors.winDarkControlFill
            : AppColors.winLightControlFill,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: isDark
              ? AppColors.winDarkTextTertiary
              : AppColors.winLightTextTertiary,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(controlRadius),
          borderSide: BorderSide(color: cs.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(controlRadius),
          borderSide: BorderSide(color: cs.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(controlRadius),
          borderSide: BorderSide(color: cs.primary, width: 1.5),
        ),
        // Win11 聚焦时有下划线强调条
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(controlRadius),
          borderSide: BorderSide(color: cs.error, width: 1.5),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: cs.primary,
        linearTrackColor: cs.onSurface.withValues(alpha: 0.1),
        circularTrackColor: Colors.transparent,
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: cs.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(controlRadius),
          border: Border.all(color: cs.outlineVariant),
        ),
        textStyle: textTheme.bodySmall?.copyWith(color: cs.onSurface),
        waitDuration: const Duration(milliseconds: 400),
      ),
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => cs.onSurfaceVariant.withValues(
            alpha: states.contains(WidgetState.dragged) ? 0.8 : 0.4,
          ),
        ),
        thickness: const WidgetStatePropertyAll(8),
        radius: const Radius.circular(4),
        crossAxisMargin: 2,
        interactive: true,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: cs.surfaceContainerHighest,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: cs.onSurface),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(overlayRadius),
          side: BorderSide(color: cs.outlineVariant),
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: cs.primary,
        selectionColor: cs.primary.withValues(alpha: 0.3),
        selectionHandleColor: cs.primary,
      ),
    );
  }

  /// 浮层面板（直播间聊天/侧栏唤出）使用的半透明材质
  static Color glassColor(BuildContext context, {double alpha = 0.72}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return (isDark ? AppColors.winDarkSurface : AppColors.winLightSurface)
        .withValues(alpha: alpha);
  }

  static const vGap4 = SizedBox(
    height: 4,
  );
  static const vGap8 = SizedBox(
    height: 8,
  );
  static const vGap12 = SizedBox(
    height: 12,
  );
  static const vGap24 = SizedBox(
    height: 24,
  );
  static const vGap32 = SizedBox(
    height: 32,
  );
  static const vGap48 = SizedBox(
    height: 48,
  );

  static const hGap4 = SizedBox(
    width: 4,
  );
  static const hGap8 = SizedBox(
    width: 8,
  );
  static const hGap12 = SizedBox(
    width: 12,
  );
  static const hGap16 = SizedBox(
    width: 16,
  );

  static const hGap24 = SizedBox(
    width: 24,
  );
  static const hGap32 = SizedBox(
    width: 32,
  );
  static const hGap48 = SizedBox(
    width: 48,
  );

  static const edgeInsetsH4 = EdgeInsets.symmetric(horizontal: 4);
  static const edgeInsetsH8 = EdgeInsets.symmetric(horizontal: 8);
  static const edgeInsetsH12 = EdgeInsets.symmetric(horizontal: 12);
  static const edgeInsetsH16 = EdgeInsets.symmetric(horizontal: 16);
  static const edgeInsetsH20 = EdgeInsets.symmetric(horizontal: 20);
  static const edgeInsetsH24 = EdgeInsets.symmetric(horizontal: 24);

  static const edgeInsetsV4 = EdgeInsets.symmetric(vertical: 4);
  static const edgeInsetsV8 = EdgeInsets.symmetric(vertical: 8);
  static const edgeInsetsV12 = EdgeInsets.symmetric(vertical: 12);
  static const edgeInsetsV24 = EdgeInsets.symmetric(vertical: 24);

  static const edgeInsetsA4 = EdgeInsets.all(4);
  static const edgeInsetsA8 = EdgeInsets.all(8);
  static const edgeInsetsA12 = EdgeInsets.all(12);
  static const edgeInsetsA16 = EdgeInsets.all(16);
  static const edgeInsetsA20 = EdgeInsets.all(20);
  static const edgeInsetsA24 = EdgeInsets.all(24);

  static const edgeInsetsR4 = EdgeInsets.only(right: 4);
  static const edgeInsetsR8 = EdgeInsets.only(right: 8);
  static const edgeInsetsR12 = EdgeInsets.only(right: 12);
  static const edgeInsetsR16 = EdgeInsets.only(right: 16);
  static const edgeInsetsR20 = EdgeInsets.only(right: 20);
  static const edgeInsetsR24 = EdgeInsets.only(right: 24);

  static const edgeInsetsL4 = EdgeInsets.only(left: 4);
  static const edgeInsetsL8 = EdgeInsets.only(left: 8);
  static const edgeInsetsL12 = EdgeInsets.only(left: 12);
  static const edgeInsetsL16 = EdgeInsets.only(left: 16);
  static const edgeInsetsL20 = EdgeInsets.only(left: 20);
  static const edgeInsetsL24 = EdgeInsets.only(left: 24);

  static const edgeInsetsT4 = EdgeInsets.only(top: 4);
  static const edgeInsetsT8 = EdgeInsets.only(top: 8);
  static const edgeInsetsT12 = EdgeInsets.only(top: 12);
  static const edgeInsetsT24 = EdgeInsets.only(top: 24);

  static const edgeInsetsB4 = EdgeInsets.only(bottom: 4);
  static const edgeInsetsB8 = EdgeInsets.only(bottom: 8);
  static const edgeInsetsB12 = EdgeInsets.only(bottom: 12);
  static const edgeInsetsB24 = EdgeInsets.only(bottom: 24);

  static BorderRadius radius4 = BorderRadius.circular(4);
  static BorderRadius radius8 = BorderRadius.circular(8);
  static BorderRadius radius12 = BorderRadius.circular(12);
  static BorderRadius radius24 = BorderRadius.circular(24);
  static BorderRadius radius32 = BorderRadius.circular(32);
  static BorderRadius radius48 = BorderRadius.circular(48);

  /// 顶部状态栏的高度
  static double get statusBarHeight => MediaQuery.of(Get.context!).padding.top;

  /// 底部导航条的高度
  static double get bottomBarHeight =>
      MediaQuery.of(Get.context!).padding.bottom;

  static Divider get divider => Divider(
        height: 1,
        thickness: 1,
        indent: 16,
        endIndent: 16,
        color: Get.theme.colorScheme.outlineVariant,
      );
}
