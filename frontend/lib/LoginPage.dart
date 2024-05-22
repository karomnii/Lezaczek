import 'package:flutter/material.dart';
import 'Header.dart';
import 'InputWrapper.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter, colors: [
            Color(0xFF41BF6D), // Pierwszy kolor: 41BF6D
            Color(0xFF49D3F2), // Drugi kolor: 49D3F2
          ]),
        ),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 80),
            const Header(),
            Expanded(
                child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(100),
                    topRight: Radius.circular(100),
                  )),
              child: const InputWrapper(),
            ))
          ],
        ),
      ),
    );
  }
}
