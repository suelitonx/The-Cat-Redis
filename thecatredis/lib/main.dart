import 'package:flutter/material.dart';
import 'package:thecatredis/pages/home_page.dart';
import 'package:thecatredis/pages/login_page.dart';

import 'services/auth_service.dart';
import 'services/theme/theme.dart';
import 'services/theme/theme_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final authService = AuthService.instance;

  await authService.init();

  runApp(MyApp(authService: authService));
}

class MyApp extends StatelessWidget {
  final AuthService authService;

  MyApp({super.key, required this.authService});

  final themeService = ThemeModel.instance;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: themeService,
      builder: (BuildContext context, _) {
        return ValueListenableBuilder(
          valueListenable: authService,
          builder: (context, state, _) {
            return MaterialApp(
              title: 'The Cat Redis',
              debugShowCheckedModeBanner: false,
              theme: themeService.isDarkMode ? darkMode : originalMode,
              darkTheme: darkMode,
              themeMode: themeService.isDarkMode ? ThemeMode.dark : ThemeMode.light,
              home: state ? HomePage(authService: authService) : LoginPage(authService: authService),
            );
          },
        );
      },
    );
  }
}
