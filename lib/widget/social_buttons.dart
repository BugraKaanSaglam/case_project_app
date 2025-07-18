import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SocialLoginButtons extends StatelessWidget {
  final VoidCallback onGoogleTap;
  final VoidCallback onAppleTap;
  final VoidCallback onFacebookTap;

  const SocialLoginButtons({super.key, required this.onGoogleTap, required this.onAppleTap, required this.onFacebookTap});

  @override
  Widget build(BuildContext context) {
    const spacing = SizedBox(width: 16);
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [_SocialButton(icon: FontAwesomeIcons.google, onTap: onGoogleTap), spacing, _SocialButton(icon: FontAwesomeIcons.apple, onTap: onAppleTap), spacing, _SocialButton(icon: FontAwesomeIcons.facebookF, onTap: onFacebookTap)]);
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _SocialButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: onTap, child: Container(width: 50, height: 50, decoration: BoxDecoration(color: Colors.grey.shade800, borderRadius: BorderRadius.circular(8)), child: Center(child: FaIcon(icon, size: 24, color: Colors.white))));
  }
}
