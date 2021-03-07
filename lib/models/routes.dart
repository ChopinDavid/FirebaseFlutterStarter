import 'package:firebase_flutter_starter/screens/home_page.dart';
import 'package:firebase_flutter_starter/screens/login_page.dart';
import 'package:firebase_flutter_starter/screens/signup_page.dart';
import 'package:firebase_flutter_starter/screens/welcome_page.dart';
import 'package:firebase_flutter_starter/widgets/image_source_overlay.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Routes {
  static const String WELCOME = '/welcome';
  static const String LOGIN = '/login';
  static const String SIGNUP = '/signup';
  static const String IMAGESOURCE = '/image_source';
  static const String HOME = '/home';

  static Route<dynamic>? generateRoutes(
    BuildContext context,
    RouteSettings settings,
  ) {
    switch (settings.name) {
      case WELCOME:
        return MaterialPageRoute(
          builder: (context) => WelcomePage(),
          settings: RouteSettings(name: WELCOME),
        );
      case LOGIN:
        return MaterialPageRoute(builder: (_) {
          return LoginPage();
        });
      case SIGNUP:
        return MaterialPageRoute(builder: (_) {
          return SignupPage();
        });
      case IMAGESOURCE:
        return ImageSourceOverlay(
            onImageSourcePicked: settings.arguments as Function(ImageSource));
      case HOME:
        return MaterialPageRoute(builder: (_) {
          return HomePage();
        });
    }
  }
}
