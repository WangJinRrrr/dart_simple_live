import 'package:flutter/material.dart';
import 'package:simple_live_app/app/app_style.dart';

class SettingsCard extends StatelessWidget {
  final Widget child;
  const SettingsCard({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      color: colorScheme.surfaceContainerHigh,
      shape: RoundedRectangleBorder(
        borderRadius: AppStyle.radius8,
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: AppStyle.radius8,
        ),
        child: child,
      ),
    );
  }
}
