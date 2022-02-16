import 'package:flutter/material.dart';
import 'package:login_ui/screens/loginScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        buttonColor: Colors.green[300],
        primarySwatch: Colors.blue,
      ),
      home: const signInPage(),
    );
  }
}
