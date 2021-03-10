import 'dart:io';

import 'package:firebase_flutter_starter/models/routes.dart';
import 'package:firebase_flutter_starter/services/document_service.dart';
import 'package:firebase_flutter_starter/services/navigation_service.dart';
import 'package:firebase_flutter_starter/utils/starter_icons.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePicture extends StatelessWidget {
  final bool editable;
  final String? url;
  final File? file;
  final Function(File?, dynamic?)? onImageSelected;

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
                        file!,
                        fit: BoxFit.cover,
                        key: UniqueKey(),
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
                    FocusScope.of(context).unfocus();
                    GetIt.instance
                        .get<NavigationService>()
                        .pushNamed(Routes.IMAGESOURCE,
                            arguments: (ImageSource imageSource) async {
                      final pickedImage = await _picker.getImage(
                        source: imageSource,
                      );
                      if (onImageSelected != null) {
                        File? imageFile = await GetIt.instance
                            .get<DocumentService>()
                            .saveImageFromBytes(
                                bytes: await pickedImage!.readAsBytes(),
                                relativePath: 'profilePicture');

                        onImageSelected!(imageFile, null);
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
