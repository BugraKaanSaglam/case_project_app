import 'package:case_project_app/global/global_variables.dart';
import 'package:case_project_app/viewmodels/auth_viewmodels.dart';
import 'package:case_project_app/widget/languagetoggle_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import '../global/global_scaffold.dart';
import '../widget/social_buttons.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  AuthScreenState createState() => AuthScreenState();
}

class AuthScreenState extends State<AuthScreen> with SingleTickerProviderStateMixin {
  TextStyle style = TextStyle(color: Colors.white, fontSize: textScaler.scale(18));
  final _signInFormKey = GlobalKey<FormState>();
  final _signUpFormKey = GlobalKey<FormState>();
  final _signInEmailController = TextEditingController();
  final _signInPasswordController = TextEditingController();
  final _signUpNameController = TextEditingController();
  final _signUpEmailController = TextEditingController();
  final _signUpPasswordController = TextEditingController();
  final _signUpPassword2Controller = TextEditingController();
  Locale? _prevLocale;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locale = context.locale;
    if (_prevLocale != locale) {
      _prevLocale = locale;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _signInEmailController.text = globalDatabase.loginEmail;
    _signInPasswordController.text = globalDatabase.loginSifre;
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
    return ChangeNotifierProvider<AuthViewModel>(
      create: (_) => AuthViewModel(),
      child: Consumer<AuthViewModel>(
        builder: (context, vm, _) {
          return globalScaffold(isBackButtonVisible: false, title: '', body: _authBody(context, vm));
        },
      ),
    );
  }

  Widget _authBody(BuildContext context, AuthViewModel vm) {
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
        child: vm.isSignIn ? _buildSignIn(context, vm) : _buildSignUp(context, vm),
      ),
    );
  }

  Widget _buildSignIn(BuildContext context, AuthViewModel vm) {
    return Container(
      key: const ValueKey('SignIn'),
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(gradient: LinearGradient(colors: [Colors.black87, Colors.black54], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      child: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _signInFormKey,
            child: Column(
              children: [
                Text('merhabalar'.tr(), style: TextStyle(color: Colors.white, fontSize: textScaler.scale(32), fontWeight: FontWeight.bold)),
                const SizedBox(height: 30),
                TextFormField(controller: _signInEmailController, style: style, decoration: InputDecoration(labelText: 'email'.tr(), labelStyle: TextStyle(fontSize: textScaler.scale(16), color: Colors.white70)), validator: (v) => v!.isEmpty ? 'email_bos'.tr() : null),
                const SizedBox(height: 24),
                TextFormField(controller: _signInPasswordController, obscureText: true, style: style, decoration: InputDecoration(labelText: 'sifre'.tr(), labelStyle: TextStyle(fontSize: textScaler.scale(16), color: Colors.white70)), validator: (v) => v!.isEmpty ? 'sifre_bos'.tr() : null),
                const SizedBox(height: 20),
                ElevatedButton(onPressed: () => vm.signIn(context, _signInEmailController.text, _signInPasswordController.text, _signInFormKey), style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrangeAccent), child: Text('giris'.tr(), style: TextStyle(fontSize: textScaler.scale(18), fontWeight: FontWeight.bold))),
                const SizedBox(height: 20),

                Row(children: [Checkbox(value: vm.isRememberMe, onChanged: vm.setRememberMe), Text('beni_hatirla'.tr(), style: TextStyle(color: Colors.white70, fontSize: textScaler.scale(16)))]),
                const SizedBox(height: 20),
                SocialLoginButtons(onGoogleTap: () {}, onAppleTap: () {}, onFacebookTap: () {}),
                const SizedBox(height: 20),
                LanguageToggleButton(),
                const SizedBox(height: 20),
                TextButton(onPressed: vm.toggleMode, child: Text('kayit_ol'.tr(), style: TextStyle(color: Colors.lightBlueAccent, fontSize: textScaler.scale(16)))),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignUp(BuildContext context, AuthViewModel vm) {
    return Container(
      key: const ValueKey('SignUp'),
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(gradient: LinearGradient(colors: [Colors.black87, Colors.black54], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      child: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _signUpFormKey,
            child: Column(
              children: [
                Text('hosgeldiniz'.tr(), style: TextStyle(color: Colors.white, fontSize: textScaler.scale(28), fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                TextFormField(controller: _signUpNameController, decoration: InputDecoration(labelText: 'isim'.tr()), style: style, validator: (v) => v!.isEmpty ? 'isim_bos'.tr() : null),
                const SizedBox(height: 16),
                TextFormField(controller: _signUpEmailController, decoration: InputDecoration(labelText: 'email'.tr()), style: style, validator: (v) => v!.isEmpty ? 'email_bos'.tr() : null),
                const SizedBox(height: 16),
                TextFormField(controller: _signUpPasswordController, obscureText: true, style: style, decoration: InputDecoration(labelText: 'sifre'.tr()), validator: (v) => v!.isEmpty ? 'sifre_bos'.tr() : null),
                const SizedBox(height: 16),
                TextFormField(controller: _signUpPassword2Controller, obscureText: true, style: style, decoration: InputDecoration(labelText: 'sifre_tekrar'.tr()), validator: (v) => v!.isEmpty ? 'sifre_bos'.tr() : null),
                const SizedBox(height: 24),
                ElevatedButton(onPressed: () => vm.signUp(context, _signUpNameController.text, _signUpEmailController.text, _signUpPasswordController.text, _signUpPassword2Controller.text, _signUpFormKey), style: ElevatedButton.styleFrom(backgroundColor: Colors.tealAccent), child: Text('kaydol'.tr(), style: TextStyle(fontSize: textScaler.scale(18), fontWeight: FontWeight.bold))),
                const SizedBox(height: 16),
                SocialLoginButtons(onGoogleTap: () {}, onAppleTap: () {}, onFacebookTap: () {}),
                TextButton(onPressed: vm.toggleMode, child: Text('giris_yap'.tr(), style: TextStyle(color: Colors.lightBlueAccent, fontSize: textScaler.scale(16)))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
