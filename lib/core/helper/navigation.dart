import 'package:flutter/material.dart';

enum AppNavigation {
  push,
  pushReplacement,
  pushAndRemoveUntil,
}

abstract class AppNavigationType {
  static navigate(BuildContext context,
      {required Widget page, required AppNavigation type}) {
    var route = MaterialPageRoute(builder: (context) => page);
    switch (type) {
      case AppNavigation.push:
        return Navigator.push(context, route);
      case AppNavigation.pushReplacement:
        return Navigator.pushReplacement(context, route);

      case AppNavigation.pushAndRemoveUntil:
        return Navigator.pushAndRemoveUntil(
            context, route, (Route<dynamic> route) => false);
    }
  }

  
  // ✅ جديد: navigation بدون context
  static navigateWithKey(GlobalKey<NavigatorState> key,
      {required Widget page, required AppNavigation type}) {
    var route = MaterialPageRoute(builder: (context) => page);
    switch (type) {
      case AppNavigation.push:
        return key.currentState?.push(route);
      case AppNavigation.pushReplacement:
        return key.currentState?.pushReplacement(route);
      case AppNavigation.pushAndRemoveUntil:
        return key.currentState
            ?.pushAndRemoveUntil(route, (Route<dynamic> route) => false);
    }}
     
}
