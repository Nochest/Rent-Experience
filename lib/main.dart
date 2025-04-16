import 'package:flutter/material.dart';
import 'package:tesis_airbnb_web/routes/router.dart';
import 'package:tesis_airbnb_web/theme/light_theme.dart';
import 'package:tesis_airbnb_web/utils/custom_scroll_behavior.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      scrollBehavior: MyCustomScrollBehavior(),
      debugShowCheckedModeBanner: false,
      title: 'Airbnb tesis v1.0',
      theme: LightTheme.mainlightTheme,
      routerConfig: AppRouter.router,
    );
  }
}
