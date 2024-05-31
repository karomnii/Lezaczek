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
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  Gender genderControllerValue = Gender.male;

  Future<dynamic> register() async {
    if(!emailRegex.hasMatch(emailController.text)){
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
              title: const Text('Error'),
              content: const Text('Invalid email format'),
              contentTextStyle: const TextStyle(
                  fontSize: 16,
                  color: Colors.black
              ),
            ),
      );
      emailController.text = "";
      return null;
    }
    RegisterFormData data = RegisterFormData(email: emailController.text,
        password: passwordController.text,
        name: nameController.text,
        surname: surnameController.text,
        gender: genderControllerValue);

    dynamic response = await UserService.register(data);
    if(mounted) {
      if (response.runtimeType == Error || response == null) {
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
                title: const Text('Sign up failed'),
                content: Text(
                    response != null ? response.text : "Unknown error"),
                contentTextStyle: const TextStyle(
                    fontSize: 16,
                    color: Colors.black
                ),
              ),
        );
        return null;
      }
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
                          widget.currentScreen.value = "login";
                        },
                        child: const Text(
                          'Zamknij',
                        )
                    ),
                  ],
                )
              ],
              title: const Text('Sign up successful'),
              content: const Text('You can now login to your account'),
              contentTextStyle: const TextStyle(
                  fontSize: 16,
                  color: Colors.black
              ),
            ),
      );
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
                                      value: genderControllerValue,
                                      icon: const Icon(
                                          Icons.arrow_downward_sharp),
                                      elevation: 16,
                                      onChanged: (Gender? value) {
                                        setState(() {
                                          genderControllerValue = value!;
                                        });
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
