import 'package:firebase_flutter_starter/bloc/account_deletion_bloc.dart';
import 'package:firebase_flutter_starter/widgets/aware_alert_dialog.dart';
import 'package:firebase_flutter_starter/widgets/aware_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../services/navigation_service.dart';
import '../widgets/aware_button.dart';
import '../widgets/backdrop_widget.dart';

class AccountSettingsPage extends StatefulWidget {
  @override
  _AccountSettingsPageState createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  bool isPasswordPromptDisplayed = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Settings'),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              AwareButton(
                child: Text('Delete Account'),
                onPressed: () {
                  setState(() {
                    isPasswordPromptDisplayed = true;
                  });
                },
              )
            ],
          ),
          if (isPasswordPromptDisplayed)
            UserPasswordPrompt(
              onCancelled: () {
                setState(() {
                  isPasswordPromptDisplayed = false;
                });
              },
            )
        ],
      ),
    );
  }
}

class UserPasswordPrompt extends StatelessWidget {
  final VoidCallback? onCancelled;
  UserPasswordPrompt({this.onCancelled});
  final AccountDeletionBloc _accountDeletionBloc = AccountDeletionBloc();

  @override
  Widget build(BuildContext context) {
    final TextEditingController _textFieldController = TextEditingController();
    final NavigationService _navigationService =
        GetIt.instance.get<NavigationService>();
    return BackdropWidget(
      onBackgroundTap: onCancelled,
      child: BlocBuilder<AccountDeletionBloc, AccountDeletionState>(
        bloc: _accountDeletionBloc,
        builder: (context, state) {
          if (state is AccountDeletionInitial) {
            return AwareAlertDialog(
              title: Text('Are you sure you want to delete your account?'),
              content: Text('This action cannot be undone...'),
              actions: [
                TextButton(
                  child: Text(
                    'Delete Account',
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () => _accountDeletionBloc.add(
                    DeleteAccount(
                      enteredPassword: null,
                      navigationService: _navigationService,
                    ),
                  ),
                ),
                TextButton(
                  child: Text('Cancel'),
                  onPressed: onCancelled,
                )
              ],
            );
          }
          if (state is AccountDeletionError) {
            return Padding(
              padding: const EdgeInsets.all(50.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Enter your password to confirm account deletion.',
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      AwareTextField(
                        controller: _textFieldController,
                        hintText: 'Password',
                        isObscure: true,
                      ),
                      if (state is AccountDeletionWrongPassword)
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Text(
                            'Incorrect password...',
                            textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          _accountDeletionBloc.add(
                            DeleteAccount(
                              enteredPassword: _textFieldController.text,
                              navigationService: _navigationService,
                            ),
                          );
                        },
                        child: Text('Delete Account'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
