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
  bool loginFailed = false;
  String errorText = "";

  Future<dynamic> register() async {
    widget.currentScreen.value = "register";
  }

  Future<dynamic> login() async {
    LoginFormData data = LoginFormData(
        email: emailController.text, password: passwordController.text);
    dynamic response = await UserService.login(data);
    if (response.runtimeType == Error) {
      loginFailed = true;
      setState(() {
        loginFailed = true;
        errorText = response.text;
      });
    } else if (response.runtimeType == User) {
      widget.user.value = response;
      StorageHelper.write("accessToken", response?.accessToken);
      StorageHelper.write("refreshToken", response?.refreshToken);
      debugPrint('response: ${response?.accessToken}');
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
                                  Visibility(
                                      visible: loginFailed,
                                      child: Text(errorText,
                                          style: const TextStyle(
                                              color: Colors.red, height: 1))),
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
