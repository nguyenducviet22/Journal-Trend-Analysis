import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:injectable/injectable.dart';

abstract class IFirebaseRemoteConfigService {
  Future<void> initialize();
  int getInt(String key);
  String getString(String key);
  Future<bool> fetchAndActivate();
}

@LazySingleton(as: IFirebaseRemoteConfigService)
class FirebaseRemoteConfigService implements IFirebaseRemoteConfigService {
  final FirebaseRemoteConfig _remoteConfig;

  FirebaseRemoteConfigService() : _remoteConfig = FirebaseRemoteConfig.instance;

  @override
  Future<void> initialize() async {
    await _remoteConfig.setDefaults(const {
      'max_journals_limit': 10,
      'max_keywords_limit': 10,
    });
    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 40),
      minimumFetchInterval: const Duration(minutes: 5),
    ));
  }

  @override
  int getInt(String key) => _remoteConfig.getInt(key);

  @override
  String getString(String key) => _remoteConfig.getString(key);

  @override
  Future<bool> fetchAndActivate() async {
    try {
      return await _remoteConfig.fetchAndActivate();
    } catch (_) {
      return false;
    }
  }
}
