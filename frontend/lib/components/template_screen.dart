import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/pages/login/LoginPage.dart';
import 'package:frontend/helpers/storage_helper.dart';
import 'package:frontend/components/side_bar.dart';

import '../incoming_events.dart';
import '../pages/calendar/calendar.dart';
import '../models/user.dart';

class TemplateScreen extends StatefulWidget {
  const TemplateScreen({super.key});

  @override
  State<TemplateScreen> createState() => _TemplateScreenState();
}

class _TemplateScreenState extends State<TemplateScreen> {
  ValueNotifier<User?> userNotifier = ValueNotifier(null);
  int internIndex = 0;
   final List<Widget> screens = [
    const Calendar(),
    const IncomingEvents(),
   ];
  @override
  void initState() {
    super.initState();
  }
  Future<User?> asyncInitUser() async {
    debugPrint("called asyncInit");
    String? accessToken = await StorageHelper.get("accessToken");
    String? refreshToken = await StorageHelper.get("refreshToken");
    if (refreshToken != null && accessToken != null){
      debugPrint("accessTokenOnInit: ${accessToken}");
      return User(accessToken: accessToken, refreshToken: refreshToken);
    }
    return null;
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(future: asyncInitUser(),
        builder: (BuildContext context, AsyncSnapshot<User?> user) {
          if (user.hasData) {
            userNotifier.value = user.data;
            }
            return ValueListenableBuilder<User?>(
                valueListenable: userNotifier,
                builder: (BuildContext context, User? userValue,
                    Widget? child) {
                  if (userValue == null) {
                    return LoginPage(user: userNotifier);
                  };
                  return Scaffold(
                    drawer: SideBar(user: userNotifier),
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

        });
  }
  }

