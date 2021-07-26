import 'package:firebase_flutter_starter/bloc/account_deletion_bloc.dart';
import 'package:firebase_flutter_starter/widgets/aware_alert_dialog.dart';
import 'package:firebase_flutter_starter/widgets/aware_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../services/navigation_service.dart';
import '../widgets/aware_button.dart';

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
                  showDialog(
                    context: context,
                    builder: (context) => UserPasswordPrompt(),
                  );
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}

class UserPasswordPrompt extends StatelessWidget {
  final AccountDeletionBloc _accountDeletionBloc = AccountDeletionBloc();

  @override
  Widget build(BuildContext context) {
    final TextEditingController _textFieldController = TextEditingController();
    final NavigationService _navigationService =
        GetIt.instance.get<NavigationService>();
    return Material(
      type: MaterialType.transparency,
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
                  onPressed: () => Navigator.of(context).pop(),
                )
              ],
            );
          }
          if (state is AccountDeletionError) {
            return AwareAlertDialog(
              title: Text(
                'Enter your password to confirm account deletion.',
                textAlign: TextAlign.center,
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
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
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    _accountDeletionBloc.add(
                      DeleteAccount(
                        enteredPassword: _textFieldController.text,
                        navigationService: _navigationService,
                      ),
                    );
                  },
                  child: Text(
                    'Delete Account',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
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
