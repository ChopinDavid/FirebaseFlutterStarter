import 'dart:io';
import 'dart:math';

import 'package:app_settings/app_settings.dart';
import 'package:firebase_flutter_starter/bloc/auth_bloc.dart';
import 'package:firebase_flutter_starter/models/firebase_flutter_starter_user.dart';
import 'package:firebase_flutter_starter/services/document_service.dart';
import 'package:firebase_flutter_starter/services/firestore_service.dart';
import 'package:firebase_flutter_starter/services/navigation_service.dart';
import 'package:firebase_flutter_starter/services/shared_preferences_service.dart';
import 'package:firebase_flutter_starter/widgets/aware_alert_dialog.dart';
import 'package:firebase_flutter_starter/widgets/aware_button.dart';
import 'package:firebase_flutter_starter/widgets/backdrop_widget.dart';
import 'package:firebase_flutter_starter/widgets/profile_picture.dart';
import 'package:firebase_flutter_starter/widgets/skeleton_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:tuple/tuple.dart';

import '../models/routes.dart';

class ProfilePage extends StatefulWidget {
  final VoidCallback onProfilePictureUpdated;
  ProfilePage({required this.onProfilePictureUpdated});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthBloc _authBloc = AuthBloc();

  bool isDisplayingOnImageSelectedError = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (_) => _authBloc,
      child: Scaffold(
        appBar: AppBar(
          title: FutureBuilder<FirebaseFlutterStarterUser?>(
            future:
                GetIt.instance.get<SharedPreferencesService>().getCurrentUser(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Container();
                default:
                  if (!snapshot.hasError &&
                      snapshot.hasData &&
                      snapshot.data != null) {
                    return Text(
                        '${snapshot.data!.firstName} ${snapshot.data!.lastName}');
                  }
                  return Text('Profile');
              }
            },
          ),
          automaticallyImplyLeading: false,
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final Column column = Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FutureBuilder<Tuple2<File, bool>>(
                      future: GetIt.instance
                          .get<DocumentService>()
                          .getImage(relativePath: 'profilePicture')
                          .then((file) async {
                        return file
                            .exists()
                            .then((fileExists) => Tuple2(file, fileExists));
                      }),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return SkeletonWidget(
                              borderRadius: BorderRadius.circular(50),
                              child: Container(
                                height: 100,
                                width: 100,
                                color: Colors.grey,
                              ),
                            );
                          default:
                            if (snapshot.hasError)
                              return Image.asset(
                                'assets/images/user.png',
                                fit: BoxFit.cover,
                              );
                            else
                              return ProfilePicture(
                                file: snapshot.data!.item2
                                    ? snapshot.data!.item1
                                    : null,
                                editable: true,
                                onImageSelected: (file, error) {
                                  widget.onProfilePictureUpdated();
                                  if (file != null) {
                                    GetIt.instance
                                        .get<SharedPreferencesService>()
                                        .getCurrentUser()
                                        .then((user) {
                                      if (user != null) {
                                        return GetIt.instance
                                            .get<FirestoreService>()
                                            .updateUserProfilePicture(
                                                uid: user.uid,
                                                profilePicture: file);
                                      }
                                      throw Exception('Unable to get user');
                                    });
                                  }
                                },
                                onImageSelectedError: () {
                                  setState(() {
                                    isDisplayingOnImageSelectedError = true;
                                  });
                                },
                              );
                        }
                      },
                    ),
                    Column(
                      children: [
                        AwareButton(
                          child: Text('Account Settings'),
                          onPressed: () => GetIt.instance
                              .get<NavigationService>()
                              .pushNamed(Routes.ACCOUNTSETTINGS),
                        ),
                        AwareButton(
                          child: Text('Logout'),
                          onPressed: () => _authBloc.add(
                            SignOut(
                              navigationService:
                                  GetIt.instance.get<NavigationService>(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
                final CustomPaint columnPaint = CustomPaint(
                  child: column,
                );
                final double columnHeight = columnPaint.size.height;
                return SingleChildScrollView(
                  padding: EdgeInsets.all(24),
                  child: Container(
                    height: max(constraints.maxHeight - 48, columnHeight),
                    width: constraints.maxWidth,
                    child: column,
                  ),
                );
              },
            ),
            if (isDisplayingOnImageSelectedError)
              BackdropWidget(
                child: AwareAlertDialog(
                  title: Text('We need photo access for that...'),
                  content: Text(Platform.isIOS
                      ? "To set a profile picture, we're gonna need access to your photos. This can be done via the Settings app."
                      : "To set a profile picture, we're gonna need access to your photos. This can be granted via the Settings app by clicking on the \"Permissions\" button."),
                  actions: <Widget>[
                    AwareButton(
                      child: Text('Settings'),
                      onPressed: AppSettings.openAppSettings,
                    ),
                    AwareButton(
                      child: Text('Cancel'),
                      onPressed: () {
                        setState(() {
                          isDisplayingOnImageSelectedError = false;
                        });
                      },
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
