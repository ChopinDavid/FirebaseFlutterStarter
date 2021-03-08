import 'dart:io';

import 'package:firebase_flutter_starter/bloc/auth_bloc.dart';
import 'package:firebase_flutter_starter/models/routes.dart';
import 'package:firebase_flutter_starter/models/string_validator.dart';
import 'package:firebase_flutter_starter/services/navigation_service.dart';
import 'package:firebase_flutter_starter/widgets/aware_alert_dialog.dart';
import 'package:firebase_flutter_starter/widgets/aware_button.dart';
import 'package:firebase_flutter_starter/widgets/backdrop_widget.dart';
import 'package:firebase_flutter_starter/widgets/profile_picture.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  File? _imageFile;

  @override
  Widget build(BuildContext context) {
    final AuthBloc _authBloc = AuthBloc();
    return Scaffold(
      appBar: AppBar(
        title: Text('Signup'),
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
          bloc: _authBloc,
          builder: (scaffoldContext, state) {
            if (state is AuthSignupComplete) {
              final navigationService = GetIt.instance.get<NavigationService>();
              SchedulerBinding.instance?.addPostFrameCallback(
                  (_) => navigationService.pushNamed(Routes.TABBAR));
            }
            return Container(
              color: Colors.white,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      padding:
                          EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: ProfilePicture(
                              file: _imageFile,
                              editable: true,
                              onImageSelected: (file, error) {
                                if (file != null) {
                                  setState(() {
                                    _imageFile = file;
                                  });
                                }
                              },
                            ),
                          ),
                          SizedBox(height: 40),
                          Text('First Name'),
                          TextFormField(
                            controller: firstNameController,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.words,
                            validator: (firstName) {
                              if ((firstName?.length ?? 0) < 1) {
                                return 'Please enter a first name...';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 40),
                          Text('Last Name'),
                          TextFormField(
                            controller: lastNameController,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.words,
                            validator: (lastName) {
                              if ((lastName?.length ?? 0) < 1) {
                                return 'Please enter a last name...';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 40),
                          Text('Email'),
                          TextFormField(
                            controller: emailController,
                            autocorrect: false,
                            keyboardType: TextInputType.emailAddress,
                            validator: (email) {
                              return StringValidator.isValidEmail(email);
                            },
                          ),
                          SizedBox(height: 40),
                          Text('Password'),
                          TextFormField(
                            controller: passwordController,
                            autocorrect: false,
                            validator: (password) {
                              return StringValidator.isValidPassword(password);
                            },
                            obscureText: true,
                          ),
                          SizedBox(height: 40),
                          Text('Confirm Password'),
                          TextFormField(
                            autocorrect: false,
                            validator: (confirmPassword) {
                              if (confirmPassword != passwordController.text) {
                                return 'Passwords must match...';
                              }
                              return null;
                            },
                            obscureText: true,
                          ),
                          SizedBox(height: 40),
                          Center(
                            child: AwareButton(
                              onPressed: () {
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  _authBloc.add(
                                    SignupUserWithEmailAndPassword(
                                      firstName: firstNameController.text,
                                      lastName: lastNameController.text,
                                      email: emailController.text,
                                      password: passwordController.text,
                                      profilePicture: _imageFile != null
                                          ? File(_imageFile!.path)
                                          : null,
                                    ),
                                  );
                                }
                              },
                              child: Text('Signup'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (state is AuthSignupError)
                    BackdropWidget(
                      child: AwareAlertDialog(
                        title: Text('Error'),
                        content: Text(state.error.message ?? 'Unknown error'),
                        actions: <Widget>[
                          AwareButton(
                            child: Text('Ok'),
                            onPressed: () {
                              _authBloc.add(ResetAuthState());
                            },
                          ),
                        ],
                      ),
                    ),
                  if (state is AuthLoading)
                    BackdropWidget(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                ],
              ),
            );
          }),
    );
  }
}
