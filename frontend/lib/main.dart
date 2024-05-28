import 'package:flutter/material.dart';
import 'template_screen.dart';
import 'models/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
  final userNotifier = ValueNotifier<User?>(null);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TemplateScreen(user: userNotifier),
    );
  }
}