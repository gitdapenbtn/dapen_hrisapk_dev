import 'package:flutter/material.dart';
import 'package:dpbtn_absen/layouts/constants/layout_color.dart';
import 'package:dpbtn_absen/layouts/parts/layout_back_button.dart';

class LayoutAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? action;
  final LayoutAppBarBottom? bottom;

  const LayoutAppBar({
    super.key,
    this.title,
    this.bottom,
    this.action,
  });

  @override
  Size get preferredSize => Size.fromHeight(
      kToolbarHeight + (bottom != null ? bottom!.preferredSize.height : 0));

  @override
  Widget build(BuildContext context) {
    final double safeAreaHeight = MediaQuery.of(context).padding.top;

    return Container(
      padding: EdgeInsets.only(
        top: safeAreaHeight,
        left: 20,
        right: 20,
      ),
      height: safeAreaHeight + preferredSize.height,
      decoration: const BoxDecoration(color: LayoutColor.primary, boxShadow: [
        BoxShadow(
          color: Colors.black12,
          offset: Offset(0, 5),
          blurRadius: 10,
        )
      ]),
      child: Column(children: [
        SizedBox(
          height: kToolbarHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                  child: Row(
                children: [
                  const LayoutBackButton(
                    margin: EdgeInsets.only(right: 20),
                  ),
                  Text(
                    '$title',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: LayoutColor.textPrimary,
                    ),
                  ),
                ],
              )),
              ...action ?? [],
            ],
          ),
        ),
        if (bottom != null) bottom!,
      ]),
    );
  }
}

class LayoutAppBarBottom extends StatelessWidget
    implements PreferredSizeWidget {
  final double? height;
  final Widget? child;

  const LayoutAppBarBottom({
    super.key,
    this.height,
    this.child,
  });

  @override
  Size get preferredSize => Size.fromHeight(height ?? kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      height: height,
      child: child,
    );
  }
}
