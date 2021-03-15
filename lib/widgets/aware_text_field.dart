import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AwareTextField extends StatelessWidget {
  final String? hintText;
  final TextEditingController? controller;
  final bool isObscure;
  AwareTextField({
    this.hintText,
    this.controller,
    this.isObscure = false,
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoTextField(
        controller: controller,
        placeholder: hintText,
        obscureText: isObscure,
      );
    }
    return TextField(
      controller: controller,
      decoration: new InputDecoration(
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        contentPadding:
            EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
        hintText: hintText,
      ),
      obscureText: isObscure,
    );
  }
}
