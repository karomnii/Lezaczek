import 'package:flutter/material.dart';


import 'Button2.dart';
import 'InputField2.dart';

class InputWrapper2 extends StatelessWidget {
  const InputWrapper2({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        children: <Widget>[
          const SizedBox(height: 40,),
          Container(decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
            child: const InputField2(),
          ),
          // SizedBox(height: 40,),
          // Text(
          //   "Forgot password",
          //   style: TextStyle(color: Colors.grey),
          // ),
          const SizedBox(height: 40,),
          const Button2(),
        ],
      ),
    );
  }
}