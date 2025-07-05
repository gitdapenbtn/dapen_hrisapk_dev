import 'package:flutter/material.dart';

class MessageDialog extends StatelessWidget {
  final String? title;
  final String? message;
  final List<Widget>? actions;

  const MessageDialog({
    this.title,
    this.message,
    this.actions,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title ?? '',
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        )
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 10),
      content: message != null ? Text(message ?? '', textAlign: TextAlign.center,) : null,
      actions: actions ?? [],
    );
  }
}