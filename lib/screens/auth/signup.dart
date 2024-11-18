import 'package:flutter/material.dart';
import 'package:hotshi/repositories/auth_repository.dart';
import 'package:hotshi/screens/messages.dart';

import '../../components/primary_button.dart';
import '../../constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../shared_value_helper.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool formError = false;
  String formErrorMsg = '';

  String userName = '';
  String token = '';

  @override
  void initState() {
    super.initState();
    _checkUser();
  }

  // Check user
  void _checkUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userName = prefs.getString('user_name') ?? '';
    token = prefs.getString('access_token') ?? '';

    if (token.isNotEmpty) {
      final route = MaterialPageRoute(
        builder: (BuildContext context) => const MessagesScreen(),
      );

      // ignore: use_build_context_synchronously
      Navigator.pushAndRemoveUntil(context, route, (route) => false);
    }
  }

  void _signup() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var name = _nameController.text.toString();

    var loginResponse = await AuthRepository().getSignupResponse(name);

    if (loginResponse?['errors'] != null) {
      formErrorMsg = loginResponse?['message'];
      formError = true;
      setState(() {});
    } else {
      await prefs.setString(
          'user_name', '${name[0].toUpperCase()}${name.substring(1)}');
      await prefs.setInt('user_id', loginResponse?['data']['id']);
      await prefs.setString('auth_user_id', '${loginResponse?['data']['id']}');
      await prefs.setString(
          'access_token', '${loginResponse?['data']['token']}');
      await prefs.setBool('welcome_screen', true);

      // Shared value
      // auth_user_id.$ = '${loginResponse?['data']['id']}';
      // user_id.$ = loginResponse?['data']['id'];
      user_name.$ = '${name[0].toUpperCase()}${name.substring(1)}';
      access_token.$ = loginResponse?['data']['token'];
      // setState(() {});

      final route = MaterialPageRoute(
        builder: (BuildContext context) => const MessagesScreen(),
      );

      // ignore: use_build_context_synchronously
      Navigator.pushAndRemoveUntil(context, route, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(flex: 2),
              const Text(
                'Sign up',
                style: TextStyle(
                  fontSize: 40,
                ),
              ),
              const Text(
                'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(
                height: 20,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Le nom ne doit pas être vide';
                        }

                        if (value.length < 3) {
                          return 'Le nom doit avoir au moins 3 caractères';
                        }

                        if (value.contains('@') ||
                            value.contains('[') ||
                            value.contains(']')) {
                          return 'veuillez saisir un nom valide';
                        }

                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Votre nom',
                        errorText: formError ? formErrorMsg : null,
                        filled: true,
                        fillColor: primaryColor.withOpacity(0.10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onChanged: (value) {
                        // clear submission error of email field
                        setState(() {
                          formError = false;
                          formErrorMsg = '';
                        });
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    PrimaryButton(
                      text: "Sign up",
                      press: () => {
                        if (_formKey.currentState!.validate())
                          {
                            _signup(),
                          }
                      },
                    ),
                  ],
                ),
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
