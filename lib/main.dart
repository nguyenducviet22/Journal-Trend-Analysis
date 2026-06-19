import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/navigation/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/profile/presentation/blocs/theme_cubit.dart';
import 'injection_container.dart';

void main() async {
  // Ensure framework services are active
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize easy localization
  await EasyLocalization.ensureInitialized();

  // Initialize local Hive database
  await Hive.initFlutter();
  await Hive.openBox('analytics_cache');
  await Hive.openBox('search_history');

  // Configure GetIt locator registrations
  await configureDependencies();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('vi')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: BlocProvider<ThemeCubit>(
        create: (context) => getIt<ThemeCubit>(),
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return MaterialApp.router(
          title: 'Journal Trend Analysis',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,
          routerConfig: appRouter,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
