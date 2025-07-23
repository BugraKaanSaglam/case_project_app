// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:case_project_app/api/api_services.dart';
import 'package:case_project_app/database/db_helper.dart';
import 'package:case_project_app/helper/error_dialog.dart';
import 'package:case_project_app/helper/navigator_services.dart';
import 'package:case_project_app/global/global_variables.dart';
import 'package:case_project_app/screens/main_screen.dart';

class AuthViewModel extends ChangeNotifier {
  bool isSignIn = true;
  bool isRememberMe = globalDatabase.isRememberLogin;

  void toggleMode() {
    isSignIn = !isSignIn;
    notifyListeners();
  }

  void setRememberMe(bool? value) {
    isRememberMe = value ?? false;
    notifyListeners();
  }

  Future<void> signUp(BuildContext context, String name, String email, String password, String password2, GlobalKey<FormState> formKey) async {
    if (!formKey.currentState!.validate()) return;

    if (password.trim() != password2.trim()) {
      await showAnimatedErrorDialog(context, title: 'error'.tr(), message: 'sifreler_eslesmiyor'.tr());
      return;
    }

    try {
      await ApiService.instance.register(context: context, email: email.trim(), name: name.trim(), password: password.trim());

      isSignIn = true;
      notifyListeners();

      await showAnimatedErrorDialog(context, title: 'basarili'.tr(), message: 'giris_yapabilirsiniz'.tr(), backgroundColor: Colors.blueGrey);
    } catch (e) {
      await showAnimatedErrorDialog(context, title: 'error'.tr(), message: 'kayit_hatasi'.tr(args: [e.toString()]));
    }
  }

  Future<void> signIn(BuildContext context, String email, String password, GlobalKey<FormState> formKey) async {
    if (!formKey.currentState!.validate()) return;

    showDialog(context: context, barrierDismissible: false, builder: (_) => const Center(child: CircularProgressIndicator()));

    try {
      await ApiService.instance.login(context: context, email: email.trim(), password: password.trim());

      if (isRememberMe) {
        globalDatabase.loginEmail = email;
        globalDatabase.loginSifre = password;
      } else {
        globalDatabase.loginEmail = '';
        globalDatabase.loginSifre = '';
      }
      globalDatabase.isRememberLogin = isRememberMe;
      await DBHelper().update(globalDatabase);

      Navigator.of(context, rootNavigator: true).pop();
      NavigationService.instance.navigatorKey.currentState!.pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const MainScreen()), (route) => false);
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop();
      await showAnimatedErrorDialog(context, title: 'error'.tr(), message: 'giris_bilgileri_hata'.tr(args: [e.toString()]));
    }
  }
}
