import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final TextEditingController textController;
  final String hintText;
  final bool obscureText;
  final bool enableSuggestions;
  final bool autocorrect;
  const InputField({super.key, required this.textController, required this.hintText, this.obscureText = false, this.enableSuggestions = true, this.autocorrect = true});

  @override
  Widget build(BuildContext context) {
      return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              border: Border(
            bottom: BorderSide(color: Colors.grey[200] ?? Colors.grey),
          )),
          child: TextField(
            controller: textController,
            obscureText: obscureText,
            enableSuggestions: enableSuggestions,
            autocorrect: autocorrect,
            decoration: InputDecoration(
              hintText: this.hintText,
              hintStyle: TextStyle(color: Colors.grey),
              border: InputBorder.none,
            ),
          )
      );
  }
}
