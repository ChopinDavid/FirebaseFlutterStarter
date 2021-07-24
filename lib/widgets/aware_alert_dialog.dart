import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AwareAlertDialog extends StatelessWidget {
  final Widget? title;
  final Widget? content;
  final List<Widget> actions;
  final bool iOSActionSheetEnabled;

  AwareAlertDialog(
      {this.title,
      this.content,
      this.actions = const [],
      this.iOSActionSheetEnabled = false,
      Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      if (iOSActionSheetEnabled) {
        return Column(
          children: [
            Spacer(),
            CupertinoActionSheet(
              title: title,
              message: content,
              actions: actions,
              cancelButton: CupertinoButton(
                child: Text('Cancel'),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        );
      }
      return CupertinoAlertDialog(
        title: title,
        content: content,
        actions: actions,
      );
    }
    return AlertDialog(
      title: title,
      content: content,
      actions: actions,
    );
  }
}
