import 'package:flutter/material.dart';
import 'package:medlembre/screens/login_screen.dart';
import 'package:provider/provider.dart';
import 'models/reminders_model.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => RemindersModel(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
    );
  }
}
  