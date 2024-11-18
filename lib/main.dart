import 'package:flutter/services.dart';
import 'package:hotshi/screens/splash.dart';
import 'theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_value/shared_value.dart';
import 'package:toastification/toastification.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(
    SharedValue.wrapApp(
      const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: MaterialApp(
        title: 'Hotshi chat',
        debugShowCheckedModeBanner: false,
        theme: lightThemeData(context),
        darkTheme: darkThemeData(context),
        themeMode: ThemeMode.light,
        home: const SplashScreen(),
      ),
    );
  }
}
