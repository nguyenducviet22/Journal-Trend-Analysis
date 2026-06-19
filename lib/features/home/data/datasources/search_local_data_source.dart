import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

abstract class SearchLocalDataSource {
  Future<List<String>> getRecentSearches();
  Future<void> saveSearchQuery(String query);
  Future<void> clearRecentSearches();
}

@LazySingleton(as: SearchLocalDataSource)
class SearchLocalDataSourceImpl implements SearchLocalDataSource {
  final Box _box;

  SearchLocalDataSourceImpl(@Named('searchBox') this._box);

  @override
  Future<List<String>> getRecentSearches() async {
    final list = _box.get('history') as List<dynamic>?;
    if (list == null) return [];
    return list.cast<String>();
  }

  @override
  Future<void> saveSearchQuery(String query) async {
    final current = await getRecentSearches();
    // Move to front if already exists
    current.remove(query);
    current.insert(0, query);
    // Limit to top 10 recent searches
    if (current.length > 10) {
      current.removeLast();
    }
    await _box.put('history', current);
  }

  @override
  Future<void> clearRecentSearches() async {
    await _box.delete('history');
  }
}
