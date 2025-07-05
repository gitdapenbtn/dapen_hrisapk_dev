import 'package:flutter/material.dart';
import 'package:dpbtn_absen/configs/app.dart';

showSnackBarAnywhere (String message, {Function? onClosed, double? width}) {
  final SnackBar snackBar = SnackBar(
    width: width,
    content: Text(
      message,
      textAlign: TextAlign.center,
    ),
    shape: const StadiumBorder(),
    behavior: SnackBarBehavior.floating,
  );
  scaffoldMessengerStateKey.currentState?.showSnackBar(snackBar)
    .closed
    .then((value) {
      if(onClosed != null) {
        onClosed();
      }
    });
}