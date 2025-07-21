import 'package:case_project_app/global/global_variables.dart';
import 'package:case_project_app/viewmodels/auth_viewmodels.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../global/global_scaffold.dart';
import '../widget/social_buttons.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  AuthScreenState createState() => AuthScreenState();
}

class AuthScreenState extends State<AuthScreen> with SingleTickerProviderStateMixin {
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
    super.initState();
    _signInEmailController.text = globalDatabase.loginEmail; // initial from local DB
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
          return globalScaffold(
            isBackButtonVisible: false,
            title: '',
            body: Padding(
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
            ),
          );
        },
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
                Text('Merhabalar', style: TextStyle(color: Colors.white, fontSize: textScaler.scale(32), fontWeight: FontWeight.bold)),
                const SizedBox(height: 30),
                TextFormField(controller: _signInEmailController, style: TextStyle(color: Colors.white, fontSize: textScaler.scale(18)), decoration: InputDecoration(labelText: 'Email', labelStyle: TextStyle(fontSize: textScaler.scale(16), color: Colors.white70)), validator: (v) => v!.isEmpty ? 'Email boş bırakılamaz' : null),
                const SizedBox(height: 24),
                TextFormField(controller: _signInPasswordController, obscureText: true, style: TextStyle(color: Colors.white, fontSize: textScaler.scale(18)), decoration: InputDecoration(labelText: 'Şifre', labelStyle: TextStyle(fontSize: textScaler.scale(16), color: Colors.white70)), validator: (v) => v!.isEmpty ? 'Şifre boş bırakılamaz' : null),
                const SizedBox(height: 20),
                ElevatedButton(onPressed: () => vm.signIn(context, _signInEmailController.text, _signInPasswordController.text, _signInFormKey), style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrangeAccent), child: Text('GİRİŞ', style: TextStyle(fontSize: textScaler.scale(18), fontWeight: FontWeight.bold))),
                Row(children: [Checkbox(value: vm.isRememberMe, onChanged: vm.setRememberMe), Text('Beni Hatırla', style: TextStyle(color: Colors.white70, fontSize: textScaler.scale(16)))]),
                SocialLoginButtons(onGoogleTap: () {}, onAppleTap: () {}, onFacebookTap: () {}),
                TextButton(onPressed: vm.toggleMode, child: Text('Kayıt Ol', style: TextStyle(color: Colors.lightBlueAccent, fontSize: textScaler.scale(16)))),
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
                Text('Hoşgeldiniz', style: TextStyle(color: Colors.white, fontSize: textScaler.scale(28), fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                TextFormField(controller: _signUpNameController, decoration: InputDecoration(labelText: 'İsim'), validator: (v) => v!.isEmpty ? 'İsim boş bırakılamaz' : null),
                const SizedBox(height: 16),
                TextFormField(controller: _signUpEmailController, decoration: InputDecoration(labelText: 'Email'), validator: (v) => v!.isEmpty ? 'Email boş bırakılamaz' : null),
                const SizedBox(height: 16),
                TextFormField(controller: _signUpPasswordController, obscureText: true, decoration: InputDecoration(labelText: 'Şifre'), validator: (v) => v!.isEmpty ? 'Şifre boş bırakılamaz' : null),
                const SizedBox(height: 16),
                TextFormField(controller: _signUpPassword2Controller, obscureText: true, decoration: InputDecoration(labelText: 'Şifre Tekrar'), validator: (v) => v!.isEmpty ? 'Şifre boş bırakılamaz' : null),
                const SizedBox(height: 24),
                ElevatedButton(onPressed: () => vm.signUp(context, _signUpNameController.text, _signUpEmailController.text, _signUpPasswordController.text, _signUpPassword2Controller.text, _signUpFormKey), style: ElevatedButton.styleFrom(backgroundColor: Colors.tealAccent), child: Text('KAYDOL', style: TextStyle(fontSize: textScaler.scale(18), fontWeight: FontWeight.bold))),
                SocialLoginButtons(onGoogleTap: () {}, onAppleTap: () {}, onFacebookTap: () {}),
                TextButton(onPressed: vm.toggleMode, child: Text('Giriş Yap', style: TextStyle(color: Colors.lightBlueAccent, fontSize: textScaler.scale(16)))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
