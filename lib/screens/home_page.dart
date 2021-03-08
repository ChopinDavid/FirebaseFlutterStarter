import 'package:firebase_flutter_starter/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthBloc _authBloc = AuthBloc();
    return BlocProvider<AuthBloc>(
      create: (_) => _authBloc,
      child: Scaffold(
        body: SafeArea(
          child: Center(child: Text('This is the home page!')),
        ),
      ),
    );
  }
}
