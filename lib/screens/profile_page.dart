import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_flutter_starter/bloc/auth_bloc.dart';
import 'package:firebase_flutter_starter/services/document_service.dart';
import 'package:firebase_flutter_starter/services/navigation_service.dart';
import 'package:firebase_flutter_starter/widgets/aware_button.dart';
import 'package:firebase_flutter_starter/widgets/profile_picture.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthBloc _authBloc = AuthBloc();
    return BlocProvider<AuthBloc>(
      create: (_) => _authBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text('TODO: put user\'s name here'),
          automaticallyImplyLeading: false,
        ),
        body: Column(
          children: [
            FutureBuilder<File>(
              future: GetIt.instance
                  .get<DocumentService>()
                  .getImage(relativePath: 'profilePicture'),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Text('Loading....');
                  default:
                    if (snapshot.hasError)
                      return Text('Error: ${snapshot.error}');
                    else
                      return ProfilePicture(
                        file: snapshot.data,
                      );
                }
              },
            ),
            Spacer(),
            AwareButton(
              child: Text('Logout'),
              onPressed: () {
                _authBloc.add(
                  SignOut(
                    navigationService: GetIt.instance.get<NavigationService>(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
