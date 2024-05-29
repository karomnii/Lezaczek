import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final AsyncCallback callback;
  final String text;
  const Button({super.key, required this.callback, required this.text});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 180,
        height: 40,
        child: TextButton(
                onPressed: () {
                  callback();
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.cyan[500],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  // padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 80)
                ),
                child: Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
    );
  }
}
