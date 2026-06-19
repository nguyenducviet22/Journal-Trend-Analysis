import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../injection_container.dart';
import '../../../personalization/domain/entities/user_preferences.dart';
import '../../../personalization/domain/usecases/get_user_preferences_usecase.dart';
import '../../../../core/usecases/usecase.dart';
import '../blocs/theme_cubit.dart';
import '../../../personalization/data/datasources/personalization_local_data_source.dart';
import '../../../keywords/data/datasources/keywords_local_data_source.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserPreferences? _prefs;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserPrefs();
  }

  void _loadUserPrefs() async {
    final usecase = getIt<GetUserPreferencesUseCase>();
    final result = await usecase(const NoParams());
    if (mounted) {
      result.fold(
        (failure) => setState(() => _isLoading = false),
        (prefs) => setState(() {
          _prefs = prefs;
          _isLoading = false;
        }),
      );
    }
  }

  void _clearCacheAndReset(BuildContext context) async {
    // Clear Hive caching databases
    await getIt<KeywordsLocalDataSource>().clearCache();
    // Clear personalization preferences in SharedPreferences
    await getIt<PersonalizationLocalDataSource>().clearUserPreferences();

    if (context.mounted) {
      context.go('/setup');
    }
  }

  void _showClearCacheDialog(BuildContext context) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('profile.clear_cache'.tr()),
          content: Text('profile.clear_cache_desc'.tr()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                'profile.clear_cache_cancel'.tr(),
                style: TextStyle(color: theme.colorScheme.onBackground.withOpacity(0.6)),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                _clearCacheAndReset(context);
              },
              child: Text(
                'profile.clear_cache_confirm'.tr(),
                style: TextStyle(color: theme.colorScheme.error, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'profile.title'.tr(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Profile Header Card
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        side: BorderSide(color: theme.dividerColor.withOpacity(0.1)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 30.0,
                              backgroundColor: theme.colorScheme.primary.withOpacity(0.15),
                              child: Text(
                                _prefs != null && _prefs!.fullName.isNotEmpty ? _prefs!.fullName[0] : 'R',
                                style: TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _prefs?.fullName ?? 'Researcher',
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4.0),
                                  Text(
                                    _prefs?.interestConceptName ?? 'No interest selected',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.onBackground.withOpacity(0.6),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32.0),

                    // Settings Section Header
                    Text(
                      'profile.settings'.tr(),
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12.0),

                    // Theme selector
                    BlocBuilder<ThemeCubit, ThemeMode>(
                      builder: (context, currentThemeMode) {
                        return _buildSettingItem(
                          context,
                          title: 'profile.theme'.tr(),
                          icon: Icons.dark_mode_outlined,
                          trailing: DropdownButton<ThemeMode>(
                            value: currentThemeMode,
                            underline: const SizedBox.shrink(),
                            onChanged: (ThemeMode? newMode) {
                              if (newMode != null) {
                                context.read<ThemeCubit>().setTheme(newMode);
                              }
                            },
                            items: [
                              DropdownMenuItem(
                                value: ThemeMode.light,
                                child: Text('profile.theme_light'.tr()),
                              ),
                              DropdownMenuItem(
                                value: ThemeMode.dark,
                                child: Text('profile.theme_dark'.tr()),
                              ),
                              DropdownMenuItem(
                                value: ThemeMode.system,
                                child: Text('profile.theme_system'.tr()),
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    // Language selector
                    _buildSettingItem(
                      context,
                      title: 'profile.language'.tr(),
                      icon: Icons.language,
                      trailing: DropdownButton<Locale>(
                        value: context.locale,
                        underline: const SizedBox.shrink(),
                        onChanged: (Locale? newLocale) {
                          if (newLocale != null) {
                            context.setLocale(newLocale);
                          }
                        },
                        items: const [
                          DropdownMenuItem(
                            value: Locale('en'),
                            child: Text('English'),
                          ),
                          DropdownMenuItem(
                            value: Locale('vi'),
                            child: Text('Tiếng Việt'),
                          ),
                        ],
                      ),
                    ),

                    // Clear Cache Action
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      leading: Icon(Icons.delete_outline, color: theme.colorScheme.error),
                      title: Text(
                        'profile.clear_cache'.tr(),
                        style: TextStyle(color: theme.colorScheme.error, fontWeight: FontWeight.w500),
                      ),
                      onTap: () => _showClearCacheDialog(context),
                    ),

                    const SizedBox(height: 32.0),

                    // About section
                    Text(
                      'profile.about'.tr(),
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12.0),

                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        side: BorderSide(color: theme.dividerColor.withOpacity(0.05)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'profile.about_desc'.tr(),
                              style: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
                            ),
                            const Divider(height: 24.0),
                            Text(
                              'profile.version'.tr(),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onBackground.withOpacity(0.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildSettingItem(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Widget trailing,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 4.0),
        leading: Icon(icon, color: theme.colorScheme.onBackground.withOpacity(0.7)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: trailing,
      ),
    );
  }
}
