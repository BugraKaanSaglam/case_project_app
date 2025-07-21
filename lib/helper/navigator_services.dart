import 'package:flutter/widgets.dart';

//* Singleton navigation service using a global NavigatorKey.
class NavigationService {
  NavigationService._();
  static final NavigationService instance = NavigationService._();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  //* Push a named route.
  Future<T?> navigateTo<T extends Object?>(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!.pushNamed<T>(routeName, arguments: arguments);
  }

  //* Replace current route with a named route and clear back stack.
  Future<T?> navigateToAndRemoveUntil<T extends Object?>(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!.pushNamedAndRemoveUntil<T>(routeName, (route) => false, arguments: arguments);
  }

  //* Pop the current route.
  void goBack<T extends Object?>([T? result]) {
    return navigatorKey.currentState!.pop<T>(result);
  }
}
