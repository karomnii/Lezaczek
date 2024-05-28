import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'template_screen.dart';
import 'models/user.dart';
class Button extends StatelessWidget {
  final AsyncCallback callback;
  const Button({super.key, required this.callback});

  @override
  Widget build(BuildContext context) {
    return
      TextButton(
        onPressed: () {
          callback();
        },
      style: TextButton.styleFrom(
        backgroundColor: Colors.cyan[500],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 80)
      ),
        child: const Text(
          'Login',
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
    );
  }
}
