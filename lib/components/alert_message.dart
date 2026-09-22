import 'package:flutter/material.dart';
import 'package:dpbtn_absen/layouts/constants/layout_color.dart';

class AlertMessage extends StatelessWidget {
  final String? message;
  final EdgeInsets? margin;
  final AlertMessageType? type;

  const AlertMessage({super.key, this.message, this.margin, this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: type != null
          ? type!.decoration
          : AlertMessageType.def.decoration,
      width: MediaQuery.of(context).size.width,
      child: Text(
        '$message',
        style: type != null ? type!.textStyle : AlertMessageType.def.textStyle,
      ),
    );
  }
}

class AlertMessageType {
  final BoxDecoration decoration;
  final TextStyle textStyle;

  const AlertMessageType({required this.decoration, required this.textStyle});

  static final BorderRadius _borderRadius = BorderRadius.circular(10);
  static const Color _color = Colors.white;

  static AlertMessageType def = AlertMessageType(
    decoration: BoxDecoration(
      color: LayoutColor.secondary,
      borderRadius: _borderRadius,
    ),
    textStyle: const TextStyle(color: _color),
  );

  static AlertMessageType success = AlertMessageType(
    decoration: BoxDecoration(
      color: LayoutColor.success,
      borderRadius: _borderRadius,
    ),
    textStyle: const TextStyle(color: _color),
  );

  static AlertMessageType primary = AlertMessageType(
    decoration: BoxDecoration(
      color: LayoutColor.primary,
      borderRadius: _borderRadius,
    ),
    textStyle: const TextStyle(color: LayoutColor.textPrimary),
  );

  static AlertMessageType info = AlertMessageType(
    decoration: BoxDecoration(
      color: LayoutColor.info,
      borderRadius: _borderRadius,
    ),
    textStyle: const TextStyle(color: _color),
  );

  static AlertMessageType warning = AlertMessageType(
    decoration: BoxDecoration(
      color: LayoutColor.warning,
      borderRadius: _borderRadius,
    ),
    textStyle: const TextStyle(color: _color),
  );

  static AlertMessageType danger = AlertMessageType(
    decoration: BoxDecoration(
      color: LayoutColor.danger,
      borderRadius: _borderRadius,
    ),
    textStyle: const TextStyle(color: _color),
  );
}
