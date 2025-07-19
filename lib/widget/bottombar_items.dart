import 'package:case_project_app/dto/movie_dto.dart';
import 'package:case_project_app/screens/main_screen.dart';
import 'package:case_project_app/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

List<Widget> bottomBarItems(BuildContext context, Widget widget, List<MovieDTO> favoriteMovies) {
  final isHome = widget is MainScreen;
  final isProfile = widget is ProfileScreen;

  return [
    //Home Button
    OutlinedButton.icon(onPressed: isHome ? null : () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const MainScreen()), (route) => false), icon: FaIcon(FontAwesomeIcons.house, color: isHome ? Colors.white30 : Colors.white), label: Text('Anasayfa', style: TextStyle(color: isHome ? Colors.white30 : Colors.white))),

    //Profile Button
    OutlinedButton.icon(onPressed: isProfile ? null : () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen(favoriteMovies: favoriteMovies))), icon: FaIcon(FontAwesomeIcons.user, color: isProfile ? Colors.white30 : Colors.white), label: Text('Profil', style: TextStyle(color: isProfile ? Colors.white30 : Colors.white))),
  ];
}
