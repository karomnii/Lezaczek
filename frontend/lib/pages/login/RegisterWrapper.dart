import 'package:flutter/material.dart';
import 'package:frontend/services/user_service.dart';

import '../../components/Button.dart';
import 'package:frontend/models/error.dart';
import 'InputField.dart';
import '../../models/user.dart';


class RegisterWrapper extends StatefulWidget {
  const RegisterWrapper({super.key, required this.currentScreen});

  final ValueNotifier<String> currentScreen;

  @override
  State<RegisterWrapper> createState() => _RegisterWrapperState();
}

class _RegisterWrapperState extends State<RegisterWrapper> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  bool registrationFailed = false;
  String errorText = "Unknown error";
  Gender genderControllerValue = Gender.male;

  Future<dynamic> register() async {
    RegisterFormData data = RegisterFormData(email: emailController.text,
        password: passwordController.text,
        name: nameController.text,
        surname: surnameController.text,
        gender: genderControllerValue);
    dynamic response = await UserService.register(data);
    if (response.runtimeType == Error || response == null) {
      setState(() {
        registrationFailed = true;
        errorText = response?.text;
      });
    }
  }

  Future<void> backToLogin() async {
    widget.currentScreen.value = "login";
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    surnameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
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
                      child: Column(children: <Widget>[
                        const SizedBox(
                          height: 40,
                        ),
                        Column(
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
                                        textController: nameController,
                                        hintText: "Name"),
                                    InputField(
                                        textController: surnameController,
                                        hintText: "Surname"),
                                    DropdownButton(
                                      value: Gender.male,
                                      icon: const Icon(
                                          Icons.arrow_downward_sharp),
                                      elevation: 16,
                                      onChanged: (Gender? value) {
                                        genderControllerValue = value!;
                                      },
                                      items: Gender.values.map((Gender gender) {
                                        return DropdownMenuItem<Gender>(
                                          value: gender,
                                          child: Text(gender.label),
                                        );
                                      }).toList(),
                                      hint: const Text("Gender"),
                                    ),
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
                            Button(callback: register, text: "Sign Up"),
                            const SizedBox(
                              height: 10,
                            ),
                            Button(callback: backToLogin, text: "Go back"),
                          ],
                        )
                      ])))))
    ]);
  }
}
