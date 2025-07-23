import 'package:case_project_app/dto/movie_dto.dart';
import 'package:case_project_app/helper/navigator_services.dart';
import 'package:case_project_app/screens/main_screen.dart';
import 'package:case_project_app/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:easy_localization/easy_localization.dart';

List<Widget> bottomBarItems(BuildContext context, Widget widget, List<MovieDTO> favoriteMovies) {
  final isHome = widget is MainScreen;
  final isProfile = widget is ProfileScreen;

  return [
    //Home
    OutlinedButton.icon(onPressed: isHome ? null : () => NavigationService.instance.navigatorKey.currentState!.pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const MainScreen()), (route) => false), icon: FaIcon(FontAwesomeIcons.house, color: isHome ? Colors.white30 : Colors.white), label: Text('anasayfa'.tr(), style: TextStyle(color: isHome ? Colors.white30 : Colors.white))),

    //Profile
    OutlinedButton.icon(onPressed: isProfile ? null : () => NavigationService.instance.navigatorKey.currentState!.push(MaterialPageRoute(builder: (_) => ProfileScreen(favoriteMovies: favoriteMovies))), icon: FaIcon(FontAwesomeIcons.user, color: isProfile ? Colors.white30 : Colors.white), label: Text('profil'.tr(), style: TextStyle(color: isProfile ? Colors.white30 : Colors.white))),
  ];
}
