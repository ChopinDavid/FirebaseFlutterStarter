import 'package:firebase_flutter_starter/services/document_service.dart';
import 'package:firebase_flutter_starter/services/firestore_service.dart';
import 'package:firebase_flutter_starter/services/navigation_service.dart';
import 'package:firebase_flutter_starter/services/shared_preferences_service.dart';
import 'package:firebase_flutter_starter/services/storage_service.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

class DependencyConfiguration {
  static void setUp() {
    final GetIt getIt = GetIt.instance;
    getIt.registerSingleton<GlobalKey<NavigatorState>>(
        GlobalKey<NavigatorState>());
    getIt.registerSingleton<NavigationService>(
        NavigationService(navKey: getIt<GlobalKey<NavigatorState>>()));
    getIt.registerSingleton<FirestoreService>(FirestoreService());
    getIt.registerSingleton<StorageService>(StorageService());
    getIt.registerSingleton<DocumentService>(DocumentService());
    getIt.registerSingleton<SharedPreferencesService>(
        SharedPreferencesService());
  }
}
