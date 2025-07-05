import 'package:flutter/material.dart';

class NotificationButton extends StatelessWidget {
  final Function? onPressed;
  final int? counter;

  const NotificationButton({ 
    super.key,
    this.onPressed,
    this.counter = 0,
  });

  Widget badge() {
    return Positioned(
      right: 11,
      top: 11,
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(6),
        ),
        constraints: const BoxConstraints(
          minWidth: 12,
          minHeight: 12,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        InkWell(
          onTap: () {
            onPressed!();
          },
          child: const Icon(Icons.notifications_none_outlined), 
        ),
        counter != 0 ? badge() : Container(),
      ],
    );
  }
}