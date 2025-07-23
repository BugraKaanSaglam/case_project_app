import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:case_project_app/database/db_helper.dart';
import 'package:case_project_app/global/global_variables.dart';

class LanguageToggleButton extends StatefulWidget {
  const LanguageToggleButton({super.key});

  @override
  State<LanguageToggleButton> createState() => _LanguageToggleButtonState();
}

class _LanguageToggleButtonState extends State<LanguageToggleButton> {
  late String _selected;

  @override
  void initState() {
    super.initState();
    _selected = globalDatabase.language.isNotEmpty ? globalDatabase.language : context.locale.languageCode;
  }

  @override
  Widget build(BuildContext context) {
    final isTr = _selected == 'tr';
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(24)),
      child: ToggleButtons(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white70,
        selectedColor: Colors.white,
        fillColor: Colors.blueAccent,
        constraints: const BoxConstraints(minWidth: 60, minHeight: 36),
        isSelected: [isTr, !isTr],
        onPressed: (index) {
          final langCode = index == 0 ? 'tr' : 'en';
          final countryCode = index == 0 ? 'TR' : 'US';
          setState(() => _selected = langCode);
          final newLocale = Locale(langCode, countryCode);
          context.setLocale(newLocale);
          globalDatabase.language = langCode;
          DBHelper().update(globalDatabase);
        },
        children: const [Text('TR', style: TextStyle(fontWeight: FontWeight.bold)), Text('EN', style: TextStyle(fontWeight: FontWeight.bold))],
      ),
    );
  }
}
