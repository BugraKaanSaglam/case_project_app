import 'package:flutter/material.dart';
import '../global/global_scaffold.dart';
import '../global/global_variables.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return globalScaffold(title: 'Kurtlar Vadisi Quiz', body: mainBody());
  }

  Widget mainBody() {
    return SizedBox(height: screenHeight, width: screenWidth, child: Column(children: []));
  }
}
