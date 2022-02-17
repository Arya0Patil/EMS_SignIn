import 'dart:async';

import 'package:flutter/material.dart';
import 'package:login_ui/screens/loginScreen.dart';
import 'package:lottie/lottie.dart';

class splashPage extends StatelessWidget {
  const splashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 5), () {
      print("timer ");
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => signInPage()));
    });
    return Container(
      child: Lottie.asset("assets/lottie01.json"),
    );
  }
}
