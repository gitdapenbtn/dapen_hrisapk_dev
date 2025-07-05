import 'package:flutter/material.dart';

class LayoutBottomSheet extends StatelessWidget {
  final String? title;
  final List<Widget>? children;

  const LayoutBottomSheet({
    super.key,
    this.title,
    this.children,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20)
          ),
          border: Border.all(
            color: Colors.black12
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, -1),
              blurRadius: 10
            ),
          ]
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: (title != null),
              child: Container(
                margin: const EdgeInsets.only(bottom: 20),
                alignment: Alignment.center,
                child: Text(
                  '$title',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ),
            ...children ?? [],
          ],
        ),
      ),
    );
  }
}