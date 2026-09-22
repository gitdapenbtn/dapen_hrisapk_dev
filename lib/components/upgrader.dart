import 'package:flutter/material.dart';
import 'package:upgrader/upgrader.dart';

class UpgraderWidget extends StatelessWidget {
  final Widget child;

  const UpgraderWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return UpgradeAlert(child: child);
  }
}
