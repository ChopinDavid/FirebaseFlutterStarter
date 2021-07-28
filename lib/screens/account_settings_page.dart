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
  final AccountDeletionBloc? injectedAccountDeletionBloc;
  AccountSettingsPage({this.injectedAccountDeletionBloc});

  @override
  _AccountSettingsPageState createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
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
                key: Key('initial-delete-account-button'),
                child: Text('Delete Account'),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => BlocProvider<AccountDeletionBloc>(
                        create: (_) =>
                            widget.injectedAccountDeletionBloc != null
                                ? widget.injectedAccountDeletionBloc!
                                : AccountDeletionBloc(),
                        child: UserPasswordPrompt()),
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
  @override
  Widget build(BuildContext context) {
    final TextEditingController _textFieldController = TextEditingController();
    return Material(
      type: MaterialType.transparency,
      child: BlocConsumer<AccountDeletionBloc, AccountDeletionState>(
        bloc: BlocProvider.of<AccountDeletionBloc>(context),
        listener: (context, state) {
          if (state is AccountDeletionSuccess) {
            GetIt.instance.get<NavigationService>().popToRoot();
          }
        },
        builder: (context, state) {
          if (state is AccountDeletionInitial) {
            return AwareAlertDialog(
              key: Key('account-deletion-verification-dialog'),
              title: Text('Are you sure you want to delete your account?'),
              content: Text('This action cannot be undone...'),
              actions: [
                TextButton(
                  key: Key('final-delete-account-button'),
                  child: Text(
                    'Delete Account',
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () =>
                      BlocProvider.of<AccountDeletionBloc>(context).add(
                    DeleteAccount(
                      enteredPassword: null,
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
              key: Key('enter-password-modal'),
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
                        key: Key('wrong-password-text'),
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    BlocProvider.of<AccountDeletionBloc>(context).add(
                      DeleteAccount(
                        enteredPassword: _textFieldController.text,
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
