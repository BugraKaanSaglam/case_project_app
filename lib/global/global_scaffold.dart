// ignore_for_file: deprecated_member_use

import 'package:case_project_app/helper/navigator_services.dart';
import 'package:flutter/material.dart';

Widget globalScaffold({required String title, required Widget body, List<Widget> bottomBarItems = const [], bool isBackButtonVisible = true, bool isAppbarVisible = true, Widget? trailingButton}) {
  return Scaffold(backgroundColor: Colors.black87, extendBodyBehindAppBar: true, appBar: isAppbarVisible ? globalAppbar(title, isBackButtonVisible, trailingButton) : null, body: globalBody(body), bottomNavigationBar: bottomBarItems.isNotEmpty ? globalBottomNavigationBar(items: bottomBarItems) : null);
}

SafeArea globalBody(Widget body) {
  return SafeArea(child: Stack(children: [SafeArea(child: body)]));
}

AppBar globalAppbar(String title, bool isBackButtonVisible, Widget? trailingButton) {
  return AppBar(
    backgroundColor: Colors.transparent,
    centerTitle: true,
    elevation: 0,
    actions: [trailingButton ?? Center()],
    //Title
    title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22)),
    //BackButton
    leading: isBackButtonVisible ? Builder(builder: (context) => IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () async => NavigationService.instance.navigatorKey.currentState!.maybePop(context))) : const SizedBox.shrink(),
  );
}

BottomNavigationBar globalBottomNavigationBar({required List<Widget> items}) {
  return BottomNavigationBar(type: BottomNavigationBarType.fixed, backgroundColor: Colors.black.withOpacity(0.5), items: items.map((item) => BottomNavigationBarItem(icon: item, label: '')).toList());
}
