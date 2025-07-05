import 'package:flutter/material.dart';
import 'package:dpbtn_absen/layouts/constants/layout_color.dart';

class SecondaryButton extends TextButton {
  @override
  // ignore: overridden_fields
  final Widget child;

  SecondaryButton({
    required this.child,
    super.autofocus,
    super.clipBehavior,
    super.focusNode,
    super.onFocusChange,
    super.onHover,
    super.onLongPress,
    super.onPressed,
    super.statesController,
    super.key,
  }) : super(
    style: TextButton.styleFrom(
      backgroundColor: LayoutColor.secondary,
      foregroundColor: LayoutColor.textPrimary,
      disabledBackgroundColor: LayoutColor.secondary,
      disabledForegroundColor: LayoutColor.textSecondary,
      minimumSize: const Size.fromHeight(50),
    ),
    child: child
  );
}