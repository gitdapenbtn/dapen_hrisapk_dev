import 'package:flutter/material.dart';

class LayoutBackButton extends StatelessWidget {
  final EdgeInsets? margin;

  const LayoutBackButton({ 
    super.key,
    this.margin,
  });
  
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: Navigator.canPop(context),
      child: Container(
        margin: margin,
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back),
        ),
      )
    );
  }
}