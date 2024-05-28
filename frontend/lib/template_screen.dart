import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/LoginPage.dart';
import 'package:frontend/helpers/storage_helper.dart';
import 'package:frontend/side_bar.dart';

import 'incoming_events.dart';
import 'pages/calendar/calendar.dart';
import 'models/user.dart';

class TemplateScreen extends StatefulWidget {
  final ValueNotifier<User?> user;
  const TemplateScreen({super.key, required this.user});

  @override
  State<TemplateScreen> createState() => _TemplateScreenState();
}

class _TemplateScreenState extends State<TemplateScreen> {
  int internIndex = 0;
   final List<Widget> screens = [
    const Calendar(),
    const IncomingEvents(),
   ];

  @override
  void initState() {
    super.initState();
    String? accessToken;
    String? refreshToken;
    StorageHelper.get("accessToken").then((val) => accessToken = val);
    StorageHelper.get("refreshToken").then((val) => refreshToken = val);
    if (refreshToken != null && accessToken != null){
      widget.user.value = User(accessToken: accessToken!, refreshToken: refreshToken!);
    }
  }
  // static Widget buildWidgetWithListenableValue(dynamic widget, ValueListenable value) {
  //   return ValueListenableBuilder(valueListenable: value, builder: (context, value, child) { return widget.call(number: value); });
  // }
  // Widget LoginPageWidget = buildWidgetWithListenableValue(LoginPage, user);
  @override
  Widget build(BuildContext context) {
      return ValueListenableBuilder<User?>(
          valueListenable: widget.user,
          builder: (BuildContext context, User? userValue, Widget? child) {
            if (userValue == null) {
              return LoginPage(user: widget.user);
            };
            return Scaffold(
              drawer: SideBar(user: widget.user),
              body: screens[internIndex],
              bottomNavigationBar: NavigationBar(
                animationDuration: const Duration(milliseconds: 600),
                onDestinationSelected: (index) {
                  setState(() {
                    internIndex = index;
                  });
                },
                selectedIndex: internIndex,
                destinations: const [
                  NavigationDestination(
                    selectedIcon: Icon(
                      Icons.calendar_month_rounded,
                      size: 30,
                      color: Color(0xff3EB467),
                    ),
                    icon: Icon(
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
        );
      }
  }

