import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_flutter_starter/models/routes.dart';
import 'package:firebase_flutter_starter/services/navigation_service.dart';
import 'package:firebase_flutter_starter/widgets/aware_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get_it/get_it.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  void initState() {
    if (GetIt.instance.get<FirebaseAuth>().currentUser != null) {
      final navigationService = GetIt.instance.get<NavigationService>();
      SchedulerBinding.instance?.addPostFrameCallback(
          (_) => navigationService.pushNamed(Routes.TABBAR));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.maxFinite,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AwareButton(
              key: Key('login-key'),
              child: Text('Login'),
              onPressed: () {
                final navigationService =
                    GetIt.instance.get<NavigationService>();
                navigationService.pushNamed(Routes.LOGIN);
              },
            ),
            AwareButton(
              key: Key('signup-button-key'),
              child: Text('Signup'),
              onPressed: () {
                final navigationService =
                    GetIt.instance.get<NavigationService>();
                navigationService.pushNamed(Routes.SIGNUP);
              },
            ),
          ],
        ),
      ),
    );
  }
}
