// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../global/global_scaffold.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return globalScaffold(title: 'Profilim', body: profileBody());
  }

  Widget profileBody() {
    return Padding(padding: const EdgeInsets.all(16), child: Center());
  }
}
