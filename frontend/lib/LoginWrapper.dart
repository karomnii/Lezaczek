import 'package:flutter/material.dart';
import 'package:frontend/helpers/storage_helper.dart';

import 'Button.dart';
import '../InputField.dart';
import 'models/user.dart';
import 'models/error.dart';
import 'services/user_service.dart';

class LoginWrapper extends StatefulWidget {
  const LoginWrapper({super.key, required this.user});
  final ValueNotifier<User?> user;
  @override
  State<LoginWrapper> createState() => _LoginWrapperState();
}
class _LoginWrapperState extends State<LoginWrapper> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool loginFailed = false;
  String errorText = "";

  Future<dynamic> login() async {
    LoginFormData data = LoginFormData(email: emailController.text, password: passwordController.text);
    dynamic response = await UserService.login(data);
    if (response.runtimeType == Error){
      loginFailed = true;
      errorText = response.text;
    }
    else if (response.runtimeType == User){
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
    return Padding(
      padding: const EdgeInsets.all(30),
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 40,),
            Container(decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
              child: Column(
                children: <Widget>[
                  InputField(textController: emailController, hintText: "Email"),
                  InputField(textController: passwordController, hintText: "Password", obscureText: true, enableSuggestions: false, autocorrect: false)],
              )
            ),
            const SizedBox(height: 40,),
            const Text(
              "Forgot password",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 40,),
            Button(callback: login),
          ],
        ),
      )
    );
  }
}