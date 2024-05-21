import 'package:flutter/material.dart';

class Calendar extends StatelessWidget {
  const Calendar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Plan zajęć',
        ),
        centerTitle: true,
        scrolledUnderElevation: 0.0,
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: Text(
            'In development',
            style: TextStyle(
              fontSize: 24
            ),
          ),
        ),
      )
    );
  }
}
