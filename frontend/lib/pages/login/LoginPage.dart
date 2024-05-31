import 'package:flutter/material.dart';
import 'LoginWrapper.dart';
import 'RegisterWrapper.dart';
import '../../models/user.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key, required this.user});

  final ValueNotifier<User?> user;
  final ValueNotifier<String> activeScreenNotifier = ValueNotifier("login");

  Future<void> register() async {}

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: activeScreenNotifier,
        builder: (BuildContext context, String activeScreen, Widget? child) =>
            Scaffold(
                body: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient:
                          LinearGradient(begin: Alignment.topCenter, colors: [
                        Color(0xFF41BF6D), // Pierwszy kolor: 41BF6D
                        Color(0xFF49D3F2), // Drugi kolor: 49D3F2
                      ]),
                    ),
                    child: activeScreen == "login"
                        ? LoginWrapper(
                            user: user,
                            currentScreen: activeScreenNotifier,
                          )
                        : RegisterWrapper(
                            currentScreen: activeScreenNotifier))));
  }
}
