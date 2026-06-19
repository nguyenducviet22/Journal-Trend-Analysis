import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/network/api_client.dart';
import 'injection_container.config.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
Future<void> configureDependencies() async => getIt.init();

@module
abstract class RegisterModule {
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  @lazySingleton
  ApiClient get apiClient => ApiClient();

  @lazySingleton
  Connectivity get connectivity => Connectivity();

  @lazySingleton
  @Named('analyticsBox')
  Box get analyticsBox => Hive.box('analytics_cache');

  @lazySingleton
  @Named('searchBox')
  Box get searchBox => Hive.box('search_history');
}
