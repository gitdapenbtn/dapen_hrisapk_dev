// import 'package:flutter/cupertino.dart';
//
// class LayoutTitle extends StatelessWidget {
//   final String? title;
//
//   const LayoutTitle(this.title, {super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       title ?? '',
//       style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
//     );
//   }
// }


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LayoutTitle extends StatelessWidget {
  final String? title;

  const LayoutTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      title ?? '',
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w900,
        fontSize: 20,
      ),
    );
  }
}
