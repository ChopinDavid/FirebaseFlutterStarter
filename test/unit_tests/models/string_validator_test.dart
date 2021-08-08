import 'package:firebase_flutter_starter/models/string_validator.dart';
import 'package:test/test.dart';

void main() {
  group('isValidEmail', () {
    test('valid passwords', () {
      expect(StringValidator.isValidPassword('Novels9@'), null);
    });

    test('invalid passwords', () {
      expect(StringValidator.isValidPassword('novels9@'),
          'Password must have 1 uppercase character...');
      expect(StringValidator.isValidPassword('Novels@@'),
          'Password must have 1 number...');
      expect(StringValidator.isValidPassword('Novel9@'),
          'Password must have at least 8 characters...');
      expect(StringValidator.isValidPassword('Novels99'),
          'Password must have 1 special character...');
      expect(StringValidator.isValidPassword('novel9@'),
          'Password must have 1 uppercase character and at least 8 characters...');
      expect(StringValidator.isValidPassword('novel99'),
          'Password must have 1 uppercase character, 1 special character, and at least 8 characters...');
    });
  });
}
