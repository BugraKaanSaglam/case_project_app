// ignore_for_file: use_build_context_synchronously

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

  //* Toggles between SignIn and SignUp forms
  void toggleMode() {
    isSignIn = !isSignIn;
    notifyListeners();
  }

  //* Sets the "Remember Me" checkbox
  void setRememberMe(bool? value) {
    isRememberMe = value ?? false;
    notifyListeners();
  }

  //* Handles user sign-up logic
  Future<void> signUp(BuildContext context, String name, String email, String password, String password2, GlobalKey<FormState> formKey) async {
    if (password.trim() != password2.trim()) {
      await showAnimatedErrorDialog(context, title: 'HATA', message: 'Şifreler eşleşmiyor!');
      return;
    }
    if (!formKey.currentState!.validate()) return;

    try {
      await ApiService.instance.register(context: context, email: email.trim(), name: name.trim(), password: password.trim());

      // Switch to SignIn on success
      isSignIn = true;
      notifyListeners();

      await showAnimatedErrorDialog(context, title: 'Başarılı', message: 'Giriş Yapabilirsiniz!', backgroundColor: Colors.blueGrey);
    } catch (e) {
      await showAnimatedErrorDialog(context, title: 'HATA', message: 'Kayıt sırasında bir hata oluştu! ${e.toString()}');
    }
  }

  //* Handles user sign-in logic
  Future<void> signIn(BuildContext context, String email, String password, GlobalKey<FormState> formKey) async {
    if (!formKey.currentState!.validate()) return;

    // Show spinner
    showDialog(
      context: context,
      barrierDismissible: false, // kullanıcı kapatamasın
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await ApiService.instance.login(context: context, email: email.trim(), password: password.trim());

      // Persist credentials if needed
      if (isRememberMe) {
        globalDatabase.loginEmail = email;
        globalDatabase.loginSifre = password;
      } else {
        globalDatabase.loginEmail = '';
        globalDatabase.loginSifre = '';
      }
      globalDatabase.isRememberLogin = isRememberMe;
      await DBHelper().update(globalDatabase);

      // Kapat spinner
      Navigator.of(context, rootNavigator: true).pop();

      // Navigate to MainScreen
      NavigationService.instance.navigatorKey.currentState!.pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const MainScreen()), (route) => false);
    } catch (e) {
      // Close spinner
      Navigator.of(context, rootNavigator: true).pop();

      await showAnimatedErrorDialog(context, title: 'HATA', message: 'Lütfen Giriş Bilgilerinizi Kontrol Ediniz! ${e.toString()}');
    }
  }
}
