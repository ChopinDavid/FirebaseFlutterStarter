import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AwareButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  AwareButton({required this.child, required this.onPressed});
  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoButton(
        child: Center(child: child),
        onPressed: onPressed,
      );
    }
    return MaterialButton(
      child: Center(child: child),
      onPressed: onPressed,
    );
  }
}
