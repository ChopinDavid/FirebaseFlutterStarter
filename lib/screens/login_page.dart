import 'package:firebase_flutter_starter/bloc/auth_bloc.dart';
import 'package:firebase_flutter_starter/models/routes.dart';
import 'package:firebase_flutter_starter/services/navigation_service.dart';
import 'package:firebase_flutter_starter/widgets/aware_alert_dialog.dart';
import 'package:firebase_flutter_starter/widgets/aware_button.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(listener: (context, state) async {
        if (state is AuthSignupError) {
          Navigator.of(context).pop();
          await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AwareAlertDialog(
                  key: Key('error-dialog'),
                  title: Text('Error'),
                  content: Text(state.error.toString()),
                  actions: <Widget>[
                    AwareButton(
                      child: Text('Ok'),
                      onPressed: () {
                        BlocProvider.of<AuthBloc>(context)
                            .add(ResetAuthState());
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              });
          BlocProvider.of<AuthBloc>(context).add(ResetAuthState());
        }

        if (state is AuthLoading) {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => Center(child: CircularProgressIndicator()),
          );
        }

        if (state is AuthLoginComplete) {
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
                  padding:
                      EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                        obscureText: true,
                      ),
                      SizedBox(height: 40),
                      Center(
                        child: AwareButton(
                          key: Key('login-button-key'),
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              BlocProvider.of<AuthBloc>(context).add(
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
            ],
          ),
        );
      }),
    );
  }
}
