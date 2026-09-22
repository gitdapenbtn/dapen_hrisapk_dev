import 'package:flutter/cupertino.dart';

class Section extends StatelessWidget {
  final bool fullWidth;
  final Widget? child;

  const Section({super.key, this.fullWidth = false, this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: (fullWidth) ? 0 : 20),
      margin: const EdgeInsets.only(bottom: 20),
      child: child,
    );
  }
}
