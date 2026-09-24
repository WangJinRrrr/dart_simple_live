import 'package:flutter/material.dart';

/// Win11 风格卡片：1px 描边 + 极轻投影，悬停时高亮
class ShadowCard extends StatelessWidget {
  final Widget child;
  final double radius;
  final Function()? onTap;
  const ShadowCard({
    required this.child,
    this.radius = 8.0,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: colorScheme.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(radius),
      child: InkWell(
        borderRadius: BorderRadius.circular(radius),
        onTap: onTap,
        hoverColor: colorScheme.onSurface.withValues(alpha: 0.05),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: colorScheme.outlineVariant),
            boxShadow: isDark
                ? null
                : [
                    BoxShadow(
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                      color: Colors.black.withValues(alpha: 0.04),
                    ),
                  ],
          ),
          child: child,
        ),
      ),
    );
  }
}
