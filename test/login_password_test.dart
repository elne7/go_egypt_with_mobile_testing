import 'package:flutter_test/flutter_test.dart';
import 'package:go_egypt_with_firebase/features/auth/presentation/views/login_page.dart';

void main() {
  group("Login Password Validator Tests", () {
    test('should return null when password length is 6', () {
      expect(loginPasswordValidator("123456"), isNull);
    });
    test('should return null when password length is more than 6', () {
      expect(loginPasswordValidator("1234567"), isNull);
    });
    test('should return error message when password length is less than 6', () {
      expect(loginPasswordValidator("12345"),
          "Password should contain at least 6 characters");
    });
    test('should return error message when password is empty', () {
      expect(loginPasswordValidator(""),
          "Password should contain at least 6 characters");
    });
    test('should return error message when password is null', () {
      expect(loginPasswordValidator(null),
          "Password should contain at least 6 characters");
    });
  });
}
