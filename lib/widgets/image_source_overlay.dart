import 'package:firebase_flutter_starter/widgets/aware_alert_dialog.dart';
import 'package:firebase_flutter_starter/widgets/aware_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageSourceOverlay extends ModalRoute {
  final Function(ImageSource) onImageSourcePicked;
  ImageSourceOverlay({required this.onImageSourcePicked});

  @override
  Duration get transitionDuration => Duration(milliseconds: 200);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => true;

  @override
  Color get barrierColor => Colors.black.withOpacity(0.5);

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return Material(
      type: MaterialType.transparency,
      child: AwareAlertDialog(
        iOSActionSheetEnabled: true,
        title: Text(
          'Add Image',
          textAlign: TextAlign.center,
        ),
        content: Text(
          'Pick from Photo Gallery or take with camera?',
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          AwareButton(
            child: Text(
              'Photo Gallery',
              textAlign: TextAlign.center,
            ),
            onPressed: () {
              Navigator.pop(context);
              onImageSourcePicked(ImageSource.gallery);
            },
          ),
          AwareButton(
            child: Text(
              'Camera',
              textAlign: TextAlign.center,
            ),
            onPressed: () {
              Navigator.pop(context);
              onImageSourcePicked(ImageSource.camera);
            },
          ),
        ],
      ),
    );
  }
}
