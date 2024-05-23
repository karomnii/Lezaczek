import 'package:flutter/material.dart';

import 'Button.dart';
import '../InputField.dart';

class InputWrapper extends StatelessWidget {
  const InputWrapper({super.key});

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
              child: const InputField(),
            ),
            const SizedBox(height: 40,),
            const Text(
              "Forgot password",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 40,),
            const Button(),
          ],
        ),
      )
    );
  }
}