import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:money_care/core/bindings/app_binding.dart';
import 'package:money_care/core/router/app_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:money_care/core/storage/local_storage.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('vi', null);
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

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Money Care',
      themeMode: ThemeMode.system,
      getPages: appPages,
      initialRoute: '/splash',
      initialBinding: AppBinding(storage: storage),
    );
  }
}
