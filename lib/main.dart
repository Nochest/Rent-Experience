import 'dart:convert';
import 'dart:developer';
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:tesis_airbnb_web/models/user.dart';
import 'package:tesis_airbnb_web/routes/router.dart';
import 'package:tesis_airbnb_web/theme/light_theme.dart';
import 'package:tesis_airbnb_web/utils/custom_scroll_behavior.dart';

void main() {
  final user = getStoredUser();
  inspect(user);
  String initialRoute = '/';
  if (user != null) {
    switch (user.role) {
      case 'admin':
        initialRoute = '/dashboard';
        break;
      case 'host':
        initialRoute = '/host';
        break;
      case 'guest':
        initialRoute = '/guest';
        break;
    }
  }
  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      scrollBehavior: MyCustomScrollBehavior(),
      debugShowCheckedModeBanner: false,
      title: 'Rent Experience',
      theme: LightTheme.mainlightTheme,
      routerConfig: AppRouter.router(initialRoute),
    );
  }
}

User? getStoredUser() {
  final stored = html.window.localStorage['usuario'];
  if (stored != null) {
    final json = jsonDecode(stored);
    return User.fromJson(json);
  }
  return null;
}
