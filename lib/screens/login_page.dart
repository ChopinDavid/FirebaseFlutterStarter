import 'package:firebase_flutter_starter/bloc/auth_bloc.dart';
import 'package:firebase_flutter_starter/models/routes.dart';
import 'package:firebase_flutter_starter/models/string_validator.dart';
import 'package:firebase_flutter_starter/services/navigation_service.dart';
import 'package:firebase_flutter_starter/widgets/aware_alert_dialog.dart';
import 'package:firebase_flutter_starter/widgets/aware_button.dart';
import 'package:firebase_flutter_starter/widgets/backdrop_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final AuthBloc _authBloc = AuthBloc();
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
          bloc: _authBloc,
          builder: (scaffoldContext, state) {
            if (state is AuthLoginComplete) {
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
                      padding: EdgeInsets.symmetric(
                          vertical: 40.0, horizontal: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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
                            obscureText: true,
                          ),
                          SizedBox(height: 40),
                          Center(
                            child: AwareButton(
                              onPressed: () {
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  _authBloc.add(
                                    LoginUserWithEmailAndPassword(
                                      email: emailController.text,
                                      password: passwordController.text,
                                    ),
                                  );
                                }
                              },
                              child: Text('Login'),
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
                        content: Text(state.error.toString()),
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
