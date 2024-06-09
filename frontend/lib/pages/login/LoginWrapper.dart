import 'package:flutter/material.dart';
import 'package:frontend/helpers/storage_helper.dart';

import '../../components/Button.dart';
import '../../components/Header.dart';
import 'InputField.dart';
import '../../models/user.dart';
import '../../models/error.dart';
import '../../services/user_service.dart';

class LoginWrapper extends StatefulWidget {
  const LoginWrapper(
      {super.key, required this.user, required this.currentScreen});

  final ValueNotifier<User?> user;
  final ValueNotifier<String> currentScreen;

  @override
  State<LoginWrapper> createState() => _LoginWrapperState();
}

class _LoginWrapperState extends State<LoginWrapper> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<dynamic> register() async {
    widget.currentScreen.value = "register";
  }

  Future<dynamic> login() async {
    LoginFormData data = LoginFormData(
        email: emailController.text, password: passwordController.text);
    dynamic response = await UserService.login(data);
    if (response.runtimeType == Error && mounted) {
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Zamknij',
                        )
                    ),
                  ],
                )
              ],
              title: const Text('Login failed'),
              content: Text(response.text ?? "Unexpected error"),
              contentTextStyle: const TextStyle(
                  fontSize: 16,
                  color: Colors.black
              ),
            ),
      );
    } else if (response.runtimeType == User) {
      widget.user.value = response;
      StorageHelper.write("accessToken", response.accessToken);
      StorageHelper.write("refreshToken", response.refreshToken);
      StorageHelper.write("name", response.name);
      StorageHelper.write("surname", response.surname);
      StorageHelper.write("email", response.email);
      StorageHelper.write("gender", response.gender.index.toString());
    }

    return response;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      const SizedBox(height: 80),
      const Header(),
      Expanded(
          child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(100),
                    topRight: Radius.circular(100),
                  )),
              child: Padding(
                  padding: const EdgeInsets.only(
                      left: 30, right: 30, top: 30, bottom: 5),
                  child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: Column(
                        children: <Widget>[
                          const SizedBox(
                            height: 40,
                          ),
                          Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: <Widget>[
                                  InputField(
                                      textController: emailController,
                                      hintText: "Email"),
                                  InputField(
                                      textController: passwordController,
                                      hintText: "Password",
                                      obscureText: true,
                                      enableSuggestions: false,
                                      autocorrect: false)
                                ],
                              )),
                          const SizedBox(
                            height: 20,
                          ),
                          Button(callback: login, text: "Login"),
                          const SizedBox(
                            height: 10,
                          ),
                          Button(callback: register, text: "Sign Up"),
                        ],
                      )))))
    ]);
  }
}
