import 'package:flutter/material.dart';

class BackdropWidget extends StatelessWidget {
  final Widget child;
  final VoidCallback? onBackgroundTap;

  BackdropWidget({required this.child, this.onBackgroundTap});
  @override
  Widget build(BuildContext context) {
    final Stack contentStack = Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: double.maxFinite,
          width: double.maxFinite,
          color: Colors.black.withAlpha(50),
        ),
        child,
      ],
    );
    return onBackgroundTap == null
        ? contentStack
        : GestureDetector(
            onTap: onBackgroundTap,
            child: contentStack,
          );
  }
}
