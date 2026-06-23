import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:injectable/injectable.dart';

abstract class IFirebaseCrashlyticsService {
  Future<void> recordError(dynamic exception, StackTrace? stack);
  Future<void> forceCrash();
}

@LazySingleton(as: IFirebaseCrashlyticsService)
class FirebaseCrashlyticsService implements IFirebaseCrashlyticsService {
  final FirebaseCrashlytics _crashlytics;

  FirebaseCrashlyticsService() : _crashlytics = FirebaseCrashlytics.instance;

  @override
  Future<void> recordError(dynamic exception, StackTrace? stack) async {
    await _crashlytics.recordError(exception, stack);
  }

  @override
  Future<void> forceCrash() async {
    _crashlytics.crash();
  }
}
