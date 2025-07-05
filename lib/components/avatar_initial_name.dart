import 'package:flutter/material.dart';
import 'package:dpbtn_absen/layouts/constants/layout_color.dart';

class AvatarInitialName extends StatelessWidget {
  final String? name;
  final double? fontSize;
  final double? radius;

  const AvatarInitialName({
    this.name,
    this.fontSize,
    this.radius,
    super.key,
  });
  
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: LayoutColor.primary,
      foregroundColor: LayoutColor.textPrimary,
      radius: radius,
      child: Text(
        _getInitials(name),
        style: TextStyle(
          fontWeight: FontWeight.bold, 
          fontSize: fontSize,
        )
      ),
    );
  }

  String _getInitials(String? name) {
    String initials = (name != null && name.isNotEmpty) 
      ? name.trim().split(RegExp(' +')).map((s) => s[0]).take(2).join().toUpperCase() 
      : '';
    return initials;
  }
}