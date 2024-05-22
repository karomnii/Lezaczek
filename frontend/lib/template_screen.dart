import 'package:flutter/material.dart';

import 'incoming_events.dart';
import 'pages/calendar/calendar.dart';
class TemplateScreen extends StatefulWidget {
  const TemplateScreen({super.key});

  @override
  State<TemplateScreen> createState() => _TemplateScreenState();
}

class _TemplateScreenState extends State<TemplateScreen> {
  int internIndex = 0;
   final List<Widget> screens = [
    Calendar(),
    IncomingEvents(),
   ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[internIndex],
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (index){
          setState(() {
            internIndex = index;
          });
        },
        selectedIndex: internIndex,
        destinations: [
          NavigationDestination(
            selectedIcon: Icon(
              Icons.calendar_month_rounded,
              size: 30,
              color: Color(0xff3EB467),
            ),
              icon:Icon(
                Icons.calendar_month_rounded,
                size: 30,
              ),
              label: 'Plan zajęć',
          ),
          NavigationDestination(
              selectedIcon: Icon(
                Icons.newspaper,
                size: 30,
                color: Color(0xff0DB1D6),
              ),
              icon: Icon(Icons.newspaper,
            size: 30,
          ),
              label: 'Wydarzenia',
          ),
        ],
        backgroundColor: Colors.white38,
        elevation: 0.6,
        indicatorColor: Colors.grey[200],
      ),
    );
  }
}
