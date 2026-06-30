import 'package:flutter_test/flutter_test.dart';
import 'package:mirrortube/core/utils/extensions.dart';

void main() {
  group('IntFormatting.toSubscriberCount', () {
    test('keeps small numbers as-is', () {
      expect(0.toSubscriberCount(), '0');
      expect(999.toSubscriberCount(), '999');
    });

    test('formats thousands with 천', () {
      expect(1000.toSubscriberCount(), '1.0천');
      expect(9500.toSubscriberCount(), '9.5천');
    });

    test('formats ten-thousands with 만', () {
      expect(10000.toSubscriberCount(), '1.0만');
      expect(15000.toSubscriberCount(), '1.5만');
    });

    test('formats hundred-millions with 억', () {
      expect(100000000.toSubscriberCount(), '1.0억');
    });
  });

  group('DateTimeFormatting.toRelativeTime', () {
    test('returns 방금 전 for very recent times', () {
      final now = DateTime.now();
      expect(now.toRelativeTime(), '방금 전');
    });

    test('returns minutes for times within the hour', () {
      final tenMinutesAgo = DateTime.now().subtract(
        const Duration(minutes: 10),
      );
      expect(tenMinutesAgo.toRelativeTime(), '10분 전');
    });

    test('returns hours for times within the day', () {
      final threeHoursAgo = DateTime.now().subtract(
        const Duration(hours: 3),
      );
      expect(threeHoursAgo.toRelativeTime(), '3시간 전');
    });

    test('returns days for times within the week', () {
      final twoDaysAgo = DateTime.now().subtract(
        const Duration(days: 2),
      );
      expect(twoDaysAgo.toRelativeTime(), '2일 전');
    });
  });

  group('StringExtension.capitalize', () {
    test('returns empty for empty input', () {
      expect(''.capitalize, '');
    });

    test('capitalizes the first character', () {
      expect('hello'.capitalize, 'Hello');
      expect('a'.capitalize, 'A');
    });

    test('leaves already-capitalized strings unchanged', () {
      expect('World'.capitalize, 'World');
    });
  });
}
