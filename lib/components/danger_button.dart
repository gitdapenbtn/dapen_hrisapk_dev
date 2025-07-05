import 'package:flutter/material.dart';
import 'package:dpbtn_absen/layouts/constants/layout_color.dart';

class DangerButton extends TextButton {
  @override
  // ignore: overridden_fields
  final Widget child;

  DangerButton({
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
      backgroundColor: LayoutColor.danger,
      foregroundColor: LayoutColor.background,
      disabledBackgroundColor: LayoutColor.danger,
      disabledForegroundColor: const Color.fromARGB(157, 240, 244, 249),
      minimumSize: const Size.fromHeight(50),
    ),
    child: child
  );
}