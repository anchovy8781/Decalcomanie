import 'package:flutter_test/flutter_test.dart';
import 'package:mirrortube/common/models/result.dart';

void main() {
  group('Success', () {
    const result = Success<int>(42);

    test('reports success', () {
      expect(result.isSuccess, isTrue);
      expect(result.isFailure, isFalse);
    });

    test('exposes the value and no error', () {
      expect(result.valueOrNull, 42);
      expect(result.errorOrNull, isNull);
    });

    test('fold runs the onSuccess branch', () {
      final folded = result.fold(
        onSuccess: (value) => 'ok:$value',
        onFailure: (message) => 'err:$message',
      );
      expect(folded, 'ok:42');
    });
  });

  group('Failure', () {
    const result = Failure<int>('boom');

    test('reports failure', () {
      expect(result.isSuccess, isFalse);
      expect(result.isFailure, isTrue);
    });

    test('exposes the message and no value', () {
      expect(result.valueOrNull, isNull);
      expect(result.errorOrNull, 'boom');
    });

    test('fold runs the onFailure branch', () {
      final folded = result.fold(
        onSuccess: (value) => 'ok:$value',
        onFailure: (message) => 'err:$message',
      );
      expect(folded, 'err:boom');
    });

    test('retains an optional cause', () {
      final cause = Exception('root');
      final failure = Failure<int>('boom', cause);
      expect(failure.cause, cause);
    });
  });
}
