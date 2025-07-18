// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

Widget globalScaffold({required String title, required Widget body, List<Widget> bottomBarItems = const [], bool isBackButtonVisible = true, bool isAppbarVisible = true}) {
  return Scaffold(backgroundColor: Colors.black87, extendBodyBehindAppBar: true, appBar: isAppbarVisible ? globalAppbar(title, isBackButtonVisible) : null, body: globalBody(body), bottomNavigationBar: bottomBarItems.isNotEmpty ? globalBottomNavigationBar(items: bottomBarItems) : null);
}

SafeArea globalBody(Widget body) {
  return SafeArea(child: Stack(children: [SafeArea(child: body)]));
}

AppBar globalAppbar(String title, bool isBackButtonVisible) {
  return AppBar(
    backgroundColor: Colors.transparent,
    centerTitle: true,
    elevation: 0,
    //Title
    title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22)),
    //BackButton
    leading: isBackButtonVisible ? Builder(builder: (context) => IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () async => Navigator.maybePop(context))) : const SizedBox.shrink(),
  );
}

BottomNavigationBar globalBottomNavigationBar({required List<Widget> items}) {
  return BottomNavigationBar(backgroundColor: Colors.black.withOpacity(0.5), items: items.map((item) => BottomNavigationBarItem(icon: item, label: '')).toList(), selectedItemColor: Colors.white, unselectedItemColor: Colors.white70, showUnselectedLabels: false, showSelectedLabels: false);
}
