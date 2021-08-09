import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navKey;

  NavigationService({required this.navKey});

  void pushReplacementNamed(
    String routeName, {
    Object? arguments,
  }) =>
      navKey.currentState?.pushReplacementNamed(
        routeName,
        arguments: arguments,
      );

  void pop() => navKey.currentState?.pop();

  void popToRoot() => navKey.currentState?.popUntil((route) {
        if (route.isFirst) {
          imageCache!.clear();
          imageCache!.clearLiveImages();
          return true;
        }
        return false;
      });

  void pushNamed(
    String routeName, {
    Object? arguments,
  }) =>
      navKey.currentState?.pushNamed(
        routeName,
        arguments: arguments,
      );
}
