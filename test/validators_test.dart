import 'package:flutter_test/flutter_test.dart';
import 'package:mirrortube/core/utils/validators.dart';

void main() {
  group('Validators.email', () {
    test('returns error when empty', () {
      expect(Validators.email(''), isNotNull);
      expect(Validators.email(null), isNotNull);
      expect(Validators.email('   '), isNotNull);
    });

    test('returns error for malformed address', () {
      expect(Validators.email('not-an-email'), isNotNull);
      expect(Validators.email('foo@bar'), isNotNull);
      expect(Validators.email('foo@bar.'), isNotNull);
    });

    test('returns null for a valid address', () {
      expect(Validators.email('user@example.com'), isNull);
      expect(Validators.email('first.last+tag@sub.domain.co'), isNull);
    });
  });

  group('Validators.password', () {
    test('returns error when empty', () {
      expect(Validators.password(''), isNotNull);
      expect(Validators.password(null), isNotNull);
    });

    test('returns error when shorter than 8 characters', () {
      expect(Validators.password('Ab1'), isNotNull);
    });

    test('returns error when missing uppercase or digit', () {
      expect(Validators.password('lowercase1'), isNotNull);
      expect(Validators.password('NoDigitsHere'), isNotNull);
    });

    test('returns null for a strong password', () {
      expect(Validators.password('Password1'), isNull);
    });
  });

  group('Validators.confirmPassword', () {
    test('returns error when empty', () {
      expect(Validators.confirmPassword('', 'Password1'), isNotNull);
    });

    test('returns error when it does not match', () {
      expect(Validators.confirmPassword('Other1', 'Password1'), isNotNull);
    });

    test('returns null when it matches', () {
      expect(Validators.confirmPassword('Password1', 'Password1'), isNull);
    });
  });

  group('Validators.nickname', () {
    test('returns error when empty', () {
      expect(Validators.nickname(''), isNotNull);
      expect(Validators.nickname(null), isNotNull);
    });

    test('returns error when too short or too long', () {
      expect(Validators.nickname('a'), isNotNull);
      expect(Validators.nickname('a' * 21), isNotNull);
    });

    test('returns error for disallowed characters', () {
      expect(Validators.nickname('hello world'), isNotNull);
      expect(Validators.nickname('emoji😀'), isNotNull);
    });

    test('returns null for valid nicknames', () {
      expect(Validators.nickname('미러튜브'), isNull);
      expect(Validators.nickname('user_01'), isNull);
      expect(Validators.nickname('a-b.c'), isNull);
    });
  });

  group('Validators.bio', () {
    test('returns null when null or short enough', () {
      expect(Validators.bio(null), isNull);
      expect(Validators.bio(''), isNull);
      expect(Validators.bio('a' * 150), isNull);
    });

    test('returns error when over 150 characters', () {
      expect(Validators.bio('a' * 151), isNotNull);
    });
  });
}
