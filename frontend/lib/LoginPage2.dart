import 'package:flutter/material.dart';

import 'Header.dart';
import 'InputWrapper2.dart';

class LoginPage2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   // title: Text('L'),
      // ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter, colors: [
            Color(0xFF41BF6D), // Pierwszy kolor: 41BF6D
            Color(0xFF49D3F2), // Drugi kolor: 49D3F2
          ]),
        ),
        child: Column(
          children: <Widget>[
            SizedBox(height: 80),
            Header(),
            Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(70),
                        topRight: Radius.circular(70),
                      )),
                  child: InputWrapper2(),
                ))
          ],
        ),
      ),
    );
  }
}