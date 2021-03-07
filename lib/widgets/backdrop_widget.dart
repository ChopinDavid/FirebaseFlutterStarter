import 'package:flutter/material.dart';

class BackdropWidget extends StatelessWidget {
  final Widget child;

  BackdropWidget({required this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
        height: double.maxFinite,
        width: double.maxFinite,
        color: Colors.black.withAlpha(50),
        child: child);
  }
}
