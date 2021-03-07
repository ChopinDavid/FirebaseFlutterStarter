import 'dart:io';

import 'package:firebase_flutter_starter/models/routes.dart';
import 'package:firebase_flutter_starter/services/navigation_service.dart';
import 'package:firebase_flutter_starter/utils/starter_icons.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePicture extends StatelessWidget {
  final bool editable;
  final String? url;
  final PickedFile? file;
  final Function(PickedFile?, dynamic?)? onImageSelected;

  ProfilePicture(
      {this.editable = false, this.url, this.file, this.onImageSelected});

  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
          ),
          child: Stack(fit: StackFit.expand, children: [
            url == null
                ? file == null
                    ? Image.asset(
                        'assets/images/user.png',
                        fit: BoxFit.cover,
                      )
                    : Image.file(
                        File(file!.path),
                        fit: BoxFit.cover,
                      )
                : Image.network(
                    url!,
                    fit: BoxFit.cover,
                  ),
            if (editable)
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () async {
                    GetIt.instance
                        .get<NavigationService>()
                        .pushNamed(Routes.IMAGESOURCE,
                            arguments: (ImageSource imageSource) async {
                      try {
                        final pickedFile = await _picker.getImage(
                          source: imageSource,
                        );
                        if (onImageSelected != null) {
                          onImageSelected!(pickedFile, null);
                        }
                      } catch (e) {
                        if (onImageSelected != null) {
                          onImageSelected!(null, e);
                        }
                      }
                    });
                  },
                ),
              ),
          ]),
          clipBehavior: Clip.hardEdge,
        ),
        if (editable)
          Padding(
            padding: const EdgeInsets.only(left: 80),
            child: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: Colors.lightBlueAccent,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                StarterIcons.pencil,
                color: Colors.white,
                size: 15,
              ),
            ),
          )
      ],
    );
  }
}
