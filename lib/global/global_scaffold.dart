// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

Widget globalScaffold({required String title, required Widget body, bool isBackButtonVisible = true}) {
  return Scaffold(backgroundColor: Colors.black87, extendBodyBehindAppBar: true, appBar: globalAppbar(title, isBackButtonVisible), body: globalBody(body));
}

SafeArea globalBody(Widget body) => SafeArea(child: Stack(children: [SafeArea(child: body)]));
AppBar globalAppbar(String title, bool isBackButtonVisible) => AppBar(
  backgroundColor: Colors.transparent,
  centerTitle: true,
  elevation: 0,
  //Title
  title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22)),
  //BackButton
  leading: Builder(builder: (context) => IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () async => Navigator.maybePop(context))),
);
