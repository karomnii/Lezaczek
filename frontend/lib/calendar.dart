import 'package:flutter/material.dart';

class Calendar extends StatelessWidget {
  const Calendar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Plan zajęć',
        ),
        centerTitle: true,
        scrolledUnderElevation: 0.0,
        backgroundColor: Colors.white,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.newspaper,
                size: 30,
              ),
              label: 'Wydarzenia'
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.calendar_month,
                size: 30,
              ),
              label: 'Plan zajęć'
          )
        ],
      ),
    );
  }
}
