import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:money_care/app/bindings/app_binding.dart';
import 'package:money_care/app/router/app_router.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:money_care/core/storage/local_storage.dart';
import 'package:money_care/core/theme/app_theme.dart';
import 'package:money_care/core/localization/app_translations.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('vi', null);
  await initializeDateFormatting('en', null);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dotenv.load(fileName: ".env");
  final storage = LocalStorage();
  await storage.init();
  runApp(MainApp(storage: storage));
}

class MainApp extends StatelessWidget {
  final LocalStorage storage;
  const MainApp({super.key, required this.storage});

  Locale _parseLocale(String localeString) {
    final parts = localeString.split('_');
    return Locale(parts[0], parts.length > 1 ? parts[1] : '');
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Money Care',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: storage.getDarkMode() ? ThemeMode.dark : ThemeMode.light,
      translations: AppTranslations(),
      locale: _parseLocale(storage.getLocale()),
      fallbackLocale: const Locale('vi', 'VN'),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('vi', 'VN'), Locale('en', 'US')],
      getPages: appPages,
      initialRoute: RoutePath.splash,
      initialBinding: AppBinding(storage: storage),
    );
  }
}
