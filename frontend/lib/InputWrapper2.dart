import 'package:flutter/material.dart';


import 'Button2.dart';
import 'InputField2.dart';

class InputWrapper2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(30),
      child: Column(
        children: <Widget>[
          SizedBox(height: 40,),
          Container(decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
            child: InputField2(),
          ),
          // SizedBox(height: 40,),
          // Text(
          //   "Forgot password",
          //   style: TextStyle(color: Colors.grey),
          // ),
          SizedBox(height: 40,),
          Button2(),
        ],
      ),
    );
  }
}