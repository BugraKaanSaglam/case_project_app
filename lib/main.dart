import 'package:case_project_app/database/case_database.dart';
import 'package:case_project_app/database/db_helper.dart';
import 'package:case_project_app/enums/language_enum.dart';
import 'package:case_project_app/helper/navigator_services.dart';
import 'package:case_project_app/screens/auth_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'global/global_variables.dart';
import 'helper/media_query_size.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await initDB();
  runApp(EasyLocalization(supportedLocales: const [Locale('en', 'US'), Locale('tr', 'TR')], path: 'assets/translations', fallbackLocale: const Locale('tr', 'TR'), child: const MainApp()));
}

Future<void> initDB() async {
  final dbHelper = DBHelper();
  globalDatabase = await dbHelper.getByVer(1) ?? CaseDatabase(ver: 1, loginEmail: '', loginSifre: '', language: 'tr', isRememberLogin: false);
  await dbHelper.insertOrReplace(globalDatabase);
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => MainAppState();
}

class MainAppState extends State<MainApp> {
  late LanguageEnum languageCode;
  @override
  void initState() {
    super.initState();
    //* Changing Current Language due to Database
    if (globalDatabase.language != '') languageCode = LanguageEnum.getLanguageFromString(globalDatabase.language);
    //* Listen for incoming deep links
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = SizerMediaQuery.getH(context);
    screenWidth = SizerMediaQuery.getW(context);
    textScaler = SizerMediaQuery.getText(context);

    return MaterialApp(
      //* Localization
      locale: context.locale,
      supportedLocales: const [Locale('en', 'US'), Locale('tr', 'TR')],
      localizationsDelegates: context.localizationDelegates,
      //* Navigation
      navigatorKey: NavigationService.instance.navigatorKey,
      debugShowCheckedModeBanner: false,
      home: const AuthScreen(),
    );
  }
}
