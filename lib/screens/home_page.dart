import 'package:firebase_flutter_starter/bloc/auth_bloc.dart';
import 'package:firebase_flutter_starter/services/navigation_service.dart';
import 'package:firebase_flutter_starter/widgets/aware_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthBloc _authBloc = AuthBloc();
    return BlocProvider<AuthBloc>(
      create: (_) => _authBloc,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AwareButton(
                child: Text('< Logout'),
                onPressed: () {
                  _authBloc.add(SignOut(
                      navigationService:
                          GetIt.instance.get<NavigationService>()));
                },
              ),
              Center(
                child: Text('This is the home page!'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
