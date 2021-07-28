import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_flutter_starter/bloc/auth_bloc.dart';
import 'package:firebase_flutter_starter/dependency_configuration.dart';
import 'package:firebase_flutter_starter/models/routes.dart';
import 'package:firebase_flutter_starter/screens/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Create the initialization Future outside of `build`:
  final FirebaseApp _initialization = await Firebase.initializeApp();
  await DependencyConfiguration.setUp();
  runApp(MyApp(
    initialization: _initialization,
  ));
}

class MyApp extends StatelessWidget {
  final FirebaseApp initialization;
  MyApp({required this.initialization});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (context) => AuthBloc()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        navigatorKey: GetIt.instance<GlobalKey<NavigatorState>>(),
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: WelcomePage(),
        onGenerateRoute: (settings) => Routes.generateRoutes(context, settings),
      ),
    );
  }
}
