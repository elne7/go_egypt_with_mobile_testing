import 'package:flutter_test/flutter_test.dart';
import 'package:go_egypt_with_firebase/features/auth/presentation/views/login_page.dart';

void main() {
  group('Login Email Validator Tests', () {
    test('should return null when email is valid', () {
      expect(loginEmailValidator("team9@gmail.com"), isNull);
    });

    test('should return error message when email does not contain @', () {
      expect(loginEmailValidator("invalidemail"), "Please enter a valid email");
    });

    test('should return error message when email is empty', () {
      expect(loginEmailValidator(""), "Please enter a valid email");
    });

    test('should return error message when email is null', () {
      expect(loginEmailValidator(null), "Please enter a valid email");
    });
  });
}
