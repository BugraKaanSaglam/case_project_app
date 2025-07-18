// ignore_for_file: use_build_context_synchronously
import 'package:case_project_app/api/api_services.dart';
import 'package:case_project_app/database/db_helper.dart';
import 'package:case_project_app/helper/error_dialog.dart';
import 'package:case_project_app/screens/main_screen.dart';
import 'package:case_project_app/widget/social_buttons.dart';
import 'package:flutter/material.dart';
import '../global/global_scaffold.dart';
import '../global/global_variables.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  AuthScreenState createState() => AuthScreenState();
}

class AuthScreenState extends State<AuthScreen> with SingleTickerProviderStateMixin {
  bool isSignIn = true;
  bool isRememberMe = globalDatabase.isRememberLogin;
  final _signInFormKey = GlobalKey<FormState>();
  final _signUpFormKey = GlobalKey<FormState>();
  final _signInEmailController = TextEditingController();
  final _signInPasswordController = TextEditingController();
  final _signUpNameController = TextEditingController();
  final _signUpEmailController = TextEditingController();
  final _signUpPasswordController = TextEditingController();
  final _signUpPassword2Controller = TextEditingController();

  @override
  void initState() {
    _signInEmailController.text = globalDatabase.loginEmail;
    _signInPasswordController.text = globalDatabase.loginSifre;

    super.initState();
  }

  @override
  void dispose() {
    _signInEmailController.dispose();
    _signInPasswordController.dispose();
    _signUpNameController.dispose();
    _signUpEmailController.dispose();
    _signUpPasswordController.dispose();
    _signUpPassword2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return globalScaffold(isBackButtonVisible: false, title: "", body: authBody());
  }

  Widget authBody() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 600),
        transitionBuilder: (child, animation) {
          return AnimatedBuilder(
            animation: animation,
            child: child,
            builder: (context, childWidget) {
              final status = animation.status;
              final color = (status == AnimationStatus.forward || status == AnimationStatus.reverse) ? Colors.black : Colors.blue;
              return Card(color: color, elevation: 4, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), child: ScaleTransition(scale: animation, child: childWidget));
            },
          );
        },
        child: isSignIn ? _buildSignIn(context) : _buildSignUp(context),
      ),
    );
  }

  Widget _buildSignIn(BuildContext context) {
    return Container(
      key: const ValueKey('SignIn'),
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(gradient: LinearGradient(colors: [Colors.black87, Colors.black54], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      child: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _signInFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Merhabalar', style: TextStyle(color: Colors.white, fontSize: textScaler.scale(32), fontWeight: FontWeight.bold)),
                Text('Tempus varius a vitae interdum id tortor elementum tristique eleifend at.', style: TextStyle(color: Colors.white, fontSize: textScaler.scale(16)), textAlign: TextAlign.center),
                const SizedBox(height: 30),
                _buildTextField(controller: _signInEmailController, label: 'Email'),
                const SizedBox(height: 24),
                _buildTextField(controller: _signInPasswordController, label: 'Şifre', obscureText: true),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    await singInPressed();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrangeAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  child: Padding(padding: const EdgeInsets.symmetric(horizontal: 88, vertical: 12), child: Text('GİRİŞ', style: TextStyle(fontSize: textScaler.scale(18), fontWeight: FontWeight.bold))),
                ),
                const SizedBox(height: 12),
                _buildCheckBoxField(),
                const SizedBox(height: 12),
                SocialLoginButtons(onGoogleTap: () {}, onAppleTap: () {}, onFacebookTap: () {}),
                const SizedBox(height: 12),
                TextButton(onPressed: () => setState(() => isSignIn = false), child: Row(children: [Text('Hesabın Yok Mu?', style: TextStyle(color: Colors.white70, fontSize: textScaler.scale(16))), Text(' Kayıt Ol', style: TextStyle(color: Colors.lightBlueAccent, fontSize: textScaler.scale(16)))])),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignUp(BuildContext context) {
    return Container(
      key: const ValueKey('SignUp'),
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(gradient: LinearGradient(colors: [Colors.black87, Colors.black54], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      child: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _signUpFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Hoşgeldiniz', style: TextStyle(color: Colors.white, fontSize: textScaler.scale(28), fontWeight: FontWeight.bold)),
                Text('Tempus varius a vitae interdum id tortor elementum tristique eleifend at.', style: TextStyle(color: Colors.white, fontSize: textScaler.scale(16)), textAlign: TextAlign.center),
                const SizedBox(height: 24),
                _buildTextField(controller: _signUpNameController, label: 'İsim'),
                const SizedBox(height: 16),
                _buildTextField(controller: _signUpEmailController, label: 'Email'),
                const SizedBox(height: 16),
                _buildTextField(controller: _signUpPasswordController, label: 'Şifre', obscureText: true),
                const SizedBox(height: 16),
                _buildTextField(controller: _signUpPassword2Controller, label: 'Şifre Tekrar', obscureText: true),
                const SizedBox(height: 24),
                ElevatedButton(onPressed: () async => await singUpPressed(), style: ElevatedButton.styleFrom(backgroundColor: Colors.tealAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))), child: Padding(padding: const EdgeInsets.symmetric(horizontal: 88, vertical: 12), child: Text('KAYDOL', style: TextStyle(fontSize: textScaler.scale(18), fontWeight: FontWeight.bold)))),
                const SizedBox(height: 12),
                SocialLoginButtons(onGoogleTap: () {}, onAppleTap: () {}, onFacebookTap: () {}),
                const SizedBox(height: 12),
                TextButton(onPressed: () => setState(() => isSignIn = true), child: Row(children: [Text('Zaten Hesabın Var Mı?', style: TextStyle(color: Colors.white70, fontSize: textScaler.scale(16))), Text(' Giriş yap', style: TextStyle(color: Colors.lightBlueAccent, fontSize: textScaler.scale(16)))])),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String label, bool obscureText = false}) {
    return TextFormField(
      controller: controller,
      style: TextStyle(color: Colors.white, fontSize: textScaler.scale(18)),
      obscureText: obscureText,
      cursorColor: Colors.white,
      decoration: InputDecoration(labelText: label, labelStyle: TextStyle(fontSize: textScaler.scale(16), color: Colors.white70), enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white54), borderRadius: BorderRadius.all(Radius.circular(12))), focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white), borderRadius: BorderRadius.all(Radius.circular(12))), errorStyle: TextStyle(fontSize: textScaler.scale(16), color: Colors.redAccent)),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label boş bırakılamaz';
        }
        return null;
      },
    );
  }

  Widget _buildCheckBoxField({String label = 'Beni Hatırla'}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        StatefulBuilder(
          builder: (context, setState) {
            return Checkbox(
              value: isRememberMe,
              onChanged: (value) {
                setState(() {
                  isRememberMe = value ?? false;
                });
              },
              activeColor: Colors.white,
              checkColor: Colors.black,
            );
          },
        ),
        Text(label, style: TextStyle(color: Colors.white70, fontSize: textScaler.scale(22))),
      ],
    );
  }

  Future<void> singUpPressed() async {
    if (_signUpPasswordController.text.trim() != _signUpPassword2Controller.text.trim()) {
      await showAnimatedErrorDialog(context, title: 'HATA', message: 'Şifreler eşleşmiyor!');
      return;
    }
    if (_signUpFormKey.currentState!.validate()) {
      try {
        ApiService().register(email: _signUpEmailController.text.trim(), name: _signUpNameController.text.trim(), password: _signUpPasswordController.text.trim());

        setState(() {
          isSignIn = true;
          _signInEmailController.text = _signUpEmailController.text.trim();
          _signInPasswordController.text = _signUpPasswordController.text.trim();
        });
        await showAnimatedErrorDialog(context, title: 'Başarılı', message: 'Giriş Yapabilirsiniz!', backgroundColor: Colors.blueGrey);
      } catch (e) {
        await showAnimatedErrorDialog(context, title: 'HATA', message: 'Lütfen Giriş Bilgilerinizi Kontrol Ediniz! ${e.toString()}');
      }
    }
  }

  Future<void> singInPressed() async {
    if (_signInFormKey.currentState!.validate()) {
      try {
        //Get Login Data
        loginDTO = await ApiService().login(email: _signInEmailController.text.trim(), password: _signInPasswordController.text.trim());

        if (isRememberMe) {
          globalDatabase.loginEmail = _signInEmailController.text;
          globalDatabase.loginSifre = _signInPasswordController.text;
        } else {
          globalDatabase.loginEmail = '';
          globalDatabase.loginSifre = '';
        }
        globalDatabase.isRememberLogin = isRememberMe;

        await DBHelper().update(globalDatabase);
        await Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const MainScreen()), (Route<dynamic> route) => false);
      } catch (e) {
        await showAnimatedErrorDialog(context, title: 'HATA', message: 'Lütfen Giriş Bilgilerinizi Kontrol Ediniz!, ${e.toString()}');
      }
    }
  }
}
