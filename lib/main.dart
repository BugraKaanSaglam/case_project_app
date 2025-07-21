import 'package:case_project_app/database/case_database.dart';
import 'package:case_project_app/database/db_helper.dart';
import 'package:case_project_app/helper/navigator_services.dart';
import 'package:case_project_app/screens/auth_screen.dart';
import 'package:flutter/material.dart';
import 'global/global_variables.dart';
import 'helper/media_query_size.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDB();
  runApp(const MainApp());
}

Future<void> initDB() async {
  DBHelper dbHelper = DBHelper();
  globalDatabase = await dbHelper.getByVer(1) ?? CaseDatabase(ver: 1, loginEmail: '', loginSifre: '', language: 'tr', isRememberLogin: false);
  await dbHelper.insertOrReplace(globalDatabase);
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});
  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    screenHeight = SizerMediaQuery.getH(context);
    screenWidth = SizerMediaQuery.getW(context);
    textScaler = SizerMediaQuery.getText(context);
    return MaterialApp(navigatorKey: NavigationService.instance.navigatorKey, debugShowCheckedModeBanner: false, home: const AuthScreen());
  }
}
