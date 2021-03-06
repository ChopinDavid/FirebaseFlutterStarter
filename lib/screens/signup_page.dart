import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:firebase_flutter_starter/bloc/auth_bloc.dart';
import 'package:firebase_flutter_starter/models/routes.dart';
import 'package:firebase_flutter_starter/models/string_validator.dart';
import 'package:firebase_flutter_starter/services/navigation_service.dart';
import 'package:firebase_flutter_starter/widgets/aware_alert_dialog.dart';
import 'package:firebase_flutter_starter/widgets/aware_button.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Signup'),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(listener: (context, state) async {
        if (state is AuthSignupError) {
          Navigator.of(context).pop();
          await showDialog(
            context: context,
            builder: (context) => AwareAlertDialog(
              title: Text('Error'),
              content: Text(state.error.toString()),
              actions: <Widget>[
                AwareButton(
                  child: Text('Ok'),
                  onPressed: () {
                    BlocProvider.of<AuthBloc>(context).add(ResetAuthState());
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
          BlocProvider.of<AuthBloc>(context).add(ResetAuthState());
        }

        if (state is AuthLoading) {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => Center(child: CircularProgressIndicator()),
          );
        }

        if (state is AuthSignupComplete) {
          final navigationService = GetIt.instance.get<NavigationService>();
          SchedulerBinding.instance?.addPostFrameCallback(
              (_) => navigationService.pushNamed(Routes.TABBAR));
        }
      }, builder: (scaffoldContext, state) {
        return Container(
          color: Colors.white,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
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
                          onImageSelectedError: () {
                            showDialog(
                              context: context,
                              builder: (context) => AwareAlertDialog(
                                title: Text('We need photo access for that...'),
                                content: Text(Platform.isIOS
                                    ? "To set a profile picture, we're gonna need access to your photos. This can be granted via the Settings app."
                                    : "To set a profile picture, we're gonna need access to your photos. This can be granted via the Settings app by clicking on the \"Permissions\" button."),
                                actions: <Widget>[
                                  AwareButton(
                                    child: Text('Settings'),
                                    onPressed: AppSettings.openAppSettings,
                                  ),
                                  AwareButton(
                                    child: Text('Cancel'),
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 40),
                      Text('First Name'),
                      TextFormField(
                        key: Key('first-name-field'),
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
                        key: Key('last-name-field'),
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
                        key: Key('email-field'),
                        controller: emailController,
                        autocorrect: false,
                        keyboardType: TextInputType.emailAddress,
                        validator: (email) {
                          return email?.length == 0
                              ? 'Please enter an email address...'
                              : null;
                        },
                      ),
                      SizedBox(height: 40),
                      Text('Password'),
                      TextFormField(
                        key: Key('password-field'),
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
                        key: Key('confirm-password-field'),
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
                          key: Key('signup-button-key'),
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              BlocProvider.of<AuthBloc>(context).add(
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
            ],
          ),
        );
      }),
    );
  }
}
