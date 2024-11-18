import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hotshi/screens/auth/signup.dart';
import 'package:hotshi/screens/messages.dart';
import 'package:hotshi/screens/welcome.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../shared_value_helper.dart';
import '../constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool welcomeScreen = false;
  String userName = '';
  int userId = 0;
  String token = '';

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    Future.delayed(const Duration(seconds: 5), () async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      welcomeScreen = prefs.getBool('welcome_screen') ?? false;
      welcomeScreen ? '' : await prefs.setBool('welcome_screen', true);
      userName = prefs.getString('user_name') ?? '';
      userId = prefs.getInt('user_id') ?? 0;
      token = prefs.getString('access_token') ?? '';

      if (token.isEmpty) {
        await prefs.remove('welcome_screen');
        await prefs.remove('user_name');
        await prefs.remove('user_id');
        await prefs.remove('auth_user_id');
        await prefs.remove('access_token');

        final route = MaterialPageRoute(
          builder: (BuildContext context) => const WelcomeScreen(),
        );

        // ignore: use_build_context_synchronously
        Navigator.pushAndRemoveUntil(context, route, (route) => false);
      }

      // await prefs.remove('welcome_screen');
      // await prefs.remove('user_name');
      // await prefs.remove('user_id');
      // await prefs.remove('auth_user_id');
      // await prefs.remove('access_token');

      // await int.parse(user_id).load();
      // await auth_user_id.load();
      await user_name.load();
      await access_token.load();

      // Route
      final route = MaterialPageRoute(
        builder: (BuildContext context) => welcomeScreen
            ? (token != '' ? const MessagesScreen() : const SignupScreen())
            : const WelcomeScreen(),
      );

      // ignore: use_build_context_synchronously
      Navigator.pushAndRemoveUntil(context, route, (route) => false);
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'hotshi ',
                style: TextStyle(
                  fontFamily: 'AfterNight',
                  color: Colors.white,
                  fontSize: 90,
                ),
              ),
            ]),
      ),
    );
  }
}
