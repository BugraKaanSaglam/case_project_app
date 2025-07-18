import 'package:case_project_app/global/global_variables.dart';
import 'package:flutter/material.dart';

Future<String?> showAnimatedErrorDialog(BuildContext context, {required String title, required String message, Color? backgroundColor, Color? titleColor, Color? messageColor, Color? buttonColor, Color? buttonTextColor}) {
  return showGeneralDialog<String?>(
    context: context,
    barrierDismissible: false,
    barrierLabel: 'ErrorDialog',
    pageBuilder: (context, animation, secondaryAnimation) {
      return Container();
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final scale = Tween<double>(begin: 0.7, end: 1.0).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutBack));
      final opacity = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: animation, curve: Curves.easeIn));
      return Opacity(opacity: opacity.value, child: Transform.scale(scale: scale.value, child: AnimatedErrorDialogContent(title: title, message: message, backgroundColor: backgroundColor, titleColor: titleColor, messageColor: messageColor, buttonColor: buttonColor, buttonTextColor: buttonTextColor)));
    },
  );
}

class AnimatedErrorDialogContent extends StatelessWidget {
  final String title;
  final String message;
  final Color? backgroundColor;
  final Color? titleColor;
  final Color? messageColor;
  final Color? buttonColor;
  final Color? buttonTextColor;

  const AnimatedErrorDialogContent({super.key, required this.title, required this.message, this.backgroundColor, this.titleColor, this.messageColor, this.buttonColor, this.buttonTextColor});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      backgroundColor: backgroundColor ?? Colors.redAccent.shade700,
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [Text(title, style: TextStyle(fontSize: textScaler.scale(24), fontWeight: FontWeight.bold, color: titleColor ?? Colors.white), textAlign: TextAlign.center), const SizedBox(height: 16), Text(message, style: TextStyle(color: messageColor ?? Colors.white70, fontSize: textScaler.scale(16)), textAlign: TextAlign.center), const SizedBox(height: 16), ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: buttonColor ?? Colors.black54, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12)), onPressed: () async => Navigator.of(context).pop(), child: Text('Tamam', style: TextStyle(color: buttonTextColor ?? Colors.white, fontSize: textScaler.scale(16))))],
        ),
      ),
    );
  }
}
