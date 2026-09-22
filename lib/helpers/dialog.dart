import 'package:flutter/material.dart';
import 'package:dpbtn_absen/components/message_dialog.dart';

showDialogSuccess(
  BuildContext context, {
  String? title,
  String? message,
  Function? onClose,
}) {
  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return MessageDialog(title: title, message: message);
    },
  ).whenComplete(() {
    if (onClose != null) {
      onClose();
    }
  });
}

showDialogMessage(
  BuildContext context, {
  String? title,
  String? message,
  List<Widget>? actions,
  Function? onClose,
}) {
  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return MessageDialog(title: title, message: message, actions: actions);
    },
  ).whenComplete(() {
    if (onClose != null) {
      onClose();
    }
  });
}
