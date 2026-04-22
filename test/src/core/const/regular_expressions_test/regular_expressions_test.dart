import 'package:cosmospedia/src/core/const/regular_expressions/regex.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RegularExpressions Tests - Username & Password', () {

    group('Username Regex Tests', () {
      test('Validator: Should return true for valid alphanumeric username (6-20 chars)', () {
        expect(RegularExpressions.usernameRegex.hasMatch('Amishi123'), true);
        expect(RegularExpressions.usernameRegex.hasMatch('Space Explorer'), true);
      });

      test('Validator: Should return false if username is too short or too long', () {
        expect(RegularExpressions.usernameRegex.hasMatch('User'), false); // Too short
        expect(RegularExpressions.usernameRegex.hasMatch('ThisUsernameIsWayTooLongForThisRegex'), false); // Too long
      });

      test('Input Formatter: Should allow only alphanumeric and spaces', () {
        expect(RegularExpressions.usernameInput.hasMatch('a'), true);
        expect(RegularExpressions.usernameInput.hasMatch('1'), true);
        expect(RegularExpressions.usernameInput.hasMatch(' '), true);
        expect(RegularExpressions.usernameInput.hasMatch('@'), false); // Special char not allowed
      });
    });

    group('Password Regex Tests', () {
      test('Validator: Should return true for strong password (8-15 chars, Mix of everything)', () {
        // Includes: Lower, Upper, Digit, Special Char
        expect(RegularExpressions.passwordRegex.hasMatch('Abc@12345'), true);
        expect(RegularExpressions.passwordRegex.hasMatch('Strong#Pass1'), true);
      });

      test('Validator: Should return false if criteria not met', () {
        expect(RegularExpressions.passwordRegex.hasMatch('12345678'), false); // No alphabets
        expect(RegularExpressions.passwordRegex.hasMatch('abcdefgh'), false); // No uppercase/digits
        expect(RegularExpressions.passwordRegex.hasMatch('Abc@1'), false);    // Too short (<8)
        expect(RegularExpressions.passwordRegex.hasMatch('Abc@12345678901234'), false); // Too long (>15)
      });

      test('Validator: Should not allow spaces in password', () {
        expect(RegularExpressions.passwordRegex.hasMatch('Abc @12345'), false);
      });
    });
  });
}