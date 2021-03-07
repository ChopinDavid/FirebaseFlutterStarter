import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_flutter_starter/dependency_configuration.dart';
import 'package:firebase_flutter_starter/models/routes.dart';
import 'package:firebase_flutter_starter/screens/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  DependencyConfiguration.setUp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Create the initialization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        Widget homeWidget;
        // Check for errors
        if (snapshot.hasError) {
          homeWidget = Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Text(
                snapshot.error.toString(),
              ),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          // Once complete, show your application
          homeWidget = WelcomePage();
        } else {
          // Otherwise, show something whilst waiting for initialization to complete
          homeWidget = Container(
            color: Colors.green,
          );
        }

        return MaterialApp(
          title: 'Flutter Demo',
          navigatorKey: GetIt.instance<GlobalKey<NavigatorState>>(),
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: homeWidget,
          onGenerateRoute: (settings) =>
              Routes.generateRoutes(context, settings),
        );
      },
    );
  }
}
