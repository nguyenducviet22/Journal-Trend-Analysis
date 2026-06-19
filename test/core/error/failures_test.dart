import 'package:flutter_test/flutter_test.dart';
import 'package:journal_trend_analysis/core/error/failures.dart';

void main() {
  group('Failure Tests', () {
    test('ServerFailure supports equatable value comparison', () {
      const failure1 = ServerFailure('Server error');
      const failure2 = ServerFailure('Server error');
      const failure3 = ServerFailure('Different error');

      expect(failure1, equals(failure2));
      expect(failure1, isNot(equals(failure3)));
    });

    test('CacheFailure supports equatable value comparison', () {
      const failure1 = CacheFailure('Cache error');
      const failure2 = CacheFailure('Cache error');

      expect(failure1, equals(failure2));
    });

    test('NetworkFailure supports equatable value comparison', () {
      const failure1 = NetworkFailure('Network offline');
      const failure2 = NetworkFailure('Network offline');

      expect(failure1, equals(failure2));
    });
  });
}
