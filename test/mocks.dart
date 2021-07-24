import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_flutter_starter/models/firebase_flutter_starter_user.dart';
import 'package:firebase_flutter_starter/services/firestore_service.dart';
import 'package:firebase_flutter_starter/services/navigation_service.dart';
import 'package:firebase_flutter_starter/services/shared_preferences_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockNavigationService extends Mock implements NavigationService {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockFirestoreService extends Mock implements FirestoreService {}

class MockSharedPreferencesService extends Mock
    implements SharedPreferencesService {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

class MockUserCredential extends Mock implements UserCredential {}

class MockUser extends Mock implements User {}

class MockFirebaseFlutterStarterUser extends Mock
    implements FirebaseFlutterStarterUser {}
