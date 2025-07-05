import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String? title;
  final Function? onPressed;
  final EdgeInsets? margin;

  const SectionTitle(this.title, { 
    super.key,
    this.onPressed,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      margin: margin,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title ?? '',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          Visibility(
            visible: onPressed != null,
            child: InkWell(
              splashColor: Colors.transparent,
              onTap: () {
                onPressed!();
              },
              child: const Text(
                'Lihat Semua', 
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}